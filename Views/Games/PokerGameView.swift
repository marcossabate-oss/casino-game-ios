import SwiftUI

struct PokerGameView: View {
    @EnvironmentObject var playerService: PlayerService
    @EnvironmentObject var gameService: GameService
    @Environment(\.dismiss) var dismiss
    
    @State private var betAmount: Double = 10
    @State private var playerHandRank: Int = 1
    @State private var dealerHandRank: Int? = nil
    @State private var isDealing = false
    @State private var showResult = false
    @State private var gameResult: GameResult?
    
    var canPlay: Bool {
        !isDealing && (playerService.currentPlayer?.balance ?? 0) >= betAmount
    }
    
    var handDescriptions: [String] = [
        "High Card",
        "One Pair",
        "Two Pair",
        "Three of a Kind",
        "Straight",
        "Flush",
        "Full House",
        "Four of a Kind",
        "Straight Flush",
        "Royal Flush"
    ]
    
    var body: some View {
        ZStack {
            LinearGradient(
                gradient: Gradient(colors: [.green, .mint]),
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
                    Text("POKER")
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
                
                // Dealer's Hand
                VStack(alignment: .leading, spacing: 10) {
                    HStack {
                        Text("Dealer")
                            .font(.headline)
                            .foregroundColor(.white)
                        Spacer()
                        if let dealerRank = dealerHandRank {
                            Text(handDescriptions[dealerRank - 1])
                                .font(.caption)
                                .foregroundColor(.yellow)
                        }
                    }
                    
                    HStack(spacing: 10) {
                        ForEach(0..<5, id: \.self) { _ in
                            RoundedRectangle(cornerRadius: 8)
                                .fill(Color.white.opacity(0.2))
                                .frame(width: 45, height: 65)
                                .overlay(Text("🂡").font(.title2))
                        }
                        Spacer()
                    }
                }
                .padding()
                .background(Color.black.opacity(0.2))
                .cornerRadius(12)
                
                Spacer()
                
                // Player's Hand
                VStack(alignment: .leading, spacing: 10) {
                    HStack {
                        Text("Your Hand")
                            .font(.headline)
                            .foregroundColor(.white)
                        Spacer()
                        Text(handDescriptions[playerHandRank - 1])
                            .font(.caption)
                            .foregroundColor(.yellow)
                    }
                    
                    HStack(spacing: 10) {
                        ForEach(0..<5, id: \.self) { _ in
                            RoundedRectangle(cornerRadius: 8)
                                .fill(Color.yellow.opacity(0.3))
                                .frame(width: 45, height: 65)
                                .overlay(Text("🂡").font(.title2))
                        }
                        Spacer()
                    }
                }
                .padding()
                .background(Color.black.opacity(0.2))
                .cornerRadius(12)
                
                Spacer()
                
                // Hand Rank Selection
                VStack(spacing: 12) {
                    HStack {
                        Text("Your Hand Strength")
                            .foregroundColor(.white)
                        Spacer()
                        Text(handDescriptions[playerHandRank - 1])
                            .font(.caption)
                            .fontWeight(.bold)
                            .foregroundColor(.yellow)
                    }
                    
                    Slider(
                        value: Binding(
                            get: { Double(playerHandRank) },
                            set: { playerHandRank = Int($0) }
                        ),
                        in: 1...10,
                        step: 1
                    )
                    .tint(.mint)
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
                            .foregroundColor(.mint)
                    }
                    
                    Slider(
                        value: $betAmount,
                        in: 1...min(100, playerService.currentPlayer?.balance ?? 100),
                        step: 1
                    )
                    .tint(.mint)
                }
                .padding()
                .background(Color.black.opacity(0.3))
                .cornerRadius(12)
                
                // Deal Button
                Button(action: deal) {
                    Text(isDealing ? "DEALING..." : "DEAL")
                        .font(.headline)
                        .fontWeight(.bold)
                        .foregroundColor(.black)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(canPlay ? Color.mint : Color.gray)
                        .cornerRadius(12)
                }
                .disabled(!canPlay)
                
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
    
    func deal() {
        guard playerService.deductBalance(amount: betAmount) else { return }
        
        isDealing = true
        SoundService.shared.playDealSound()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            dealerHandRank = Int.random(in: 1...10)
            
            let gameResult = gameService.playPoker(bet: betAmount, playerHandRank: playerHandRank)
            playerService.recordGameResult(gameResult)
            
            self.gameResult = gameResult
            isDealing = false
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
    PokerGameView()
        .environmentObject(PlayerService())
        .environmentObject(GameService())
        .preferredColorScheme(.dark)
}