//
//  Ride.swift
//  Taxi Go
//

import Foundation
import FirebaseFirestore
import CoreLocation

struct Ride: Identifiable, Codable {
    @DocumentID var id: String?
    var userId: String
    var driverId: String?
    
    // Location data
    var pickupLocation: LocationData
    var dropoffLocation: LocationData
    
    // Ride details
    var serviceType: ServiceType
    var vehicleType: VehicleType
    var status: RideStatus
    
    // Pricing
    var estimatedPrice: Double
    var finalPrice: Double?
    var distance: Double
    var duration: Int
    
    // Timestamps
    var requestedAt: Date
    var acceptedAt: Date?
    var startedAt: Date?
    var completedAt: Date?
    
    // Additional info
    var paymentMethod: PaymentMethod
    var notes: String?
    var rating: Int?
    var feedback: String?
    
    enum ServiceType: String, Codable {
        case taxi
        case rental
        case intercity
        case package
    }
    
    enum VehicleType: String, Codable {
        case economy
        case premium
        case suv
        case bike
    }
    
    enum RideStatus: String, Codable {
        case requested
        case accepted
        case arrived
        case ongoing
        case completed
        case cancelled
    }
    
    enum PaymentMethod: String, Codable {
        case cash
        case card
        case wallet
        case upi
    }
}

// MARK: - Location Data
struct LocationData: Codable {
    var latitude: Double
    var longitude: Double
    var address: String
    var placeName: String?
    
    var coordinate: CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
    
    init(latitude: Double, longitude: Double, address: String, placeName: String? = nil) {
        self.latitude = latitude
        self.longitude = longitude
        self.address = address
        self.placeName = placeName
    }
}

