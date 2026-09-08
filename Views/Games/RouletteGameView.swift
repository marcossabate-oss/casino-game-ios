import SwiftUI

struct RouletteGameView: View {
    @EnvironmentObject var playerService: PlayerService
    @EnvironmentObject var gameService: GameService
    @Environment(\.dismiss) var dismiss
    
    @State private var selectedNumber: Int = 0
    @State private var betAmount: Double = 10
    @State private var result: Int? = nil
    @State private var isSpinning = false
    @State private var showResult = false
    @State private var gameResult: GameResult?
    
    var canSpin: Bool {
        !isSpinning && (playerService.currentPlayer?.balance ?? 0) >= betAmount
    }
    
    var body: some View {
        ZStack {
            LinearGradient(
                gradient: Gradient(colors: [.red, .orange]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            
            VStack(spacing: 15) {
                // Header
                HStack {
                    Button(action: { dismiss() }) {
                        Image(systemName: "chevron.left")
                            .font(.headline)
                    }
                    Spacer()
                    Text("ROULETTE")
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
                
                // Wheel Result Display
                VStack(spacing: 15) {
                    Text("Spin Result")
                        .font(.headline)
                        .foregroundColor(.white)
                    
                    if let result = result {
                        Text(String(result))
                            .font(.system(size: 60, weight: .bold))
                            .foregroundColor(.yellow)
                            .frame(width: 150, height: 150)
                            .background(Circle().fill(Color.black.opacity(0.5)))
                            .overlay(Circle().stroke(Color.yellow, lineWidth: 3))
                            .rotation3DEffect(.degrees(isSpinning ? 360 : 0), axis: (x: 0, y: 1, z: 0))
                    } else {
                        ZStack {
                            Circle()
                                .fill(Color.black.opacity(0.5))
                            Text("?")
                                .font(.system(size: 60, weight: .bold))
                                .foregroundColor(.gray)
                        }
                        .frame(width: 150, height: 150)
                        .overlay(Circle().stroke(Color.yellow, lineWidth: 3))
                    }
                }
                .padding()
                .background(Color.black.opacity(0.2))
                .cornerRadius(12)
                
                Spacer()
                
                // Number Selection
                VStack(spacing: 12) {
                    HStack {
                        Text("Select Number")
                            .foregroundColor(.white)
                        Spacer()
                        Text("(0-36)")
                            .font(.caption)
                            .foregroundColor(.gray)
                    }
                    
                    HStack {
                        Text(String(selectedNumber))
                            .font(.title2)
                            .fontWeight(.bold)
                            .foregroundColor(.yellow)
                            .frame(width: 50)
                        
                        Slider(
                            value: Binding(
                                get: { Double(selectedNumber) },
                                set: { selectedNumber = Int($0) }
                            ),
                            in: 0...36,
                            step: 1
                        )
                        .tint(.yellow)
                    }
                }
                .padding()
                .background(Color.black.opacity(0.3))
                .cornerRadius(12)
                
                // Bet Amount
                VStack(spacing: 10) {
                    HStack {
                        Text("Bet Amount")
                            .foregroundColor(.white)
                        Spacer()
                        Text("$\(String(format: "%.2f", betAmount))")
                            .fontWeight(.bold)
                            .foregroundColor(.yellow)
                    }
                    
                    Slider(
                        value: $betAmount,
                        in: 1...min(100, playerService.currentPlayer?.balance ?? 100),
                        step: 1
                    )
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
            if let gameResult = gameResult {
                GameResultView(result: gameResult, onDismiss: { showResult = false })
            }
        }
    }
    
    func spin() {
        guard playerService.deductBalance(amount: betAmount) else { return }
        
        isSpinning = true
        SoundService.shared.playSpinSound()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            let spinResult = Int.random(in: 0...36)
            result = spinResult
            
            let gameResult = gameService.playRoulette(bet: betAmount, selectedNumber: selectedNumber)
            playerService.recordGameResult(gameResult)
            
            self.gameResult = gameResult
            isSpinning = false
            showResult = true
            
            if gameResult.isWin {
                SoundService.shared.playJackpotSound()
                SoundService.shared.vibrateHeavy()
            } else {
                SoundService.shared.playLoseSound()
            }
        }
    }
}

#Preview {
    RouletteGameView()
        .environmentObject(PlayerService())
        .environmentObject(GameService())
        .preferredColorScheme(.dark)
}