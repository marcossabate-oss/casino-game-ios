import Foundation

enum GameType: String, CaseIterable, Codable {
    case slots = "Slots"
    case blackjack = "Blackjack"
    case roulette = "Roulette"
    case poker = "Poker"
    case dice = "Dice"
    
    var emoji: String {
        switch self {
        case .slots:
            return "🎰"
        case .blackjack:
            return "♠️"
        case .roulette:
            return "🎡"
        case .poker:
            return "🃏"
        case .dice:
            return "🎲"
        }
    }
    
    var description: String {
        switch self {
        case .slots:
            return "Match three symbols to win big!"
        case .blackjack:
            return "Get 21 or beat the dealer"
        case .roulette:
            return "Pick a number and spin the wheel"
        case .poker:
            return "Beat other players with your hand"
        case .dice:
            return "Roll the dice and test your luck"
        }
    }
}

// MARK: - Game Result
struct GameResult: Identifiable, Codable {
    var id: UUID = UUID()
    var playerId: UUID
    var gameType: GameType
    var betAmount: Double
    var winAmount: Double
    var timestamp: Date
    var isWin: Bool
    var duration: TimeInterval
    var gameDetails: String
    
    var netAmount: Double {
        isWin ? winAmount - betAmount : -betAmount
    }
}

// MARK: - Game Configuration
struct GameConfig: Codable {
    var minBet: Double
    var maxBet: Double
    var houseEdge: Double
    var payoutMultiplier: Double
    var isActive: Bool
}

// MARK: - Leaderboard Entry
struct LeaderboardEntry: Identifiable, Codable {
    var id: UUID = UUID()
    var playerName: String
    var playerId: UUID
    var score: Double
    var gamesPlayed: Int
    var rank: Int
}
