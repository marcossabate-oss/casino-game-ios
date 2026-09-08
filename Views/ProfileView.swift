import SwiftUI

struct ProfileView: View {
    @EnvironmentObject var authService: AuthService
    @EnvironmentObject var playerService: PlayerService
    @State private var showingLogoutAlert = false
    
    var body: some View {
        NavigationView {
            ZStack {
                LinearGradient(
                    gradient: Gradient(colors: [.purple, .pink]),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 20) {
                        // Avatar
                        VStack(spacing: 12) {
                            Circle()
                                .fill(
                                    LinearGradient(
                                        gradient: Gradient(colors: [.blue, .purple]),
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    )
                                )
                                .frame(width: 120, height: 120)
                                .overlay(
                                    Text("👤")
                                        .font(.system(size: 60))
                                )
                            
                            Text(authService.currentUser?.username ?? "Guest")
                                .font(.title2)
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                            
                            Text(authService.currentUser?.email ?? "")
                                .font(.caption)
                                .foregroundColor(.gray)
                        }
                        .padding()
                        
                        // Level
                        VStack(spacing: 12) {
                            HStack {
                                Text("Level \(playerService.currentPlayer?.level ?? 1)")
                                    .font(.headline)
                                    .foregroundColor(.white)
                                Spacer()
                                Text("\(Int(playerService.getLevelProgress() * 100))%")
                                    .font(.caption)
                                    .foregroundColor(.yellow)
                            }
                            
                            ProgressView(value: playerService.getLevelProgress())
                                .tint(.yellow)
                            
                            Text("Next level: $\(String(format: "%.0f", playerService.getNextLevelRequirement())) needed")
                                .font(.caption)
                                .foregroundColor(.gray)
                        }
                        .padding()
                        .background(Color.black.opacity(0.3))
                        .cornerRadius(12)
                        .padding(.horizontal)
                        
                        // Statistics
                        VStack(spacing: 12) {
                            Text("Statistics")
                                .font(.headline)
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity, alignment: .leading)
                            
                            StatRow(
                                label: "Games Played",
                                value: "\(playerService.currentPlayer?.gamesPlayed ?? 0)",
                                icon: "🎮"
                            )
                            
                            Divider().background(Color.white.opacity(0.2))
                            
                            StatRow(
                                label: "Total Winnings",
                                value: "$\(String(format: "%.2f", playerService.currentPlayer?.totalWinnings ?? 0))",
                                icon: "💰"
                            )
                            
                            Divider().background(Color.white.opacity(0.2))
                            
                            StatRow(
                                label: "Total Losses",
                                value: "$\(String(format: "%.2f", playerService.currentPlayer?.totalLosses ?? 0))",
                                icon: "📉"
                            )
                            
                            Divider().background(Color.white.opacity(0.2))
                            
                            StatRow(
                                label: "Member Since",
                                value: formatDate(playerService.currentPlayer?.joinDate),
                                icon: "📅"
                            )
                        }
                        .padding()
                        .background(Color.black.opacity(0.3))
                        .cornerRadius(12)
                        .padding(.horizontal)
                        
                        // Achievements
                        VStack(spacing: 12) {
                            Text("Achievements")
                                .font(.headline)
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity, alignment: .leading)
                            
                            let achievements = playerService.checkAchievements()
                            if achievements.isEmpty {
                                Text("Keep playing to unlock achievements")
                                    .font(.caption)
                                    .foregroundColor(.gray)
                            } else {
                                ForEach(achievements, id: \.self) { achievement in
                                    HStack(spacing: 12) {
                                        Text("⭐")
                                            .font(.title2)
                                        Text(achievement)
                                            .font(.body)
                                            .foregroundColor(.white)
                                        Spacer()
                                    }
                                    .padding()
                                    .background(Color.yellow.opacity(0.2))
                                    .cornerRadius(8)
                                }
                            }
                        }
                        .padding()
                        .background(Color.black.opacity(0.3))
                        .cornerRadius(12)
                        .padding(.horizontal)
                        
                        // Logout Button
                        Button(action: { showingLogoutAlert = true }) {
                            Text("LOGOUT")
                                .font(.headline)
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.red)
                                .cornerRadius(12)
                        }
                        .padding()
                    }
                }
            }
            .navigationTitle("Profile")
            .alert("Logout", isPresented: $showingLogoutAlert) {
                Button("Cancel", role: .cancel) { }
                Button("Logout", role: .destructive) {
                    authService.logout()
                }
            } message: {
                Text("Are you sure you want to logout?")
            }
        }
    }
    
    func formatDate(_ date: Date?) -> String {
        guard let date = date else { return "N/A" }
        return date.formatted(date: .abbreviated, time: .omitted)
    }
}

struct StatRow: View {
    let label: String
    let value: String
    let icon: String
    
    var body: some View {
        HStack {
            Text(icon)
                .font(.title2)
            Text(label)
                .foregroundColor(.gray)
            Spacer()
            Text(value)
                .fontWeight(.semibold)
                .foregroundColor(.yellow)
        }
        .foregroundColor(.white)
    }
}

#Preview {
    ProfileView()
        .environmentObject(AuthService.shared)
        .environmentObject(PlayerService())
        .preferredColorScheme(.dark)
}