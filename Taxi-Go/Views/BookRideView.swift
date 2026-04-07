import SwiftUI
import MapKit

struct BookRideView: View {
    
    @Environment(\.dismiss) var dismiss
    
    @StateObject var locationManager = LocationManager()
    
    @State private var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 28.6139, longitude: 77.2090),
        span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
    )
    
    var body: some View {
        ZStack {
            
            Map(coordinateRegion: $region)
                .ignoresSafeArea()
            
            Image(systemName: "mappin.circle.fill")
                .font(.system(size: 40))
                .foregroundColor(.red)
            
            VStack {
                
                HStack {
                    Button("Close") {
                        dismiss()
                    }
                    
                    Spacer()
                    
                    Text("Book a Ride")
                        .font(.headline)
                    
                    Spacer()
                    
                    Spacer().frame(width: 50)
                }
                .padding()
                .background(Color.white)
                
                Spacer()
                
                VStack(spacing: 10) {
                    
                    Text("Pickup Location")
                        .font(.caption)
                        .foregroundColor(.gray)
                    
                    Text(locationManager.locationName.isEmpty ? "Fetching location..." : locationManager.locationName)
                        .font(.headline)
                        .multilineTextAlignment(.center)
                    
                    Button("Confirm Pickup") {
                        print("Ride Confirmed 🚖")
                    }
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.orange)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                }
                .padding()
                .background(Color.white)
                .cornerRadius(20)
                .padding()
            }
        }
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                locationManager.requestLocationPermission()
            }
        }
            .onReceive(locationManager.$userLocation) { location in
                if let location = location {
                    region.center = location
                }
            }
        }
    }

