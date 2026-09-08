import Foundation

struct Wallet: Identifiable, Codable {
    var id: UUID = UUID()
    var playerId: UUID
    var balance: Double
    var currency: String = "USD"
    var dailyLimit: Double = 1000
    var weeklyLimit: Double = 5000
    var monthlyLimit: Double = 20000
    var dailySpent: Double = 0
    var weeklySpent: Double = 0
    var monthlySpent: Double = 0
    var lastReset: Date
    var isLocked: Bool = false
    var lockReason: String?
    
    var canDeposit: Bool {
        !isLocked && dailySpent < dailyLimit
    }
    
    var remainingDailyLimit: Double {
        max(0, dailyLimit - dailySpent)
    }
}

// MARK: - Transaction
struct Transaction: Identifiable, Codable {
    var id: UUID = UUID()
    var walletId: UUID
    var type: TransactionType
    var amount: Double
    var description: String
    var timestamp: Date
    var status: TransactionStatus
    var relatedGameResultId: UUID?
    
    enum TransactionType: String, Codable {
        case deposit = "Deposit"
        case withdrawal = "Withdrawal"
        case gameBet = "Game Bet"
        case gameWinning = "Game Winning"
        case bonus = "Bonus"
        case refund = "Refund"
    }
    
    enum TransactionStatus: String, Codable {
        case pending = "Pending"
        case completed = "Completed"
        case failed = "Failed"
        case cancelled = "Cancelled"
    }
}

// MARK: - Payment Method
struct PaymentMethod: Identifiable, Codable {
    var id: UUID = UUID()
    var walletId: UUID
    var type: PaymentMethodType
    var name: String
    var details: String // Masked info (****1234)
    var isDefault: Bool
    var expiryDate: Date?
    var isActive: Bool
    
    enum PaymentMethodType: String, Codable {
        case creditCard = "Credit Card"
        case debitCard = "Debit Card"
        case applePay = "Apple Pay"
        case bank = "Bank Transfer"
        case wallet = "E-Wallet"
    }
}

// MARK: - Bonus
struct Bonus: Identifiable, Codable {
    var id: UUID = UUID()
    var walletId: UUID
    var type: BonusType
    var amount: Double
    var description: String
    var expiryDate: Date
    var isUsed: Bool
    var createdAt: Date
    
    enum BonusType: String, Codable {
        case welcome = "Welcome Bonus"
        case deposit = "Deposit Bonus"
        case referral = "Referral Bonus"
        case seasonal = "Seasonal Bonus"
        case freeSpin = "Free Spin"
    }
}
