import SwiftUI

struct SlotsGameView: View {
    @EnvironmentObject var playerService: PlayerService
    @EnvironmentObject var gameService: GameService
    @Environment(\.dismiss) var dismiss
    
    @State private var bet: Double = 10
    @State private var reels = ["🍎", "🍎", "🍎"]
    @State private var isSpinning = false
    @State private var showResult = false
    @State private var result: GameResult?
    
    var canSpin: Bool {
        !isSpinning && (playerService.currentPlayer?.balance ?? 0) >= bet
    }
    
    var body: some View {
        ZStack {
            LinearGradient(
                gradient: Gradient(colors: [.red, .purple]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            
            VStack(spacing: 20) {
                // Header
                HStack {
                    Button(action: { dismiss() }) {
                        Image(systemName: "chevron.left")
                            .font(.headline)
                    }
                    Spacer()
                    Text("SLOTS")
                        .font(.title2)
                        .fontWeight(.bold)
                    Spacer()
                    Text("$\(String(format: "%.2f", playerService.currentPlayer?.balance ?? 0))")
                        .font(.headline)
                }
                .foregroundColor(.white)
                .padding()
                .background(Color.black.opacity(0.3))
                
                Spacer()
                
                // Reels
                VStack(spacing: 20) {
                    Text("Spin the Reels")
                        .font(.headline)
                        .foregroundColor(.white)
                    
                    HStack(spacing: 15) {
                        ForEach(0..<3, id: \.self) { index in
                            VStack {
                                Text(reels[index])
                                    .font(.system(size: 50))
                            }
                            .frame(maxWidth: .infinity)
                            .frame(height: 100)
                            .background(Color.yellow.opacity(0.2))
                            .cornerRadius(12)
                            .overlay(
                                RoundedRectangle(cornerRadius: 12)
                                    .stroke(Color.yellow, lineWidth: 2)
                            )
                            .rotation3DEffect(.degrees(isSpinning ? 360 : 0), axis: (x: 0, y: 1, z: 0))
                        }
                    }
                }
                .padding()
                .background(Color.black.opacity(0.3))
                .cornerRadius(12)
                
                // Bet Control
                VStack(spacing: 10) {
                    HStack {
                        Text("Bet: ")
                        Spacer()
                        Text("$\(String(format: "%.2f", bet))")
                            .fontWeight(.bold)
                    }
                    .foregroundColor(.white)
                    
                    Slider(value: $bet, in: 1...min(100, playerService.currentPlayer?.balance ?? 100), step: 1)
                        .tint(.yellow)
                }
                .padding()
                .background(Color.black.opacity(0.3))
                .cornerRadius(12)
                
                // Spin Button
                Button(action: spin) {
                    Text(isSpinning ? "SPINNING..." : "SPIN")
                        .font(.headline)
                        .fontWeight(.bold)
                        .foregroundColor(.black)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(canSpin ? Color.yellow : Color.gray)
                        .cornerRadius(12)
                }
                .disabled(!canSpin)
                
                Spacer()
            }
            .padding()
        }
        .navigationBarBackButtonHidden(true)
        .sheet(isPresented: $showResult) {
            if let result = result {
                GameResultView(result: result, onDismiss: { showResult = false })
            }
        }
    }
    
    func spin() {
        guard playerService.deductBalance(amount: bet) else { return }
        
        isSpinning = true
        SoundService.shared.playSpinSound()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            let symbols = ["🍎", "🍊", "🍋", "🍌", "🍉"]
            reels = (0..<3).map { _ in symbols.randomElement()! }
            
            let gameResult = gameService.playSlots(bet: bet)
            playerService.recordGameResult(gameResult)
            
            result = gameResult
            isSpinning = false
            showResult = true
            
            if gameResult.isWin {
                SoundService.shared.playWinSound()
                SoundService.shared.vibrateHeavy()
            } else {
                SoundService.shared.playLoseSound()
            }
        }
    }
}

#Preview {
    SlotsGameView()
        .environmentObject(PlayerService())
        .environmentObject(GameService())
        .preferredColorScheme(.dark)
}