//
//  AuthViewModel.swift
//  Taxi Go
//

import Foundation
import FirebaseAuth
import Combine

@MainActor
class AuthViewModel: ObservableObject {
    
    // MARK: - Published Properties
    @Published var userSession: FirebaseAuth.User?
    @Published var currentUser: User?
    @Published var isLoading = true
    @Published var errorMessage: String?
    
    // MARK: - Services
    private let authService = AuthService.shared
    private var authStateHandle: AuthStateDidChangeListenerHandle?
    
    // MARK: - Initialization
    init() {
        setupAuthStateListener()
    }
    
    // MARK: - Auth State Listener
    private func setupAuthStateListener() {
        authStateHandle = Auth.auth().addStateDidChangeListener { [weak self] _, user in
            Task { @MainActor in
                self?.userSession = user
                
                if user != nil {
                    await self?.fetchCurrentUser()
                } else {
                    self?.currentUser = nil
                    self?.isLoading = false
                }
            }
        }
    }
    
    // MARK: - Sign Up
    func signUp(email: String, password: String, fullName: String, phoneNumber: String) async {
        isLoading = true
        errorMessage = nil
        
        do {
            let user = try await authService.signUp(
                email: email,
                password: password,
                fullName: fullName,
                phoneNumber: phoneNumber
            )
            
            self.currentUser = user
            
        } catch {
            self.errorMessage = error.localizedDescription
        }
        
        isLoading = false
    }
    
    // MARK: - Sign In
    func signIn(email: String, password: String) async {
        isLoading = true
        errorMessage = nil
        
        do {
            let user = try await authService.signIn(email: email, password: password)
            self.currentUser = user
            
        } catch {
            self.errorMessage = error.localizedDescription
        }
        
        isLoading = false
    }
    
    // MARK: - Sign Out
    func signOut() {
        do {
            try authService.signOut()
            self.userSession = nil
            self.currentUser = nil
        } catch {
            self.errorMessage = error.localizedDescription
        }
    }
    
    // MARK: - Password Reset
    func resetPassword(email: String) async -> Bool {
        isLoading = true
        errorMessage = nil
        
        do {
            try await authService.resetPassword(email: email)
            isLoading = false
            return true
            
        } catch {
            self.errorMessage = error.localizedDescription
            isLoading = false
            return false
        }
    }
    
    // MARK: - Fetch User
    func fetchCurrentUser() async {
        guard let userId = authService.currentUserId else {
            isLoading = false
            return
        }
        
        do {
            let user = try await authService.fetchUser(userId: userId)
            self.currentUser = user
            
        } catch {
            self.errorMessage = error.localizedDescription
        }
        
        isLoading = false
    }
    
    func updateUserProfile(user: User) async -> Bool {
        do {
            try await authService.updateUser(user: user)
            self.currentUser = user
            return true
        } catch {
            self.errorMessage = error.localizedDescription
            return false
        }
    }
    
    // MARK: - Validation
    func validateEmail(_ email: String) -> Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        return emailPredicate.evaluate(with: email)
    }
    
    func validatePassword(_ password: String) -> Bool {
        return password.count >= 6
    }
    
    func validatePhoneNumber(_ phone: String) -> Bool {
        let phoneRegex = "^[+]?[0-9]{10,15}$"
        let phonePredicate = NSPredicate(format: "SELF MATCHES %@", phoneRegex)
        return phonePredicate.evaluate(with: phone)
    }
}

