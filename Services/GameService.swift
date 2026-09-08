import Foundation
import Combine

class GameService: ObservableObject {
    @Published var currentBet: Double = 0
    @Published var gameResult: GameResult?
    @Published var isGameActive = false
    @Published var errorMessage: String?
    
    private let playerId: UUID
    
    init(playerId: UUID = UUID()) {
        self.playerId = playerId
    }
    
    // MARK: - Slots Game
    func playSlots(bet: Double) -> GameResult {
        guard bet > 0 else {
            errorMessage = "Invalid bet amount"
            return GameResult(
                playerId: playerId,
                gameType: .slots,
                betAmount: bet,
                winAmount: 0,
                timestamp: Date(),
                isWin: false,
                duration: 0,
                gameDetails: "Invalid bet"
            )
        }
        
        let symbols = ["🍎", "🍊", "🍋", "🍌", "🍉"]
        let reel1 = symbols.randomElement() ?? "🍎"
        let reel2 = symbols.randomElement() ?? "🍎"
        let reel3 = symbols.randomElement() ?? "🍎"
        
        let isWin = reel1 == reel2 && reel2 == reel3
        var winAmount = 0.0
        
        if isWin {
            switch reel1 {
            case "🍎": winAmount = bet * 5
            case "🍊": winAmount = bet * 7
            case "🍋": winAmount = bet * 10
            case "🍌": winAmount = bet * 15
            case "🍉": winAmount = bet * 20
            default: winAmount = bet * 5
            }
        }
        
        let result = GameResult(
            playerId: playerId,
            gameType: .slots,
            betAmount: bet,
            winAmount: winAmount,
            timestamp: Date(),
            isWin: isWin,
            duration: 3.0,
            gameDetails: "\(reel1) \(reel2) \(reel3)"
        )
        
        self.gameResult = result
        return result
    }
    
    // MARK: - Blackjack Game
    func playBlackjack(bet: Double, playerCards: [Int], dealerCards: [Int]) -> GameResult {
        guard bet > 0 else {
            errorMessage = "Invalid bet amount"
            return GameResult(
                playerId: playerId,
                gameType: .blackjack,
                betAmount: bet,
                winAmount: 0,
                timestamp: Date(),
                isWin: false,
                duration: 0,
                gameDetails: "Invalid bet"
            )
        }
        
        let playerSum = playerCards.reduce(0, +)
        let dealerSum = dealerCards.reduce(0, +)
        
        var isWin = false
        var winAmount = 0.0
        var details = "Player: \(playerSum), Dealer: \(dealerSum)"
        
        if playerSum > 21 {
            details = "Player busted!"
        } else if dealerSum > 21 {
            isWin = true
            winAmount = bet * 2
            details = "Dealer busted! Player wins!"
        } else if playerSum > dealerSum {
            isWin = true
            winAmount = bet * 2
            details = "Player wins!"
        } else if playerSum == dealerSum {
            isWin = true
            winAmount = bet
            details = "Push! Money returned."
        } else {
            details = "Dealer wins!"
        }
        
        let result = GameResult(
            playerId: playerId,
            gameType: .blackjack,
            betAmount: bet,
            winAmount: winAmount,
            timestamp: Date(),
            isWin: isWin,
            duration: 5.0,
            gameDetails: details
        )
        
        self.gameResult = result
        return result
    }
    
    // MARK: - Roulette Game
    func playRoulette(bet: Double, selectedNumber: Int) -> GameResult {
        guard bet > 0, selectedNumber >= 0, selectedNumber <= 36 else {
            errorMessage = "Invalid bet or number"
            return GameResult(
                playerId: playerId,
                gameType: .roulette,
                betAmount: bet,
                winAmount: 0,
                timestamp: Date(),
                isWin: false,
                duration: 0,
                gameDetails: "Invalid input"
            )
        }
        
        let spinResult = Int.random(in: 0...36)
        let isWin = spinResult == selectedNumber
        let winAmount = isWin ? bet * 36 : 0.0
        
        let result = GameResult(
            playerId: playerId,
            gameType: .roulette,
            betAmount: bet,
            winAmount: winAmount,
            timestamp: Date(),
            isWin: isWin,
            duration: 2.0,
            gameDetails: "Selected: \(selectedNumber), Result: \(spinResult)"
        )
        
        self.gameResult = result
        return result
    }
    
    // MARK: - Dice Game
    func playDice(bet: Double, predictedSum: Int) -> GameResult {
        guard bet > 0, predictedSum >= 2, predictedSum <= 12 else {
            errorMessage = "Invalid bet or prediction"
            return GameResult(
                playerId: playerId,
                gameType: .dice,
                betAmount: bet,
                winAmount: 0,
                timestamp: Date(),
                isWin: false,
                duration: 0,
                gameDetails: "Invalid input"
            )
        }
        
        let dice1 = Int.random(in: 1...6)
        let dice2 = Int.random(in: 1...6)
        let sum = dice1 + dice2
        
        let isWin = sum == predictedSum
        let winAmount = isWin ? bet * 5 : 0.0
        
        let result = GameResult(
            playerId: playerId,
            gameType: .dice,
            betAmount: bet,
            winAmount: winAmount,
            timestamp: Date(),
            isWin: isWin,
            duration: 1.0,
            gameDetails: "Dice: \(dice1) + \(dice2) = \(sum)"
        )
        
        self.gameResult = result
        return result
    }
    
    // MARK: - Poker Game (Simplified)
    func playPoker(bet: Double, playerHandRank: Int) -> GameResult {
        guard bet > 0 else {
            errorMessage = "Invalid bet amount"
            return GameResult(
                playerId: playerId,
                gameType: .poker,
                betAmount: bet,
                winAmount: 0,
                timestamp: Date(),
                isWin: false,
                duration: 0,
                gameDetails: "Invalid bet"
            )
        }
        
        let dealerHandRank = Int.random(in: 1...10)
        let isWin = playerHandRank > dealerHandRank
        let winAmount = isWin ? bet * 2 : 0.0
        
        let result = GameResult(
            playerId: playerId,
            gameType: .poker,
            betAmount: bet,
            winAmount: winAmount,
            timestamp: Date(),
            isWin: isWin,
            duration: 4.0,
            gameDetails: "Player Rank: \(playerHandRank), Dealer Rank: \(dealerHandRank)"
        )
        
        self.gameResult = result
        return result
    }
    
    // MARK: - Utility Functions
    func calculateHouseEdge(_ gameType: GameType) -> Double {
        switch gameType {
        case .slots:
            return 0.02 // 2%
        case .blackjack:
            return 0.005 // 0.5%
        case .roulette:
            return 0.027 // 2.7%
        case .poker:
            return 0.01 // 1%
        case .dice:
            return 0.015 // 1.5%
        }
    }
    
    func validateBet(_ bet: Double, minBet: Double = 1.0, maxBet: Double = 10000.0) -> Bool {
        return bet >= minBet && bet <= maxBet
    }
}
