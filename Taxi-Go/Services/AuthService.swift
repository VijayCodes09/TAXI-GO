//
//  AuthService.swift
//  Taxi Go
//

import Foundation
import FirebaseAuth
import FirebaseFirestore

class AuthService {
    
    static let shared = AuthService()
    private init() {}
    
    private let auth = Auth.auth()
    private let db = Firestore.firestore()
    
    // MARK: - Email/Password Authentication
    
    func signUp(email: String, password: String, fullName: String, phoneNumber: String) async throws -> User {
        
        // Create Firebase Auth user
        let result = try await auth.createUser(withEmail: email, password: password)
        
        // Create user document in Firestore
        let user = User(
            id: result.user.uid,
            email: email,
            fullName: fullName,
            phoneNumber: phoneNumber
        )
        
        try await createUserDocument(user: user)
        
        return user
    }
    
    func signIn(email: String, password: String) async throws -> User {
        
        let result = try await auth.signIn(withEmail: email, password: password)
        let user = try await fetchUser(userId: result.user.uid)
        
        return user
    }
    
    // MARK: - Phone Authentication
    
    func sendOTP(phoneNumber: String) async throws -> String {
        
        let verificationID = try await PhoneAuthProvider.provider()
            .verifyPhoneNumber(phoneNumber, uiDelegate: nil)
        
        return verificationID
    }
    
    func verifyOTP(verificationID: String, verificationCode: String, userData: User) async throws -> User {
        
        let credential = PhoneAuthProvider.provider()
            .credential(withVerificationID: verificationID, verificationCode: verificationCode)
        
        let result = try await auth.signIn(with: credential)
        
        // Check if user exists
        do {
            let existingUser = try await fetchUser(userId: result.user.uid)
            return existingUser
        } catch {
            // New user - create document
            var newUser = userData
            newUser.id = result.user.uid
            try await createUserDocument(user: newUser)
            return newUser
        }
    }
    
    // MARK: - User Management
    
    func signOut() throws {
        try auth.signOut()
    }
    
    func resetPassword(email: String) async throws {
        try await auth.sendPasswordReset(withEmail: email)
    }
    
    // MARK: - Firestore Operations
    
    private func createUserDocument(user: User) async throws {
        guard let userId = user.id else {
            throw NSError(domain: "AuthService", code: 400)
        }
        
        try db.collection("users").document(userId).setData(from: user)
    }
    
    func fetchUser(userId: String) async throws -> User {
        let snapshot = try await db.collection("users").document(userId).getDocument()
        
        guard let user = try? snapshot.data(as: User.self) else {
            throw NSError(domain: "AuthService", code: 404)
        }
        
        return user
    }
    
    func updateUser(user: User) async throws {
        guard let userId = user.id else {
            throw NSError(domain: "AuthService", code: 400)
        }
        
        try db.collection("users").document(userId).setData(from: user, merge: true)
    }
    
    // MARK: - Current User
    
    var currentUserId: String? {
        return auth.currentUser?.uid
    }
}

