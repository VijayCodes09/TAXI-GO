import SwiftUI

struct TaxiView: View {
    
    @State private var selectedRide = "Mini"
    
    let rides = [
        RideOption(name: "Mini", price: 49, time: "2 min", icon: "car.fill"),
        RideOption(name: "Sedan", price: 79, time: "3 min", icon: "car.fill"),
        RideOption(name: "SUV", price: 119, time: "5 min", icon: "car.fill")
    ]
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                
                // 🚕 Header
                VStack(spacing: 10) {
                    Image(systemName: "car.fill")
                        .font(.system(size: 60))
                        .foregroundStyle(.orange)
                    
                    Text("Quick Rides")
                        .font(.title2)
                        .fontWeight(.bold)
                    
                    Text("Get a ride in minutes")
                        .foregroundStyle(.gray)
                }
                .padding()
                
                // 📍 Pickup Input
                HStack {
                    Image(systemName: "magnifyingglass")
                        .foregroundStyle(.gray)
                    
                    Text("Enter Pickup Location")
                        .foregroundStyle(.gray)
                    
                    Spacer()
                }
                .padding()
                .background(Color.white)
                .cornerRadius(12)
                
                // 🚗 Ride Options
                VStack(spacing: 15) {
                    ForEach(rides) { ride in
                        HStack {
                            
                            Image(systemName: ride.icon)
                                .font(.title2)
                                .foregroundStyle(.orange)
                            
                            VStack(alignment: .leading) {
                                Text(ride.name)
                                    .font(.headline)
                                
                                Text("Arrives in \(ride.time)")
                                    .font(.caption)
                                    .foregroundStyle(.gray)
                            }
                            
                            Spacer()
                            
                            Text("₹\(ride.price)")
                                .font(.headline)
                            
                            if selectedRide == ride.name {
                                Image(systemName: "checkmark.circle.fill")
                                    .foregroundStyle(.orange)
                            }
                        }
                        .padding()
                        .background(Color.white)
                        .cornerRadius(12)
                        .onTapGesture {
                            selectedRide = ride.name
                        }
                    }
                }
                
                Spacer()
                
                // 🔥 Book Button
                Button("Book \(selectedRide)") {
                    print("Booked \(selectedRide)")
                }
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.orange)
                .foregroundStyle(.white)
                .cornerRadius(12)
            }
            .padding()
            .background(Color(.systemGroupedBackground))
            .navigationTitle("Taxi")
        }
    }
}

struct RideOption: Identifiable {
    let id = UUID()
    let name: String
    let price: Int
    let time: String
    let icon: String
}

