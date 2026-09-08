import SwiftUI

struct LoginView: View {
    @EnvironmentObject var authService: AuthService
    @State private var username = ""
    @State private var email = ""
    @State private var password = ""
    @State private var confirmPassword = ""
    @State private var isSignUp = false
    @State private var showingError = false
    
    var body: some View {
        ZStack {
            LinearGradient(
                gradient: Gradient(colors: [.blue, .purple, .pink]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            
            VStack(spacing: 0) {
                // Header
                VStack(spacing: 12) {
                    Text("🎰")
                        .font(.system(size: 60))
                    Text("CASINO GAMES")
                        .font(.title)
                        .fontWeight(.bold)
                    Text("Your ultimate gaming destination")
                        .font(.caption)
                        .foregroundColor(.white.opacity(0.8))
                }
                .frame(maxWidth: .infinity)
                .padding(40)
                .foregroundColor(.white)
                
                Spacer()
                
                // Form
                VStack(spacing: 16) {
                    if isSignUp {
                        signUpForm
                    } else {
                        loginForm
                    }
                    
                    // Action Button
                    Button(action: isSignUp ? signUp : login) {
                        Text(isSignUp ? "CREATE ACCOUNT" : "LOGIN")
                            .font(.headline)
                            .fontWeight(.bold)
                            .foregroundColor(.black)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.yellow)
                            .cornerRadius(12)
                    }
                    .disabled(authService.isLoading)
                    
                    if authService.isLoading {
                        ProgressView()
                            .tint(.white)
                    }
                    
                    // Toggle Sign Up / Login
                    HStack {
                        Text(isSignUp ? "Already have an account?" : "Don't have an account?")
                            .foregroundColor(.white.opacity(0.7))
                        Button(action: { isSignUp.toggle(); resetForm() }) {
                            Text(isSignUp ? "Login" : "Sign Up")
                                .fontWeight(.bold)
                                .foregroundColor(.yellow)
                        }
                    }
                    .font(.caption)
                    .frame(maxWidth: .infinity, alignment: .center)
                }
                .padding()
                .background(Color.black.opacity(0.3))
                .cornerRadius(16)
                .padding()
                
                Spacer()
            }
        }
        .alert("Error", isPresented: $showingError) {
            Button("OK", role: .cancel) { }
        } message: {
            Text(authService.errorMessage ?? "An error occurred")
        }
    }
    
    var loginForm: some View {
        VStack(spacing: 12) {
            VStack(alignment: .leading, spacing: 6) {
                Text("Username")
                    .font(.caption)
                    .fontWeight(.semibold)
                    .foregroundColor(.white.opacity(0.7))
                TextField("Enter username", text: $username)
                    .textFieldStyle(.roundedBorder)
                    .autocapitalization(.none)
            }
            
            VStack(alignment: .leading, spacing: 6) {
                Text("Password")
                    .font(.caption)
                    .fontWeight(.semibold)
                    .foregroundColor(.white.opacity(0.7))
                SecureField("Enter password", text: $password)
                    .textFieldStyle(.roundedBorder)
            }
        }
    }
    
    var signUpForm: some View {
        VStack(spacing: 12) {
            VStack(alignment: .leading, spacing: 6) {
                Text("Username")
                    .font(.caption)
                    .fontWeight(.semibold)
                    .foregroundColor(.white.opacity(0.7))
                TextField("Choose username", text: $username)
                    .textFieldStyle(.roundedBorder)
                    .autocapitalization(.none)
            }
            
            VStack(alignment: .leading, spacing: 6) {
                Text("Email")
                    .font(.caption)
                    .fontWeight(.semibold)
                    .foregroundColor(.white.opacity(0.7))
                TextField("Enter email", text: $email)
                    .textFieldStyle(.roundedBorder)
                    .keyboardType(.emailAddress)
                    .autocapitalization(.none)
            }
            
            VStack(alignment: .leading, spacing: 6) {
                Text("Password")
                    .font(.caption)
                    .fontWeight(.semibold)
                    .foregroundColor(.white.opacity(0.7))
                SecureField("Create password", text: $password)
                    .textFieldStyle(.roundedBorder)
            }
            
            VStack(alignment: .leading, spacing: 6) {
                Text("Confirm Password")
                    .font(.caption)
                    .fontWeight(.semibold)
                    .foregroundColor(.white.opacity(0.7))
                SecureField("Confirm password", text: $confirmPassword)
                    .textFieldStyle(.roundedBorder)
            }
        }
    }
    
    func login() {
        Task {
            let success = await authService.login(username: username, password: password)
            if !success {
                showingError = true
            }
        }
    }
    
    func signUp() {
        Task {
            let success = await authService.signup(
                username: username,
                email: email,
                password: password,
                confirmPassword: confirmPassword
            )
            if !success {
                showingError = true
            }
        }
    }
    
    func resetForm() {
        username = ""
        email = ""
        password = ""
        confirmPassword = ""
        authService.errorMessage = nil
    }
}

#Preview {
    LoginView()
        .environmentObject(AuthService.shared)
        .preferredColorScheme(.dark)
}