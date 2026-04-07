//
//  RideViewModel.swift
//  Taxi Go
//

import Foundation
import CoreLocation
import Combine

@MainActor
class RideViewModel: ObservableObject {
    
    // MARK: - Published Properties
    @Published var currentRide: Ride?
    @Published var rideHistory: [Ride] = []
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    // Booking flow
    @Published var pickupLocation: LocationData?
    @Published var dropoffLocation: LocationData?
    @Published var selectedVehicleType: Ride.VehicleType = .economy
    @Published var estimatedPrice: Double = 0.0
    @Published var distance: Double = 0.0
    
    // MARK: - Services
    private let firestoreService = FirestoreService.shared
    
    // Pricing
    private let baseFare: Double = 30.0
    private let perKmRate: [Ride.VehicleType: Double] = [
        .economy: 10.0,
        .premium: 15.0,
        .suv: 20.0,
        .bike: 7.0
    ]
    
    // MARK: - Request Ride
    func requestRide(userId: String) async -> Bool {
        
        guard let pickup = pickupLocation,
              let dropoff = dropoffLocation else {
            errorMessage = "Please select pickup and dropoff locations"
            return false
        }
        
        isLoading = true
        
        let ride = Ride(
            id: nil,
            userId: userId,
            pickupLocation: pickup,
            dropoffLocation: dropoff,
            serviceType: .taxi,
            vehicleType: selectedVehicleType,
            status: .requested,
            estimatedPrice: estimatedPrice,
            distance: distance,
            duration: 15,
            requestedAt: Date(),
            paymentMethod: .cash
        )
        
        do {
            let rideId = try await firestoreService.createRide(ride)
            var createdRide = ride
            createdRide.id = rideId
            self.currentRide = createdRide
            isLoading = false
            return true
            
        } catch {
            errorMessage = error.localizedDescription
            isLoading = false
            return false
        }
    }
    
    // MARK: - Fetch Rides
    func fetchUserRides(userId: String) async {
        isLoading = true
        
        do {
            let rides = try await firestoreService.getUserRides(userId: userId)
            self.rideHistory = rides
            
        } catch {
            errorMessage = error.localizedDescription
        }
        
        isLoading = false
    }
    
    // MARK: - Calculate Estimate
    func calculateEstimate() {
        guard let pickup = pickupLocation,
              let dropoff = dropoffLocation else { return }
        
        let pickupCoord = CLLocation(latitude: pickup.latitude, longitude: pickup.longitude)
        let dropoffCoord = CLLocation(latitude: dropoff.latitude, longitude: dropoff.longitude)
        
        let distanceInMeters = pickupCoord.distance(from: dropoffCoord)
        distance = distanceInMeters / 1000
        
        let perKm = perKmRate[selectedVehicleType] ?? 10.0
        estimatedPrice = baseFare + (distance * perKm)
    }
    
    func setPickupLocation(_ location: LocationData) {
        pickupLocation = location
        if dropoffLocation != nil {
            calculateEstimate()
        }
    }
    
    func setDropoffLocation(_ location: LocationData) {
        dropoffLocation = location
        if pickupLocation != nil {
            calculateEstimate()
        }
    }
}

