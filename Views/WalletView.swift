import SwiftUI

struct WalletView: View {
    @EnvironmentObject var playerService: PlayerService
    @State private var depositAmount: String = ""
    @State private var withdrawAmount: String = ""
    @State private var selectedTab = 0
    @State private var showingAlert = false
    @State private var alertMessage = ""
    
    var body: some View {
        NavigationView {
            ZStack {
                LinearGradient(
                    gradient: Gradient(colors: [.blue.opacity(0.8), .purple.opacity(0.8)]),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()
                
                VStack(spacing: 0) {
                    // Balance Card
                    VStack(spacing: 12) {
                        Text("Current Balance")
                            .font(.headline)
                            .foregroundColor(.gray)
                        
                        Text("$\(String(format: "%.2f", playerService.currentPlayer?.balance ?? 0))")
                            .font(.system(size: 48, weight: .bold))
                            .foregroundColor(.green)
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(
                        LinearGradient(
                            gradient: Gradient(colors: [.black.opacity(0.5), .black.opacity(0.3)]),
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .cornerRadius(16)
                    .padding()
                    
                    // Tab Selector
                    Picker("Action", selection: $selectedTab) {
                        Text("Deposit").tag(0)
                        Text("Withdraw").tag(1)
                        Text("History").tag(2)
                    }
                    .pickerStyle(.segmented)
                    .padding()
                    .foregroundColor(.white)
                    
                    // Tab Content
                    if selectedTab == 0 {
                        depositView
                    } else if selectedTab == 1 {
                        withdrawView
                    } else {
                        historyView
                    }
                    
                    Spacer()
                }
            }
            .navigationTitle("Wallet")
            .alert("Transaction", isPresented: $showingAlert) {
                Button("OK", role: .cancel) { }
            } message: {
                Text(alertMessage)
            }
        }
    }
    
    var depositView: some View {
        VStack(spacing: 16) {
            VStack(spacing: 10) {
                Text("Amount to Deposit")
                    .font(.headline)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                TextField("Enter amount", text: $depositAmount)
                    .keyboardType(.decimalPad)
                    .padding()
                    .background(Color.white.opacity(0.1))
                    .cornerRadius(8)
                    .foregroundColor(.white)
                    .placeholder(when: depositAmount.isEmpty) {
                        Text("$10.00").foregroundColor(.gray)
                    }
            }
            .padding()
            
            VStack(spacing: 10) {
                ForEach(["$10", "$25", "$50", "$100"], id: \.self) { amount in
                    Button(action: { depositAmount = amount.replacingOccurrences(of: "$", with: "") }) {
                        Text(amount)
                            .font(.headline)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.green.opacity(0.3))
                            .foregroundColor(.green)
                            .cornerRadius(8)
                    }
                }
            }
            .padding()
            
            Button(action: deposit) {
                Text("DEPOSIT")
                    .font(.headline)
                    .fontWeight(.bold)
                    .foregroundColor(.black)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.green)
                    .cornerRadius(12)
            }
            .padding()
            
            Spacer()
        }
    }
    
    var withdrawView: some View {
        VStack(spacing: 16) {
            VStack(spacing: 10) {
                Text("Amount to Withdraw")
                    .font(.headline)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                TextField("Enter amount", text: $withdrawAmount)
                    .keyboardType(.decimalPad)
                    .padding()
                    .background(Color.white.opacity(0.1))
                    .cornerRadius(8)
                    .foregroundColor(.white)
                    .placeholder(when: withdrawAmount.isEmpty) {
                        Text("$10.00").foregroundColor(.gray)
                    }
            }
            .padding()
            
            Button(action: withdraw) {
                Text("WITHDRAW")
                    .font(.headline)
                    .fontWeight(.bold)
                    .foregroundColor(.black)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.orange)
                    .cornerRadius(12)
            }
            .padding()
            
            Spacer()
        }
    }
    
    var historyView: some View {
        VStack {
            if playerService.gameHistory.isEmpty {
                VStack(spacing: 12) {
                    Image(systemName: "calendar")
                        .font(.system(size: 40))
                    Text("No Transactions")
                        .font(.headline)
                    Text("Your transaction history will appear here")
                        .font(.caption)
                        .foregroundColor(.gray)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .foregroundColor(.gray)
            } else {
                List(playerService.gameHistory.prefix(10)) { result in
                    HStack {
                        VStack(alignment: .leading, spacing: 4) {
                            Text(result.gameType.rawValue)
                                .font(.headline)
                            Text(result.timestamp.formatted(date: .abbreviated, time: .shortened))
                                .font(.caption)
                                .foregroundColor(.gray)
                        }
                        Spacer()
                        VStack(alignment: .trailing, spacing: 4) {
                            Text(result.isWin ? "+$\(String(format: "%.2f", result.winAmount))" : "-$\(String(format: "%.2f", result.betAmount))")
                                .fontWeight(.bold)
                                .foregroundColor(result.isWin ? .green : .red)
                        }
                    }
                }
                .scrollContentBackground(.hidden)
            }
        }
    }
    
    func deposit() {
        guard let amount = Double(depositAmount), amount > 0 else {
            alertMessage = "Please enter a valid amount"
            showingAlert = true
            return
        }
        
        playerService.depositFunds(amount: amount)
        alertMessage = "Successfully deposited $\(String(format: "%.2f", amount))"
        showingAlert = true
        depositAmount = ""
    }
    
    func withdraw() {
        guard let amount = Double(withdrawAmount), amount > 0 else {
            alertMessage = "Please enter a valid amount"
            showingAlert = true
            return
        }
        
        if playerService.withdrawFunds(amount: amount) {
            alertMessage = "Successfully withdrew $\(String(format: "%.2f", amount))"
        } else {
            alertMessage = playerService.errorMessage ?? "Withdrawal failed"
        }
        showingAlert = true
        withdrawAmount = ""
    }
}

extension View {
    func placeholder<Content: View>(when shouldShow: Bool, alignment: Alignment = .leading, @ViewBuilder placeholder: () -> Content) -> some View {
        ZStack(alignment: alignment) {
            placeholder().opacity(shouldShow ? 1 : 0)
            self
        }
    }
}

#Preview {
    WalletView()
        .environmentObject(PlayerService())
        .preferredColorScheme(.dark)
}