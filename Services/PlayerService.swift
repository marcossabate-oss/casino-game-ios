import Foundation
import Combine

class PlayerService: ObservableObject {
    @Published var currentPlayer: Player?
    @Published var playerStats: PlayerStats?
    @Published var gameHistory: [GameResult] = []
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    private var gameResults: [GameResult] = []
    
    // MARK: - Player Management
    func createPlayer(username: String, email: String) -> Player {
        let player = Player(
            username: username,
            email: email,
            balance: 1000.0,
            totalWinnings: 0,
            totalLosses: 0,
            level: 1,
            gamesPlayed: 0,
            joinDate: Date(),
            lastLoginDate: Date(),
            isVerified: false
        )
        
        self.currentPlayer = player
        return player
    }
    
    func updatePlayer(_ player: Player) {
        self.currentPlayer = player
    }
    
    func getPlayer(_ id: UUID) async -> Player? {
        // Simulate API call
        return currentPlayer
    }
    
    // MARK: - Wallet Management
    func updateBalance(amount: Double) {
        guard var player = currentPlayer else { return }
        player.balance += amount
        currentPlayer = player
    }
    
    func deductBalance(amount: Double) -> Bool {
        guard var player = currentPlayer, player.balance >= amount else {
            errorMessage = "Insufficient balance"
            return false
        }
        player.balance -= amount
        currentPlayer = player
        return true
    }
    
    func depositFunds(amount: Double) -> Bool {
        guard amount > 0 else {
            errorMessage = "Deposit amount must be positive"
            return false
        }
        updateBalance(amount: amount)
        return true
    }
    
    func withdrawFunds(amount: Double) -> Bool {
        guard amount > 0 else {
            errorMessage = "Withdrawal amount must be positive"
            return false
        }
        return deductBalance(amount: amount)
    }
    
    // MARK: - Game Result Recording
    func recordGameResult(_ result: GameResult) {
        guard var player = currentPlayer else { return }
        
        gameResults.append(result)
        gameHistory.insert(result, at: 0)
        
        // Update player stats
        player.gamesPlayed += 1
        
        if result.isWin {
            player.totalWinnings += result.winAmount
            player.balance += result.winAmount
        } else {
            player.totalLosses += result.betAmount
        }
        
        // Check for level up
        let newLevel = Int(player.totalWinnings / 1000) + 1
        if newLevel > player.level {
            player.level = newLevel
        }
        
        player.lastLoginDate = Date()
        currentPlayer = player
        updateStats()
    }
    
    // MARK: - Statistics
    private func updateStats() {
        guard let player = currentPlayer else { return }
        
        let wins = gameResults.filter { $0.isWin }.count
        let totalWon = gameResults.filter { $0.isWin }.reduce(0) { $0 + $1.winAmount }
        let totalLost = gameResults.filter { !$0.isWin }.reduce(0) { $0 + $1.betAmount }
        let favoriteGame = gameResults.reduce(into: [String: Int]()) { dict, result in
            let key = result.gameType.rawValue
            dict[key, default: 0] += 1
        }.max(by: { $0.value < $1.value })?.key ?? "None"
        
        let largestWin = gameResults.filter { $0.isWin }.max(by: { $0.winAmount < $1.winAmount })?.winAmount ?? 0
        let largestLoss = gameResults.filter { !$0.isWin }.max(by: { $0.betAmount < $1.betAmount })?.betAmount ?? 0
        
        let averageBet = gameResults.isEmpty ? 0 : gameResults.reduce(0) { $0 + $1.betAmount } / Double(gameResults.count)
        
        playerStats = PlayerStats(
            playerId: player.id,
            totalGamesPlayed: player.gamesPlayed,
            totalWinnings: player.totalWinnings,
            totalLosses: player.totalLosses,
            favoriteGame: favoriteGame,
            longestWinStreak: calculateWinStreak(),
            currentWinStreak: calculateCurrentWinStreak(),
            averageBetSize: averageBet,
            largestWin: largestWin,
            largestLoss: largestLoss
        )
    }
    
    private func calculateWinStreak() -> Int {
        var maxStreak = 0
        var currentStreak = 0
        
        for result in gameResults.reversed() {
            if result.isWin {
                currentStreak += 1
                maxStreak = max(maxStreak, currentStreak)
            } else {
                currentStreak = 0
            }
        }
        
        return maxStreak
    }
    
    private func calculateCurrentWinStreak() -> Int {
        var streak = 0
        
        for result in gameResults {
            if result.isWin {
                streak += 1
            } else {
                break
            }
        }
        
        return streak
    }
    
    func getGameHistory(limit: Int = 10) -> [GameResult] {
        return Array(gameHistory.prefix(limit))
    }
    
    func getStats() -> PlayerStats? {
        return playerStats
    }
    
    // MARK: - Level System
    func getLevelProgress() -> Double {
        guard let player = currentPlayer else { return 0 }
        let currentLevelWinnings = player.totalWinnings.truncatingRemainder(dividingBy: 1000)
        return currentLevelWinnings / 1000.0
    }
    
    func getNextLevelRequirement() -> Double {
        guard let player = currentPlayer else { return 1000 }
        let winningsNeeded = Double((player.level + 1) * 1000)
        return winningsNeeded - player.totalWinnings
    }
    
    // MARK: - Achievements
    func checkAchievements() -> [String] {
        var achievements: [String] = []
        guard let stats = playerStats else { return achievements }
        
        if stats.totalGamesPlayed >= 10 {
            achievements.append("First 10 Games")
        }
        if stats.longestWinStreak >= 5 {
            achievements.append("Hot Streak")
        }
        if stats.totalWinnings >= 5000 {
            achievements.append("Big Winner")
        }
        if stats.largestWin >= 1000 {
            achievements.append("Jackpot Hit")
        }
        
        return achievements
    }
}
