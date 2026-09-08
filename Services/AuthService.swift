import Foundation
import Combine

class AuthService: ObservableObject {
    @Published var isLoggedIn = false
    @Published var currentUser: Player?
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    static let shared = AuthService()
    
    // MARK: - Authentication
    func login(username: String, password: String) async -> Bool {
        isLoading = true
        errorMessage = nil
        
        // Simulate API delay
        try? await Task.sleep(nanoseconds: 1_000_000_000)
        
        guard !username.isEmpty, !password.isEmpty else {
            errorMessage = "Username and password required"
            isLoading = false
            return false
        }
        
        guard password.count >= 6 else {
            errorMessage = "Invalid credentials"
            isLoading = false
            return false
        }
        
        // Simulate successful login
        let user = Player(
            username: username,
            email: "\(username)@casino.com",
            balance: 1000.0,
            totalWinnings: 0,
            totalLosses: 0,
            level: 1,
            gamesPlayed: 0,
            joinDate: Date(),
            lastLoginDate: Date(),
            isVerified: true
        )
        
        currentUser = user
        isLoggedIn = true
        isLoading = false
        return true
    }
    
    func signup(username: String, email: String, password: String, confirmPassword: String) async -> Bool {
        isLoading = true
        errorMessage = nil
        
        // Simulate API delay
        try? await Task.sleep(nanoseconds: 1_000_000_000)
        
        // Validation
        guard !username.isEmpty else {
            errorMessage = "Username is required"
            isLoading = false
            return false
        }
        
        guard username.count >= 3 else {
            errorMessage = "Username must be at least 3 characters"
            isLoading = false
            return false
        }
        
        guard isValidEmail(email) else {
            errorMessage = "Invalid email address"
            isLoading = false
            return false
        }
        
        guard password.count >= 6 else {
            errorMessage = "Password must be at least 6 characters"
            isLoading = false
            return false
        }
        
        guard password == confirmPassword else {
            errorMessage = "Passwords do not match"
            isLoading = false
            return false
        }
        
        // Create user
        let newUser = Player(
            username: username,
            email: email,
            balance: 1000.0, // Welcome bonus
            totalWinnings: 0,
            totalLosses: 0,
            level: 1,
            gamesPlayed: 0,
            joinDate: Date(),
            lastLoginDate: Date(),
            isVerified: false
        )
        
        currentUser = newUser
        isLoggedIn = true
        isLoading = false
        return true
    }
    
    func logout() {
        currentUser = nil
        isLoggedIn = false
        errorMessage = nil
    }
    
    func resetPassword(email: String) async -> Bool {
        isLoading = true
        errorMessage = nil
        
        guard isValidEmail(email) else {
            errorMessage = "Invalid email address"
            isLoading = false
            return false
        }
        
        // Simulate API call
        try? await Task.sleep(nanoseconds: 1_000_000_000)
        
        errorMessage = "Password reset link sent to \(email)"
        isLoading = false
        return true
    }
    
    func verifyEmail(_ email: String, code: String) async -> Bool {
        isLoading = true
        errorMessage = nil
        
        guard !code.isEmpty, code.count == 6 else {
            errorMessage = "Invalid verification code"
            isLoading = false
            return false
        }
        
        // Simulate API call
        try? await Task.sleep(nanoseconds: 1_000_000_000)
        
        var user = currentUser
        user?.isVerified = true
        currentUser = user
        
        isLoading = false
        return true
    }
    
    func enableTwoFactor() async -> Bool {
        isLoading = true
        errorMessage = nil
        
        // Simulate API call
        try? await Task.sleep(nanoseconds: 1_000_000_000)
        
        isLoading = false
        return true
    }
    
    // MARK: - Validation Helpers
    private func isValidEmail(_ email: String) -> Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        return NSPredicate(format: "SELF MATCHES %@", emailRegex).evaluate(with: email)
    }
    
    // MARK: - Session Management
    func getSession() -> Player? {
        return currentUser
    }
    
    func isSessionValid() -> Bool {
        return isLoggedIn && currentUser != nil
    }
    
    func refreshSession() async -> Bool {
        guard isLoggedIn else { return false }
        
        // Simulate token refresh
        try? await Task.sleep(nanoseconds: 500_000_000)
        
        return true
    }
}
