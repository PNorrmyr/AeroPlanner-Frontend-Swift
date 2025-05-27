import SwiftUI

struct LoginView: View {
    @StateObject private var userService = UserService()
    @State private var email = ""
    @State private var password = ""
    @State private var isRegistering = false
    @State private var showAlert = false
    @State private var alertMessage = ""
    @State private var isLoggedIn = false
    
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                Image(systemName: "airplane")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 100, height: 100)
                    .foregroundColor(.blue)
                
                Text(isRegistering ? "Create Account" : "AeroPlanner")
                    .font(.largeTitle)
                    .bold()
                    .foregroundStyle(.blue)
                
                TextField("Email", text: $email)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .autocapitalization(.none)
                    .keyboardType(.emailAddress)
                
                SecureField("Password", text: $password)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                
                Button(action: handleAction) {
                    Text(isRegistering ? "Register" : "Login")
                        .frame(maxWidth: 200)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                        .font(.system(size: 25))
                }
                
                Button(action: {
                    isRegistering.toggle()
                    email = ""
                    password = ""
                }) {
                    Text(isRegistering ? "Already have an account? Login" : "New user? Register")
                        .foregroundColor(.blue)
                }
            }
            .padding()
            .alert(isPresented: $showAlert) {
                Alert(title: Text("Message"), 
                     message: Text(alertMessage), 
                     dismissButton: .default(Text("OK")))
            }
            .fullScreenCover(isPresented: $isLoggedIn) {
                ContentView()
            }
        }
    }
    
    private func handleAction() {
        if isRegistering {
            if userService.register(email: email, password: password) {
                alertMessage = "Registration successful!"
                isRegistering = false
                showAlert = true
            } else {
                alertMessage = "Email is already registered"
                showAlert = true
            }
        } else {
            if userService.login(email: email, password: password) {
                isLoggedIn = true
            } else {
                alertMessage = "Invalid email or password"
                showAlert = true
            }
        }
    }
}

#Preview {
    LoginView()
} 
