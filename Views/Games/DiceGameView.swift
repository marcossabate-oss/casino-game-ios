import SwiftUI

struct DiceGameView: View {
    @EnvironmentObject var playerService: PlayerService
    @EnvironmentObject var gameService: GameService
    @Environment(\.dismiss) var dismiss
    
    @State private var betAmount: Double = 10
    @State private var predictedSum: Int = 7
    @State private var dice1: Int? = nil
    @State private var dice2: Int? = nil
    @State private var isRolling = false
    @State private var showResult = false
    @State private var gameResult: GameResult?
    
    var canRoll: Bool {
        !isRolling && (playerService.currentPlayer?.balance ?? 0) >= betAmount
    }
    
    var body: some View {
        ZStack {
            LinearGradient(
                gradient: Gradient(colors: [.blue, .cyan]),
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
                    Text("DICE")
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
                
                // Dice Display
                VStack(spacing: 15) {
                    Text("Roll the Dice")
                        .font(.headline)
                        .foregroundColor(.white)
                    
                    HStack(spacing: 20) {
                        // Dice 1
                        VStack {
                            Text(dice1.map(String.init) ?? "?")
                                .font(.system(size: 50, weight: .bold))
                                .foregroundColor(.white)
                        }
                        .frame(width: 80, height: 80)
                        .background(Color.black.opacity(0.4))
                        .cornerRadius(12)
                        .overlay(RoundedRectangle(cornerRadius: 12).stroke(Color.cyan, lineWidth: 2))
                        .rotation3DEffect(.degrees(isRolling ? 720 : 0), axis: (x: 1, y: 1, z: 0))
                        
                        Text("+")
                            .font(.title2)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                        
                        // Dice 2
                        VStack {
                            Text(dice2.map(String.init) ?? "?")
                                .font(.system(size: 50, weight: .bold))
                                .foregroundColor(.white)
                        }
                        .frame(width: 80, height: 80)
                        .background(Color.black.opacity(0.4))
                        .cornerRadius(12)
                        .overlay(RoundedRectangle(cornerRadius: 12).stroke(Color.cyan, lineWidth: 2))
                        .rotation3DEffect(.degrees(isRolling ? 720 : 0), axis: (x: 1, y: 1, z: 0))
                    }
                    
                    if let d1 = dice1, let d2 = dice2 {
                        Text("Total: \(d1 + d2)")
                            .font(.headline)
                            .fontWeight(.bold)
                            .foregroundColor(.yellow)
                    }
                }
                .padding()
                .background(Color.black.opacity(0.2))
                .cornerRadius(12)
                
                Spacer()
                
                // Prediction
                VStack(spacing: 12) {
                    HStack {
                        Text("Predict Sum")
                            .foregroundColor(.white)
                        Spacer()
                        Text("(2-12)")
                            .font(.caption)
                            .foregroundColor(.gray)
                    }
                    
                    HStack {
                        Text(String(predictedSum))
                            .font(.title2)
                            .fontWeight(.bold)
                            .foregroundColor(.cyan)
                            .frame(width: 50)
                        
                        Slider(
                            value: Binding(
                                get: { Double(predictedSum) },
                                set: { predictedSum = Int($0) }
                            ),
                            in: 2...12,
                            step: 1
                        )
                        .tint(.cyan)
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
                            .foregroundColor(.cyan)
                    }
                    
                    Slider(
                        value: $betAmount,
                        in: 1...min(100, playerService.currentPlayer?.balance ?? 100),
                        step: 1
                    )
                    .tint(.cyan)
                }
                .padding()
                .background(Color.black.opacity(0.3))
                .cornerRadius(12)
                
                // Roll Button
                Button(action: roll) {
                    Text(isRolling ? "ROLLING..." : "ROLL")
                        .font(.headline)
                        .fontWeight(.bold)
                        .foregroundColor(.black)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(canRoll ? Color.cyan : Color.gray)
                        .cornerRadius(12)
                }
                .disabled(!canRoll)
                
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
    
    func roll() {
        guard playerService.deductBalance(amount: betAmount) else { return }
        
        isRolling = true
        SoundService.shared.playSpinSound()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            dice1 = Int.random(in: 1...6)
            dice2 = Int.random(in: 1...6)
            
            let gameResult = gameService.playDice(bet: betAmount, predictedSum: predictedSum)
            playerService.recordGameResult(gameResult)
            
            self.gameResult = gameResult
            isRolling = false
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
    DiceGameView()
        .environmentObject(PlayerService())
        .environmentObject(GameService())
        .preferredColorScheme(.dark)
}