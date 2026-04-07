//
//  LoginView.swift
//  Taxi Go
//

import SwiftUI

struct LoginView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    @State private var email = ""
    @State private var password = ""
    @State private var showingSignUp = false
    @State private var showingForgotPassword = false
    @State private var showError = false
    
    var body: some View {
        NavigationStack {
            ZStack {
                LinearGradient(colors: [Color.yellow, Color.orange], startPoint: .topLeading, endPoint: .bottomTrailing)
                    .ignoresSafeArea()
                
                VStack(spacing: 30) {
                    VStack(spacing: 15) {
                        Image(systemName: "car.fill")
                            .font(.system(size: 80))
                            .foregroundStyle(.white)
                        Text("Taxi Go")
                            .font(.system(size: 42, weight: .bold))
                            .foregroundStyle(.white)
                        Text("Your ride, anytime, anywhere")
                            .font(.subheadline)
                            .foregroundStyle(.white.opacity(0.9))
                    }
                    .padding(.top, 60)
                    
                    Spacer()
                    
                    VStack(spacing: 20) {
                        HStack {
                            Image(systemName: "envelope.fill")
                                .foregroundStyle(.gray)
                            TextField("Email", text: $email)
                                .textContentType(.emailAddress)
                                .textInputAutocapitalization(.never)
                                .keyboardType(.emailAddress)
                        }
                        .padding()
                        .background(Color.white)
                        .cornerRadius(12)
                        
                        HStack {
                            Image(systemName: "lock.fill")
                                .foregroundStyle(.gray)
                            SecureField("Password", text: $password)
                                .textContentType(.password)
                        }
                        .padding()
                        .background(Color.white)
                        .cornerRadius(12)
                        
                        HStack {
                            Spacer()
                            Button("Forgot Password?") {
                                showingForgotPassword = true
                            }
                            .font(.footnote)
                            .foregroundStyle(.white)
                        }
                        
                        Button {
                            Task { await authViewModel.signIn(email: email, password: password) }
                        } label: {
                            if authViewModel.isLoading {
                                ProgressView().tint(.white)
                            } else {
                                Text("Login").fontWeight(.semibold)
                            }
                        }
                        .frame(maxWidth: .infinity)
                        .frame(height: 50)
                        .background(Color.black)
                        .foregroundStyle(.white)
                        .cornerRadius(12)
                        .disabled(authViewModel.isLoading)
                        
                        HStack {
                            Text("Don't have an account?")
                                .foregroundStyle(.white)
                            Button("Sign Up") {
                                showingSignUp = true
                            }
                            .fontWeight(.semibold)
                            .foregroundStyle(.black)
                        }
                        .font(.subheadline)
                        .padding(.top, 10)
                    }
                    .padding(.horizontal, 30)
                    .padding(.bottom, 40)
                }
            }
            .alert("Error", isPresented: $showError) {
                Button("OK", role: .cancel) {
                    authViewModel.errorMessage = nil
                }
            } message: {
                Text(authViewModel.errorMessage ?? "Unknown error")
            }
            .onChange(of: authViewModel.errorMessage) { _, newValue in
                if newValue != nil { showError = true }
            }
            .fullScreenCover(isPresented: $showingSignUp) {
                SignUpView().environmentObject(authViewModel)
            }
            .sheet(isPresented: $showingForgotPassword) {
                ForgotPasswordView().environmentObject(authViewModel)
            }
        }
    }
}

struct ForgotPasswordView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    @Environment(\.dismiss) var dismiss
    @State private var email = ""
    @State private var showSuccess = false
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 25) {
                Image(systemName: "lock.rotation")
                    .font(.system(size: 60))
                    .foregroundStyle(.orange)
                    .padding(.top, 40)
                
                Text("Reset Password")
                    .font(.title)
                    .fontWeight(.bold)
                
                Text("Enter your email address and we'll send you instructions to reset your password.")
                    .multilineTextAlignment(.center)
                    .foregroundStyle(.gray)
                    .padding(.horizontal)
                
                TextField("Email", text: $email)
                    .textContentType(.emailAddress)
                    .textInputAutocapitalization(.never)
                    .keyboardType(.emailAddress)
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(12)
                    .padding(.horizontal)
                
                Button {
                    Task {
                        let success = await authViewModel.resetPassword(email: email)
                        if success { showSuccess = true }
                    }
                } label: {
                    if authViewModel.isLoading {
                        ProgressView()
                    } else {
                        Text("Send Reset Link").fontWeight(.semibold)
                    }
                }
                .frame(maxWidth: .infinity)
                .frame(height: 50)
                .background(Color.orange)
                .foregroundStyle(.white)
                .cornerRadius(12)
                .padding(.horizontal)
                .disabled(authViewModel.isLoading || email.isEmpty)
                
                Spacer()
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") { dismiss() }
                }
            }
            .alert("Success", isPresented: $showSuccess) {
                Button("OK") { dismiss() }
            } message: {
                Text("Password reset link sent to your email!")
            }
        }
    }
}

#Preview {
    LoginView().environmentObject(AuthViewModel())
}

