import SwiftUI

struct RegisterView: View {
    @StateObject private var viewModel = AuthViewModel()
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationStack {
            ZStack {
                // Background
                LinearGradient(
                    gradient: Gradient(colors: [Color.blue.opacity(0.3), Color.purple.opacity(0.3)]),
                    startPoint: .topLeadingToBottomTrailing,
                    endPoint: .bottomTrailingToTopLeading
                )
                .ignoresSafeArea()
                
                VStack(spacing: 20) {
                    Spacer()
                    
                    // Title
                    VStack(spacing: 8) {
                        Text("Create Account")
                            .font(.system(size: 28, weight: .bold))
                            .foregroundColor(.primary)
                        
                        Text("Join ID ERP")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                    }
                    
                    Spacer()
                    
                    // Registration Form
                    VStack(spacing: 16) {
                        // Name
                        TextField("Full Name", text: $viewModel.name)
                            .textFieldStyle(.roundedBorder)
                        
                        // Email
                        TextField("Email", text: $viewModel.email)
                            .textFieldStyle(.roundedBorder)
                            .keyboardType(.emailAddress)
                            .autocapitalization(.none)
                            .disableAutocorrection(true)
                        
                        // Password
                        SecureField("Password", text: $viewModel.password)
                            .textFieldStyle(.roundedBorder)
                        
                        // Role Selection
                        Picker("Role", selection: $viewModel.role) {
                            Text("User").tag("user")
                            Text("Manager").tag("manager")
                            Text("Admin").tag("admin")
                        }
                        .textFieldStyle(.roundedBorder)
                        
                        // Register Button
                        Button(action: {
                            viewModel.register()
                            if viewModel.errorMessage == nil {
                                dismiss()
                            }
                        }) {
                            if viewModel.isLoading {
                                ProgressView()
                                    .frame(maxWidth: .infinity)
                                    .padding()
                            } else {
                                Text("Create Account")
                                    .fontWeight(.semibold)
                                    .frame(maxWidth: .infinity)
                                    .padding()
                            }
                        }
                        .disabled(viewModel.isLoading)
                        .background(Color.green)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                        
                        // Error Message
                        if let errorMessage = viewModel.errorMessage {
                            Text(errorMessage)
                                .font(.caption)
                                .foregroundColor(.red)
                        }
                    }
                    .padding(20)
                    .background(Color(.systemBackground))
                    .cornerRadius(12)
                    .shadow(radius: 4)
                    
                    Spacer()
                }
                .padding(20)
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: { dismiss() }) {
                        Image(systemName: "xmark")
                            .foregroundColor(.primary)
                    }
                }
            }
        }
    }
}

#Preview {
    RegisterView()
}
