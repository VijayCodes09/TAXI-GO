//
//  HomeView.swift
//  Taxi Go
//

import SwiftUI

struct HomeView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    @StateObject private var rideViewModel = RideViewModel()
    @State private var showingBookRide = false
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color(.systemGroupedBackground).ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 20) {
                        
                        // MARK: - Header
                        HStack {
                            VStack(alignment: .leading, spacing: 5) {
                                Text("Welcome back,")
                                    .font(.subheadline)
                                    .foregroundStyle(.gray)
                                
                                Text(authViewModel.currentUser?.fullName ?? "User")
                                    .font(.title2)
                                    .fontWeight(.bold)
                            }
                            
                            Spacer()
                            
                            Circle()
                                .fill(Color.orange.gradient)
                                .frame(width: 50, height: 50)
                                .overlay {
                                    Text(authViewModel.currentUser?.fullName.prefix(1) ?? "U")
                                        .font(.title3)
                                        .fontWeight(.bold)
                                        .foregroundStyle(.white)
                                }
                        }
                        .padding()
                        .background(Color.white)
                        .cornerRadius(15)
                        
                        // MARK: - Book Ride Card (Map Screen)
                        VStack {
                            HStack {
                                Image(systemName: "car.fill")
                                    .font(.title2)
                                    .foregroundStyle(.orange)
                                
                                VStack(alignment: .leading, spacing: 5) {
                                    Text("Book a Ride")
                                        .font(.headline)
                                    
                                    Text("Get picked up in minutes")
                                        .font(.caption)
                                        .foregroundStyle(.gray)
                                }
                                
                                Spacer()
                                
                                Image(systemName: "chevron.right")
                                    .foregroundStyle(.gray)
                            }
                            .padding()
                        }
                        .background(Color.white)
                        .cornerRadius(12)
                        .onTapGesture {
                            showingBookRide = true
                        }
                        
                        // MARK: - Services
                        VStack(alignment: .leading, spacing: 15) {
                            Text("Our Services")
                                .font(.headline)
                                .padding(.horizontal)
                            
                            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 15) {
                                
                                // 🚖 Taxi
                                NavigationLink {
                                    TaxiView()
                                } label: {
                                    ServiceCard(
                                        icon: "car.fill",
                                        title: "Taxi",
                                        subtitle: "Quick rides",
                                        color: .orange
                                    )
                                }
                                .buttonStyle(.plain)
                                
                                // 🚗 Rental
                                NavigationLink {
                                    RentalView()
                                } label: {
                                    ServiceCard(
                                        icon: "clock.fill",
                                        title: "Rental",
                                        subtitle: "Hourly packages",
                                        color: .blue
                                    )
                                }
                                .buttonStyle(.plain)
                                
                                // 🛣️ Intercity
                                NavigationLink {
                                    IntercityView()
                                } label: {
                                    ServiceCard(
                                        icon: "map.fill",
                                        title: "Intercity",
                                        subtitle: "Long distance",
                                        color: .green
                                    )
                                }
                                .buttonStyle(.plain)
                                
                                // 📦 Package
                                NavigationLink {
                                    PackageView()
                                } label: {
                                    ServiceCard(
                                        icon: "box.fill",
                                        title: "Package",
                                        subtitle: "Delivery service",
                                        color: .purple
                                    )
                                }
                                .buttonStyle(.plain)
                            }
                        }
                        
                        // MARK: - Recent Rides
                        if !rideViewModel.rideHistory.isEmpty {
                            VStack(alignment: .leading, spacing: 15) {
                                Text("Recent Rides")
                                    .font(.headline)
                                    .padding(.horizontal)
                                
                                ForEach(rideViewModel.rideHistory.prefix(3)) { ride in
                                    RideHistoryCard(ride: ride)
                                }
                            }
                        }
                    }
                    .padding()
                }
            }
            .navigationTitle("Taxi Go")
            .navigationBarTitleDisplayMode(.inline)
            
            // Fetch rides
            .task {
                if let userId = authViewModel.currentUser?.id {
                    await rideViewModel.fetchUserRides(userId: userId)
                }
            }
            
            // Open Map Screen
            .sheet(isPresented: $showingBookRide) {
                BookRideView()
                    .environmentObject(authViewModel)
            }
        }
    }
}

// MARK: - Service Card
struct ServiceCard: View {
    let icon: String
    let title: String
    let subtitle: String
    let color: Color
    
    var body: some View {
        VStack(spacing: 10) {
            Image(systemName: icon)
                .font(.system(size: 30))
                .foregroundStyle(color)
            
            Text(title)
                .font(.headline)
            
            Text(subtitle)
                .font(.caption)
                .foregroundStyle(.gray)
        }
        .frame(maxWidth: .infinity)
        .frame(height: 120)
        .background(Color.white)
        .cornerRadius(15)
    }
}

// MARK: - Ride History Card
struct RideHistoryCard: View {
    let ride: Ride
    
    var body: some View {
        HStack {
            Circle()
                .fill(statusColor.gradient)
                .frame(width: 40, height: 40)
                .overlay {
                    Image(systemName: statusIcon)
                        .foregroundStyle(.white)
                }
            
            VStack(alignment: .leading, spacing: 5) {
                Text(ride.pickupLocation.address)
                    .font(.subheadline)
                    .fontWeight(.medium)
                    .lineLimit(1)
                
                Text(ride.dropoffLocation.address)
                    .font(.caption)
                    .foregroundStyle(.gray)
                    .lineLimit(1)
                
                Text(ride.requestedAt, style: .date)
                    .font(.caption2)
                    .foregroundStyle(.gray)
            }
            
            Spacer()
            
            Text("₹\(Int(ride.estimatedPrice))")
                .font(.headline)
        }
        .padding()
        .background(Color.white)
        .cornerRadius(12)
    }
    
    private var statusColor: Color {
        switch ride.status {
        case .completed: return .green
        case .cancelled: return .red
        case .ongoing: return .blue
        default: return .orange
        }
    }
    
    private var statusIcon: String {
        switch ride.status {
        case .completed: return "checkmark"
        case .cancelled: return "xmark"
        case .ongoing: return "car.fill"
        default: return "clock.fill"
        }
    }
}

#Preview {
    HomeView().environmentObject(AuthViewModel())
}
