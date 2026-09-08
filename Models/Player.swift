import Foundation

struct Player: Identifiable, Codable {
    var id: UUID = UUID()
    var username: String
    var email: String
    var balance: Double
    var totalWinnings: Double
    var totalLosses: Double
    var level: Int
    var gamesPlayed: Int
    var joinDate: Date
    var lastLoginDate: Date
    var isVerified: Bool
    
    var winRate: Double {
        guard gamesPlayed > 0 else { return 0 }
        return (totalWinnings / Double(gamesPlayed)) * 100
    }
}

// MARK: - Player Statistics
struct PlayerStats: Codable {
    var playerId: UUID
    var totalGamesPlayed: Int
    var totalWinnings: Double
    var totalLosses: Double
    var favoriteGame: String
    var longestWinStreak: Int
    var currentWinStreak: Int
    var averageBetSize: Double
    var largestWin: Double
    var largestLoss: Double
}
