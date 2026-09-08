import SwiftUI

struct BlackjackGameView: View {
    @EnvironmentObject var playerService: PlayerService
    @EnvironmentObject var gameService: GameService
    @Environment(\.dismiss) var dismiss
    
    @State private var bet: Double = 10
    @State private var playerCards: [Int] = []
    @State private var dealerCards: [Int] = []
    @State private var gameStatus = "Place your bet and deal"
    @State private var canHit = false
    @State private var isGameOver = false
    @State private var showResult = false
    @State private var gameResult: GameResult?
    
    var canDeal: Bool {
        playerCards.isEmpty && (playerService.currentPlayer?.balance ?? 0) >= bet
    }
    
    var playerSum: Int {
        playerCards.reduce(0, +)
    }
    
    var dealerSum: Int {
        dealerCards.reduce(0, +)
    }
    
    var body: some View {
        ZStack {
            LinearGradient(
                gradient: Gradient(colors: [.green, .teal]),
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
                    Text("BLACKJACK")
                        .font(.title2)
                        .fontWeight(.bold)
                    Spacer()
                    Text("$\(String(format: "%.2f", playerService.currentPlayer?.balance ?? 0))")
                        .font(.headline)
                }
                .foregroundColor(.white)
                .padding()
                .background(Color.black.opacity(0.3))
                
                // Dealer's Hand
                VStack(alignment: .leading, spacing: 10) {
                    Text("Dealer - \(dealerSum)")
                        .font(.headline)
                        .foregroundColor(.white)
                    
                    HStack(spacing: 10) {
                        ForEach(dealerCards, id: \.self) { card in
                            CardView(card: String(card))
                        }
                        Spacer()
                    }
                }
                .padding()
                .background(Color.black.opacity(0.3))
                .cornerRadius(12)
                
                Spacer()
                
                // Status
                Text(gameStatus)
                    .font(.headline)
                    .foregroundColor(.yellow)
                    .lineLimit(2)
                
                Spacer()
                
                // Player's Hand
                VStack(alignment: .leading, spacing: 10) {
                    Text("Your Hand - \(playerSum)")
                        .font(.headline)
                        .foregroundColor(.white)
                    
                    HStack(spacing: 10) {
                        ForEach(playerCards, id: \.self) { card in
                            CardView(card: String(card))
                        }
                        Spacer()
                    }
                }
                .padding()
                .background(Color.black.opacity(0.3))
                .cornerRadius(12)
                
                // Bet Control
                if !canHit {
                    VStack(spacing: 10) {
                        HStack {
                            Text("Bet: ")
                            Spacer()
                            Text("$\(String(format: "%.2f", bet))")
                                .fontWeight(.bold)
                        }
                        Slider(value: $bet, in: 1...min(100, playerService.currentPlayer?.balance ?? 100), step: 1)
                            .tint(.yellow)
                    }
                    .foregroundColor(.white)
                    .padding()
                    .background(Color.black.opacity(0.3))
                    .cornerRadius(12)
                }
                
                // Action Buttons
                HStack(spacing: 12) {
                    if canDeal {
                        Button(action: deal) {
                            Text("DEAL")
                                .fontWeight(.bold)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.yellow)
                                .foregroundColor(.black)
                                .cornerRadius(8)
                        }
                    }
                    
                    if canHit {
                        Button(action: hit) {
                            Text("HIT")
                                .fontWeight(.bold)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.green)
                                .foregroundColor(.white)
                                .cornerRadius(8)
                        }
                        
                        Button(action: stand) {
                            Text("STAND")
                                .fontWeight(.bold)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.red)
                                .foregroundColor(.white)
                                .cornerRadius(8)
                        }
                    }
                }
                
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
        guard playerService.deductBalance(amount: bet) else { return }
        
        playerCards = [Int.random(in: 2...11), Int.random(in: 2...11)]
        dealerCards = [Int.random(in: 2...11)]
        canHit = true
        isGameOver = false
        gameStatus = "Hit or Stand?"
    }
    
    func hit() {
        playerCards.append(Int.random(in: 2...11))
        
        if playerSum > 21 {
            endGame(playerBust: true)
        }
    }
    
    func stand() {
        while dealerSum < 17 && !isGameOver {
            dealerCards.append(Int.random(in: 2...11))
        }
        endGame(playerBust: false)
    }
    
    func endGame(playerBust: Bool) {
        canHit = false
        isGameOver = true
        
        let result = gameService.playBlackjack(bet: bet, playerCards: playerCards, dealerCards: dealerCards)
        playerService.recordGameResult(result)
        
        gameResult = result
        gameStatus = result.gameDetails
        showResult = true
        
        if result.isWin {
            SoundService.shared.playWinSound()
        } else {
            SoundService.shared.playLoseSound()
        }
    }
}

struct CardView: View {
    let card: String
    
    var body: some View {
        VStack {
            Text(card)
                .font(.title2)
                .fontWeight(.bold)
        }
        .frame(width: 50, height: 70)
        .background(Color.white)
        .foregroundColor(.black)
        .cornerRadius(8)
        .overlay(
            RoundedRectangle(cornerRadius: 8)
                .stroke(Color.black, lineWidth: 2)
        )
    }
}

#Preview {
    BlackjackGameView()
        .environmentObject(PlayerService())
        .environmentObject(GameService())
        .preferredColorScheme(.dark)
}