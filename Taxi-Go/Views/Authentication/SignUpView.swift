//
//  SignUpView.swift
//  Taxi Go
//

import SwiftUI

struct SignUpView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    @Environment(\.dismiss) var dismiss
    @State private var fullName = ""
    @State private var email = ""
    @State private var phoneNumber = ""
    @State private var password = ""
    @State private var confirmPassword = ""
    @State private var showError = false
    @State private var errorMessage = ""
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color.orange.opacity(0.1).ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 25) {
                        VStack(spacing: 10) {
                            Image(systemName: "person.circle.fill")
                                .font(.system(size: 70))
                                .foregroundStyle(.orange)
                            Text("Create Account")
                                .font(.title)
                                .fontWeight(.bold)
                            Text("Join Taxi Go today")
                                .font(.subheadline)
                                .foregroundStyle(.gray)
                        }
                        .padding(.top, 30)
                        
                        VStack(spacing: 15) {
                            InputField(icon: "person.fill", placeholder: "Full Name", text: $fullName)
                            InputField(icon: "envelope.fill", placeholder: "Email", text: $email)
                                .textInputAutocapitalization(.never)
                                .keyboardType(.emailAddress)
                            InputField(icon: "phone.fill", placeholder: "Phone Number", text: $phoneNumber)
                                .keyboardType(.phonePad)
                            InputField(icon: "lock.fill", placeholder: "Password", text: $password, isSecure: true)
                            InputField(icon: "lock.fill", placeholder: "Confirm Password", text: $confirmPassword, isSecure: true)
                        }
                        .padding(.horizontal)
                        
                        Button {
                            validateAndSignUp()
                        } label: {
                            if authViewModel.isLoading {
                                ProgressView().tint(.white)
                            } else {
                                Text("Sign Up")
                                    .fontWeight(.semibold)
                                    .frame(maxWidth: .infinity)
                            }
                        }
                        .frame(height: 50)
                        .background(Color.orange)
                        .foregroundStyle(.white)
                        .cornerRadius(12)
                        .padding(.horizontal)
                        .disabled(authViewModel.isLoading || !isFormValid)
                        
                        Text("By signing up, you agree to our Terms & Conditions")
                            .font(.caption)
                            .foregroundStyle(.gray)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, 40)
                        
                        Spacer()
                    }
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "xmark").foregroundStyle(.primary)
                    }
                }
            }
            .alert("Error", isPresented: $showError) {
                Button("OK", role: .cancel) { }
            } message: {
                Text(errorMessage)
            }
            .onChange(of: authViewModel.currentUser) { _, newValue in
                if newValue != nil { dismiss() }
            }
        }
    }
    
    private var isFormValid: Bool {
        !fullName.isEmpty && !email.isEmpty && !phoneNumber.isEmpty && !password.isEmpty && password == confirmPassword
    }
    
    private func validateAndSignUp() {
        guard authViewModel.validateEmail(email) else {
            errorMessage = "Please enter a valid email"
            showError = true
            return
        }
        guard authViewModel.validatePassword(password) else {
            errorMessage = "Password must be at least 6 characters"
            showError = true
            return
        }
        guard password == confirmPassword else {
            errorMessage = "Passwords do not match"
            showError = true
            return
        }
        guard authViewModel.validatePhoneNumber(phoneNumber) else {
            errorMessage = "Please enter a valid phone number"
            showError = true
            return
        }
        
        Task {
            await authViewModel.signUp(email: email, password: password, fullName: fullName, phoneNumber: phoneNumber)
            if let error = authViewModel.errorMessage {
                errorMessage = error
                showError = true
            }
        }
    }
}

struct InputField: View {
    let icon: String
    let placeholder: String
    @Binding var text: String
    var isSecure: Bool = false
    
    var body: some View {
        HStack {
            Image(systemName: icon)
                .foregroundStyle(.gray)
                .frame(width: 20)
            if isSecure {
                SecureField(placeholder, text: $text)
            } else {
                TextField(placeholder, text: $text)
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(12)
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(Color.gray.opacity(0.3), lineWidth: 1)
        )
    }
}

#Preview {
    SignUpView().environmentObject(AuthViewModel())
}

