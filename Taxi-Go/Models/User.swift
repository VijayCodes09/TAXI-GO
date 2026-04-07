//
//  User.swift
//  Taxi Go
//

import Foundation
import FirebaseFirestore

struct User: Identifiable, Codable, Equatable {
    @DocumentID var id: String?
    var email: String
    var fullName: String
    var phoneNumber: String
    var profileImageURL: String?
    var createdAt: Date
    var userType: UserType
    
    // Optional fields
    var address: String?
    var city: String?
    var rating: Double?
    var totalRides: Int
    
    enum UserType: String, Codable {
        case passenger
        case driver
    }
    
    // Default initializer
    init(
        id: String? = nil,
        email: String,
        fullName: String,
        phoneNumber: String,
        profileImageURL: String? = nil,
        createdAt: Date = Date(),
        userType: UserType = .passenger,
        address: String? = nil,
        city: String? = nil,
        rating: Double? = nil,
        totalRides: Int = 0
    ) {
        self.id = id
        self.email = email
        self.fullName = fullName
        self.phoneNumber = phoneNumber
        self.profileImageURL = profileImageURL
        self.createdAt = createdAt
        self.userType = userType
        self.address = address
        self.city = city
        self.rating = rating
        self.totalRides = totalRides
    }
    
    // MARK: - Equatable Conformance
    static func == (lhs: User, rhs: User) -> Bool {
        return lhs.id == rhs.id &&
               lhs.email == rhs.email &&
               lhs.fullName == rhs.fullName &&
               lhs.phoneNumber == rhs.phoneNumber &&
               lhs.profileImageURL == rhs.profileImageURL &&
               lhs.userType == rhs.userType &&
               lhs.address == rhs.address &&
               lhs.city == rhs.city &&
               lhs.rating == rhs.rating &&
               lhs.totalRides == rhs.totalRides
    }
}

// MARK: - Mock Data
extension User {
    static let mockUser = User(
        id: "mock123",
        email: "john@example.com",
        fullName: "John Doe",
        phoneNumber: "+1234567890",
        city: "Raipur",
        rating: 4.8,
        totalRides: 45
    )
}
