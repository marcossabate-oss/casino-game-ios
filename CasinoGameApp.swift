import SwiftUI

@main
struct CasinoGameApp: App {
    @StateObject private var authService = AuthService.shared
    @StateObject private var playerService = PlayerService()
    @StateObject private var gameService = GameService()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(authService)
                .environmentObject(playerService)
                .environmentObject(gameService)
                .preferredColorScheme(.dark)
        }
    }
}
