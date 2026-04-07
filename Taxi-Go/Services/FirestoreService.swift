//
//  FirestoreService.swift
//  Taxi Go
//

import Foundation
import FirebaseFirestore

class FirestoreService {
    
    static let shared = FirestoreService()
    private init() {}
    
    private let db = Firestore.firestore()
    
    // MARK: - Rides
    
    func createRide(_ ride: Ride) async throws -> String {
        let docRef = try db.collection("rides").addDocument(from: ride)
        return docRef.documentID
    }
    
    func getRide(rideId: String) async throws -> Ride {
        let snapshot = try await db.collection("rides").document(rideId).getDocument()
        
        guard let ride = try? snapshot.data(as: Ride.self) else {
            throw NSError(domain: "FirestoreService", code: 404)
        }
        
        return ride
    }
    
    func updateRide(_ ride: Ride) async throws {
        guard let rideId = ride.id else {
            throw NSError(domain: "FirestoreService", code: 400)
        }
        
        try db.collection("rides").document(rideId).setData(from: ride, merge: true)
    }
    
    func getUserRides(userId: String) async throws -> [Ride] {
        let snapshot = try await db.collection("rides")
            .whereField("userId", isEqualTo: userId)
            .order(by: "requestedAt", descending: true)
            .getDocuments()
        
        return snapshot.documents.compactMap { try? $0.data(as: Ride.self) }
    }
    
    // MARK: - Bookings
    
    func createBooking(_ booking: Booking) async throws -> String {
        let docRef = try db.collection("bookings").addDocument(from: booking)
        return docRef.documentID
    }
    
    func getUserBookings(userId: String) async throws -> [Booking] {
        let snapshot = try await db.collection("bookings")
            .whereField("userId", isEqualTo: userId)
            .order(by: "createdAt", descending: true)
            .getDocuments()
        
        return snapshot.documents.compactMap { try? $0.data(as: Booking.self) }
    }
}

