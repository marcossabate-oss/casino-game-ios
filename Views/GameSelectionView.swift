import SwiftUI

struct GameSelectionView: View {
    @EnvironmentObject var playerService: PlayerService
    @EnvironmentObject var gameService: GameService
    
    var body: some View {
        NavigationView {
            ZStack {
                // Background gradient
                LinearGradient(
                    gradient: Gradient(colors: [.blue, .purple]),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()
                
                VStack(spacing: 0) {
                    // Header
                    VStack(alignment: .leading, spacing: 8) {
                        Text("🎰 Welcome to Casino")
                            .font(.title2)
                            .fontWeight(.bold)
                        Text("Balance: $\(String(format: "%.2f", playerService.currentPlayer?.balance ?? 0))")
                            .font(.headline)
                            .foregroundColor(.yellow)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding()
                    .background(Color.black.opacity(0.3))
                    
                    // Games Grid
                    ScrollView {
                        VStack(spacing: 16) {
                            ForEach(GameType.allCases, id: \.self) { game in
                                NavigationLink(destination: gameDestination(for: game)) {
                                    GameCard(game: game)
                                }
                            }
                        }
                        .padding()
                    }
                }
            }
            .navigationBarTitleDisplayMode(.inline)
        }
    }
    
    @ViewBuilder
    func gameDestination(for game: GameType) -> some View {
        switch game {
        case .slots:
            SlotsGameView()
        case .blackjack:
            BlackjackGameView()
        case .roulette:
            RouletteGameView()
        case .poker:
            PokerGameView()
        case .dice:
            DiceGameView()
        }
    }
}

// MARK: - Game Card
struct GameCard: View {
    let game: GameType
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                VStack(alignment: .leading, spacing: 8) {
                    Text(game.rawValue)
                        .font(.headline)
                        .fontWeight(.bold)
                    Text(game.description)
                        .font(.caption)
                        .foregroundColor(.gray)
                        .lineLimit(2)
                }
                
                Spacer()
                
                Text(game.emoji)
                    .font(.system(size: 40))
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding()
            .background(
                LinearGradient(
                    gradient: Gradient(colors: [.gray.opacity(0.2), .gray.opacity(0.1)]),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            )
            .cornerRadius(12)
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(Color.white.opacity(0.2), lineWidth: 1)
            )
        }
        .foregroundColor(.white)
    }
}

#Preview {
    GameSelectionView()
        .environmentObject(PlayerService())
        .environmentObject(GameService())
        .preferredColorScheme(.dark)
}