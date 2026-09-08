import SwiftUI

struct StatsView: View {
    @EnvironmentObject var playerService: PlayerService
    @State private var selectedGameFilter = "All"
    
    let gameTypes = ["All"] + GameType.allCases.map { $0.rawValue }
    
    var body: some View {
        NavigationView {
            ZStack {
                LinearGradient(
                    gradient: Gradient(colors: [.orange, .red]),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()
                
                VStack(spacing: 16) {
                    // Filter
                    Picker("Game", selection: $selectedGameFilter) {
                        ForEach(gameTypes, id: \.self) { game in
                            Text(game).tag(game)
                        }
                    }
                    .pickerStyle(.segmented)
                    .padding()
                    
                    ScrollView {
                        VStack(spacing: 16) {
                            // Overall Stats
                            if selectedGameFilter == "All" {
                                statsCard(title: "Total Games", value: "\(playerService.currentPlayer?.gamesPlayed ?? 0)", icon: "🎮")
                                statsCard(title: "Total Winnings", value: "$\(String(format: "%.2f", playerService.currentPlayer?.totalWinnings ?? 0))", icon: "💰")
                                statsCard(title: "Total Losses", value: "$\(String(format: "%.2f", playerService.currentPlayer?.totalLosses ?? 0))", icon: "📉")
                                statsCard(title: "Net Profit", value: "$\(String(format: "%.2f", (playerService.currentPlayer?.totalWinnings ?? 0) - (playerService.currentPlayer?.totalLosses ?? 0)))", icon: "📈")
                                
                                if let stats = playerService.playerStats {
                                    statsCard(title: "Win Streak", value: "\(stats.currentWinStreak)", icon: "🔥")
                                    statsCard(title: "Longest Streak", value: "\(stats.longestWinStreak)", icon: "⭐")
                                    statsCard(title: "Avg Bet", value: "$\(String(format: "%.2f", stats.averageBetSize))", icon: "💵")
                                    statsCard(title: "Largest Win", value: "$\(String(format: "%.2f", stats.largestWin))", icon: "🎯")
                                }
                            }
                            
                            // Game History
                            Text("Recent Games")
                                .font(.headline)
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .padding(.horizontal)
                            
                            if playerService.gameHistory.isEmpty {
                                Text("No games played yet")
                                    .foregroundColor(.gray)
                                    .frame(maxWidth: .infinity, alignment: .center)
                                    .padding()
                            } else {
                                ForEach(playerService.gameHistory.prefix(10)) { result in
                                    gameResultRow(result)
                                }
                            }
                        }
                        .padding()
                    }
                }
            }
            .navigationTitle("Statistics")
        }
    }
    
    func statsCard(title: String, value: String, icon: String) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text(icon).font(.title2)
                Text(title).font(.caption).foregroundColor(.gray)
                Spacer()
            }
            Text(value)
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(.yellow)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .background(Color.black.opacity(0.3))
        .cornerRadius(12)
    }
    
    func gameResultRow(_ result: GameResult) -> some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text(result.gameType.rawValue)
                    .font(.headline)
                    .foregroundColor(.white)
                Text(result.timestamp.formatted(date: .abbreviated, time: .shortened))
                    .font(.caption)
                    .foregroundColor(.gray)
            }
            Spacer()
            VStack(alignment: .trailing, spacing: 4) {
                Text(result.isWin ? "+$\(String(format: "%.2f", result.winAmount))" : "-$\(String(format: "%.2f", result.betAmount))")
                    .fontWeight(.bold)
                    .foregroundColor(result.isWin ? .green : .red)
                Text(result.isWin ? "WIN" : "LOSS")
                    .font(.caption)
                    .fontWeight(.bold)
                    .foregroundColor(result.isWin ? .green : .red)
            }
        }
        .padding()
        .background(Color.black.opacity(0.3))
        .cornerRadius(8)
    }
}

#Preview {
    StatsView()
        .environmentObject(PlayerService())
        .preferredColorScheme(.dark)
}