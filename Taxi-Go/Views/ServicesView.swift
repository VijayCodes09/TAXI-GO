import SwiftUI

struct ServicesView: View {
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    
                    // MARK: - Header
                    VStack(spacing: 10) {
                        Text("Explore Services")
                            .font(.title2)
                            .fontWeight(.bold)
                        
                        Text("Find the perfect ride or delivery option for your needs")
                            .foregroundStyle(.gray)
                            .multilineTextAlignment(.center)
                    }
                    .padding()
                    
                    // 🚖 Taxi
                    DetailedServiceCard(
                        title: "Taxi",
                        description: "Instant rides for your daily commute. Affordable and quick pickups anytime.",
                        features: ["Low fares", "Fast pickup", "City rides"],
                        price: "Starting ₹49",
                        color: .orange
                    )
                    
                    // 🚗 Rental
                    DetailedServiceCard(
                        title: "Rental",
                        description: "Book a cab for hours. Perfect for shopping, meetings, or city travel.",
                        features: ["Hourly packages", "Flexible stops", "No surge pricing"],
                        price: "Starting ₹199",
                        color: .blue
                    )
                    
                    // 🛣️ Intercity
                    DetailedServiceCard(
                        title: "Intercity",
                        description: "Travel between cities comfortably with professional drivers.",
                        features: ["One-way & round trip", "Safe travel", "Long distance"],
                        price: "Starting ₹999",
                        color: .green
                    )
                    
                    // 📦 Package
                    DetailedServiceCard(
                        title: "Package",
                        description: "Send packages quickly within the city with real-time tracking.",
                        features: ["Doorstep pickup", "Fast delivery", "Secure handling"],
                        price: "Starting ₹79",
                        color: .purple
                    )
                    
                }
                .padding()
            }
            .background(Color(.systemGroupedBackground))
            .navigationTitle("Services")
        }
    }
}

// MARK: - Detailed Card
struct DetailedServiceCard: View {
    let title: String
    let description: String
    let features: [String]
    let price: String
    let color: Color
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            
            HStack {
                Text(title)
                    .font(.headline)
                
                Spacer()
                
                Text(price)
                    .font(.subheadline)
                    .foregroundStyle(color)
            }
            
            Text(description)
                .font(.caption)
                .foregroundStyle(.gray)
            
            // Features
            VStack(alignment: .leading, spacing: 5) {
                ForEach(features, id: \.self) { feature in
                    HStack {
                        Image(systemName: "checkmark.circle.fill")
                            .foregroundStyle(color)
                        Text(feature)
                            .font(.caption)
                    }
                }
            }
            
            // CTA Button
            Button("Choose \(title)") {
                print("\(title) selected")
            }
            .frame(maxWidth: .infinity)
            .padding()
            .background(color)
            .foregroundStyle(.white)
            .cornerRadius(10)
        }
        .padding()
        .background(Color.white)
        .cornerRadius(15)
    }
}

#Preview {
    ServicesView()
}
