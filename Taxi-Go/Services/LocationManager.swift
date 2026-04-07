//
//  LocationManager.swift
//  Taxi Go
//

import Foundation
import CoreLocation
import MapKit
import Combine

class LocationManager: NSObject, ObservableObject {
    
    // MARK: - Published Properties
    @Published var userLocation: CLLocationCoordinate2D?
    @Published var locationName: String = ""
    @Published var authorizationStatus: CLAuthorizationStatus = .notDetermined
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    // MARK: - Properties
    private let locationManager = CLLocationManager()
    private let geocoder = CLGeocoder()
    
    // Prevent excessive API calls
    private var lastGeocodeTime = Date.distantPast
    
    // MARK: - Initialization
    override init() {
        super.init()
        locationManager.delegate = self   // ✅ IMPORTANT
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.distanceFilter = 10
    }
    
    // MARK: - Public Methods
    func requestLocationPermission() {
        print("📍 Requesting permission")
        
        DispatchQueue.main.async {
            self.locationManager.requestWhenInUseAuthorization()
        }
    }
    
    func startUpdatingLocation() {
        print("📍 Starting location updates")
        isLoading = true
        locationManager.startUpdatingLocation()
    }
    
    func stopUpdatingLocation() {
        locationManager.stopUpdatingLocation()
    }
    
    // MARK: - Reverse Geocoding
    func getAddress(from coordinate: CLLocationCoordinate2D) async -> String? {
        let location = CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)
        
        do {
            let placemarks = try await geocoder.reverseGeocodeLocation(location)
            guard let placemark = placemarks.first else { return nil }
            
            return formatAddress(from: placemark)
            
        } catch {
            print("❌ Geocoding error:", error.localizedDescription)
            return nil
        }
    }
    
    // MARK: - Address Formatter
    private func formatAddress(from placemark: CLPlacemark) -> String {
        var components: [String] = []
        
        if let name = placemark.name {
            components.append(name)
        }
        if let locality = placemark.locality {
            components.append(locality)
        }
        if let adminArea = placemark.administrativeArea {
            components.append(adminArea)
        }
        
        return components.isEmpty ? "Unknown Location" : components.joined(separator: ", ")
    }
}

// MARK: - CLLocationManagerDelegate
extension LocationManager: CLLocationManagerDelegate {
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        authorizationStatus = manager.authorizationStatus
        
        print("📍 Authorization status:", manager.authorizationStatus.rawValue)
        
        switch manager.authorizationStatus {
        case .authorizedWhenInUse, .authorizedAlways:
            print("✅ Permission granted")
            startUpdatingLocation()
            
        case .denied, .restricted:
            print("❌ Permission denied")
            errorMessage = "Location access denied. Enable it in Settings."
            isLoading = false
            
        case .notDetermined:
            print("⏳ Permission not determined")
            
        @unknown default:
            break
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        print("📍 didUpdateLocations called")   // ✅ DEBUG
        
        guard let location = locations.last else { return }
        
        print("LAT:", location.coordinate.latitude)
        print("LNG:", location.coordinate.longitude)
        
        DispatchQueue.main.async {
            self.userLocation = location.coordinate
        }
        
        // Throttle reverse geocoding
        Task {
            let now = Date()
            
            if now.timeIntervalSince(lastGeocodeTime) > 2 {
                lastGeocodeTime = now
                
                if let address = await getAddress(from: location.coordinate) {
                    await MainActor.run {
                        print("📍 Address:", address)
                        
                        self.locationName = address
                        self.isLoading = false
                    }
                }
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("❌ Location error:", error.localizedDescription)
        errorMessage = error.localizedDescription
        isLoading = false
    }
}

// MARK: - Place Result Model
struct PlaceResult: Identifiable {
    let id = UUID()
    let name: String
    let address: String
    let coordinate: CLLocationCoordinate2D
}
