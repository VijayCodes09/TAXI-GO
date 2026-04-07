//
//  Booking.swift
//  Taxi Go
//

import Foundation
import FirebaseFirestore

struct Booking: Identifiable, Codable {
    @DocumentID var id: String?
    var userId: String
    var bookingType: BookingType
    var status: BookingStatus
    
    // Rental specific
    var rentalDuration: Int?
    var rentalPackage: RentalPackage?
    
    // Package specific
    var packageDetails: PackageDetails?
    
    // Intercity specific
    var destination: String?
    var returnTrip: Bool?
    
    // Common fields
    var pickupTime: Date
    var pickupLocation: LocationData?
    var dropoffLocation: LocationData?
    
    var totalPrice: Double
    var paymentStatus: PaymentStatus
    var createdAt: Date
    var confirmedAt: Date?
    
    enum BookingType: String, Codable {
        case rental
        case package
        case intercity
    }
    
    enum BookingStatus: String, Codable {
        case pending
        case confirmed
        case inProgress
        case completed
        case cancelled
    }
    
    enum PaymentStatus: String, Codable {
        case pending
        case paid
        case refunded
    }
}

// MARK: - Rental Package
struct RentalPackage: Codable {
    var name: String
    var hours: Int
    var kilometers: Int
    var price: Double
    var vehicleType: String
}

// MARK: - Package Details
struct PackageDetails: Codable {
    var weight: Double
    var dimensions: String
    var fragile: Bool
    var description: String
    var receiverName: String
    var receiverPhone: String
    var deliveryInstructions: String?
}

