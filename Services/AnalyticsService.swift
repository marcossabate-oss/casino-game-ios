import Foundation

class AnalyticsService {
    static let shared = AnalyticsService()
    
    private var events: [AnalyticsEvent] = []
    private let encoder = JSONEncoder()
    private let decoder = JSONDecoder()
    
    // MARK: - Event Logging
    func logGamePlayed(_ game: GameType, betAmount: Double, result: Bool, winAmount: Double = 0) {
        let event = AnalyticsEvent(
            type: .gamePlayed,
            gameType: game,
            betAmount: betAmount,
            winAmount: winAmount,
            isWin: result,
            timestamp: Date()
        )
        events.append(event)
        saveEvent(event)
    }
    
    func logGameResult(_ result: GameResult) {
        let event = AnalyticsEvent(
            type: .gameResult,
            gameType: result.gameType,
            betAmount: result.betAmount,
            winAmount: result.winAmount,
            isWin: result.isWin,
            timestamp: result.timestamp
        )
        events.append(event)
        saveEvent(event)
    }
    
    func logUserLogin(username: String) {
        let event = AnalyticsEvent(
            type: .userLogin,
            username: username,
            timestamp: Date()
        )
        events.append(event)
        saveEvent(event)
    }
    
    func logUserLogout(username: String) {
        let event = AnalyticsEvent(
            type: .userLogout,
            username: username,
            timestamp: Date()
        )
        events.append(event)
        saveEvent(event)
    }
    
    func logDeposit(amount: Double, username: String) {
        let event = AnalyticsEvent(
            type: .deposit,
            username: username,
            betAmount: amount,
            timestamp: Date()
        )
        events.append(event)
        saveEvent(event)
    }
    
    func logWithdrawal(amount: Double, username: String) {
        let event = AnalyticsEvent(
            type: .withdrawal,
            username: username,
            betAmount: amount,
            timestamp: Date()
        )
        events.append(event)
        saveEvent(event)
    }
    
    func logAchievementUnlocked(_ achievement: String, username: String) {
        let event = AnalyticsEvent(
            type: .achievement,
            username: username,
            details: achievement,
            timestamp: Date()
        )
        events.append(event)
        saveEvent(event)
    }
    
    func logError(_ error: String, username: String? = nil) {
        let event = AnalyticsEvent(
            type: .error,
            username: username ?? "unknown",
            details: error,
            timestamp: Date()
        )
        events.append(event)
        saveEvent(event)
    }
    
    // MARK: - Statistics
    func getGameStatistics(game: GameType) -> GameStatistics? {
        let gameEvents = events.filter { $0.gameType == game }
        guard !gameEvents.isEmpty else { return nil }
        
        let totalGames = gameEvents.count
        let wins = gameEvents.filter { $0.isWin }.count
        let losses = totalGames - wins
        let totalBet = gameEvents.reduce(0) { $0 + $1.betAmount }
        let totalWinnings = gameEvents.reduce(0) { $0 + $1.winAmount }
        let avgBet = totalBet / Double(totalGames)
        
        return GameStatistics(
            game: game,
            totalGamesPlayed: totalGames,
            wins: wins,
            losses: losses,
            winRate: Double(wins) / Double(totalGames),
            totalBet: totalBet,
            totalWinnings: totalWinnings,
            averageBet: avgBet,
            netProfit: totalWinnings - totalBet
        )
    }
    
    func getOverallStatistics() -> OverallStatistics {
        let totalGames = events.filter { $0.type == .gamePlayed }.count
        let totalWins = events.filter { $0.type == .gamePlayed && $0.isWin }.count
        let totalBet = events.filter { $0.type == .gamePlayed }.reduce(0) { $0 + $1.betAmount }
        let totalWinnings = events.filter { $0.type == .gamePlayed }.reduce(0) { $0 + $1.winAmount }
        let totalDeposits = events.filter { $0.type == .deposit }.reduce(0) { $0 + $1.betAmount }
        let totalWithdrawals = events.filter { $0.type == .withdrawal }.reduce(0) { $0 + $1.betAmount }
        
        return OverallStatistics(
            totalGamesPlayed: totalGames,
            totalWins: totalWins,
            winRate: totalGames > 0 ? Double(totalWins) / Double(totalGames) : 0,
            totalBet: totalBet,
            totalWinnings: totalWinnings,
            netProfit: totalWinnings - totalBet,
            totalDeposited: totalDeposits,
            totalWithdrawn: totalWithdrawals
        )
    }
    
    func getEventsSince(_ date: Date) -> [AnalyticsEvent] {
        return events.filter { $0.timestamp > date }
    }
    
    // MARK: - Persistence
    private func saveEvent(_ event: AnalyticsEvent) {
        // Save to UserDefaults or local database
        if let encoded = try? encoder.encode(event) {
            UserDefaults.standard.set(encoded, forKey: "analytics_\(event.id)")
        }
    }
    
    func clearAnalytics() {
        events.removeAll()
    }
    
    func getEventCount() -> Int {
        return events.count
    }
}

// MARK: - Models
struct AnalyticsEvent: Codable {
    var id: UUID = UUID()
    var type: EventType
    var gameType: GameType?
    var username: String?
    var betAmount: Double = 0
    var winAmount: Double = 0
    var isWin: Bool = false
    var details: String?
    var timestamp: Date
    
    enum EventType: String, Codable {
        case gamePlayed
        case gameResult
        case userLogin
        case userLogout
        case deposit
        case withdrawal
        case achievement
        case error
    }
}

struct GameStatistics: Codable {
    let game: GameType
    let totalGamesPlayed: Int
    let wins: Int
    let losses: Int
    let winRate: Double
    let totalBet: Double
    let totalWinnings: Double
    let averageBet: Double
    let netProfit: Double
}

struct OverallStatistics: Codable {
    let totalGamesPlayed: Int
    let totalWins: Int
    let winRate: Double
    let totalBet: Double
    let totalWinnings: Double
    let netProfit: Double
    let totalDeposited: Double
    let totalWithdrawn: Double
}
