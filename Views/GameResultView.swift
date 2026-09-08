import SwiftUI

struct GameResultView: View {
    let result: GameResult
    let onDismiss: () -> Void
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        ZStack {
            if result.isWin {
                LinearGradient(
                    gradient: Gradient(colors: [.green, .mint]),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            } else {
                LinearGradient(
                    gradient: Gradient(colors: [.red, .orange]),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            }
            
            VStack(spacing: 24) {
                Spacer()
                
                // Result Icon
                VStack(spacing: 16) {
                    Text(result.isWin ? "🎉" : "😢")
                        .font(.system(size: 80))
                        .scaleEffect(result.isWin ? 1 : 0.8)
                    
                    Text(result.isWin ? "YOU WON!" : "YOU LOST!")
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                }
                
                // Result Details
                VStack(spacing: 16) {
                    // Game Type
                    HStack {
                        Text("Game")
                            .foregroundColor(.white.opacity(0.7))
                        Spacer()
                        Text(result.gameType.rawValue)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                    }
                    
                    Divider().background(Color.white.opacity(0.2))
                    
                    // Bet Amount
                    HStack {
                        Text("Bet")
                            .foregroundColor(.white.opacity(0.7))
                        Spacer()
                        Text("-$\(String(format: "%.2f", result.betAmount))")
                            .fontWeight(.semibold)
                            .foregroundColor(.yellow)
                    }
                    
                    Divider().background(Color.white.opacity(0.2))
                    
                    // Win Amount
                    if result.isWin {
                        HStack {
                            Text("Winnings")
                                .foregroundColor(.white.opacity(0.7))
                            Spacer()
                            Text("+$\(String(format: "%.2f", result.winAmount))")
                                .fontWeight(.semibold)
                                .foregroundColor(.green)
                        }
                        
                        Divider().background(Color.white.opacity(0.2))
                    }
                    
                    // Net Result
                    HStack {
                        Text("Total")
                            .foregroundColor(.white.opacity(0.7))
                        Spacer()
                        Text(result.isWin ? "+$\(String(format: "%.2f", result.winAmount - result.betAmount))" : "-$\(String(format: "%.2f", result.betAmount))")
                            .fontWeight(.bold)
                            .font(.headline)
                            .foregroundColor(result.isWin ? .green : .red)
                    }
                    
                    Divider().background(Color.white.opacity(0.2))
                    
                    // Game Details
                    HStack {
                        Text("Details")
                            .foregroundColor(.white.opacity(0.7))
                        Spacer()
                        Text(result.gameDetails)
                            .font(.caption)
                            .lineLimit(2)
                            .multilineTextAlignment(.trailing)
                            .foregroundColor(.white)
                    }
                }
                .padding()
                .background(Color.black.opacity(0.2))
                .cornerRadius(12)
                
                Spacer()
                
                // Close Button
                Button(action: {
                    onDismiss()
                    dismiss()
                }) {
                    Text("CONTINUE")
                        .font(.headline)
                        .fontWeight(.bold)
                        .foregroundColor(.black)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.white)
                        .cornerRadius(12)
                }
            }
            .padding()
            .foregroundColor(.white)
        }
        .ignoresSafeArea()
    }
}

#Preview {
    GameResultView(
        result: GameResult(
            playerId: UUID(),
            gameType: .slots,
            betAmount: 10,
            winAmount: 100,
            timestamp: Date(),
            isWin: true,
            duration: 3,
            gameDetails: "🍎 🍎 🍎"
        ),
        onDismiss: { }
    )
    .preferredColorScheme(.dark)
}