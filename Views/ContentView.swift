import SwiftUI

struct ContentView: View {
    @StateObject var authService = AuthService.shared
    @StateObject var playerService = PlayerService()
    @StateObject var gameService = GameService()
    @State private var showingLoginSheet = false
    
    var body: some View {
        ZStack {
            if authService.isLoggedIn && authService.currentUser != nil {
                MainTabView()
                    .environmentObject(authService)
                    .environmentObject(playerService)
                    .environmentObject(gameService)
            } else {
                LoginView()
                    .environmentObject(authService)
            }
        }
        .preferredColorScheme(.dark)
    }
}

// MARK: - Main Tab View
struct MainTabView: View {
    @EnvironmentObject var authService: AuthService
    @EnvironmentObject var playerService: PlayerService
    @EnvironmentObject var gameService: GameService
    @State private var selectedTab = 0
    
    var body: some View {
        TabView(selection: $selectedTab) {
            GameSelectionView()
                .tabItem {
                    Label("Games", systemImage: "gamecontroller")
                }
                .tag(0)
            
            WalletView()
                .tabItem {
                    Label("Wallet", systemImage: "wallet.pass")
                }
                .tag(1)
            
            StatsView()
                .tabItem {
                    Label("Stats", systemImage: "chart.bar")
                }
                .tag(2)
            
            ProfileView()
                .tabItem {
                    Label("Profile", systemImage: "person")
                }
                .tag(3)
        }
        .onAppear {
            let appearance = UITabBarAppearance()
            appearance.configureWithOpaqueBackground()
            appearance.backgroundColor = UIColor(Color.black.opacity(0.8))
            UITabBar.appearance().standardAppearance = appearance
            UITabBar.appearance().scrollEdgeAppearance = appearance
        }
    }
}

#Preview {
    ContentView()
}