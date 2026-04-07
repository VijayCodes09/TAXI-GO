import SwiftUI

struct RentalView: View {
    
    @State private var selectedPackage = "2 Hours"
    
    let packages = [
        "2 Hours", "4 Hours", "8 Hours"
    ]
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                
                // Header
                VStack(spacing: 10) {
                    Image(systemName: "clock.fill")
                        .font(.system(size: 60))
                        .foregroundStyle(.blue)
                    
                    Text("Rental Packages")
                        .font(.title2)
                        .fontWeight(.bold)
                    
                    Text("Book cab for hours")
                        .foregroundStyle(.gray)
                }
                .padding()
                
                // Package Selection
                VStack(spacing: 15) {
                    ForEach(packages, id: \.self) { pack in
                        HStack {
                            Text(pack)
                                .font(.headline)
                            
                            Spacer()
                            
                            Text("₹\(price(for: pack))")
                                .font(.subheadline)
                            
                            if selectedPackage == pack {
                                Image(systemName: "checkmark.circle.fill")
                                    .foregroundStyle(.blue)
                            }
                        }
                        .padding()
                        .background(Color.white)
                        .cornerRadius(12)
                        .onTapGesture {
                            selectedPackage = pack
                        }
                    }
                }
                
                Spacer()
                
                Button("Book Rental") {
                    print("Rental booked")
                }
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.blue)
                .foregroundStyle(.white)
                .cornerRadius(12)
            }
            .padding()
            .background(Color(.systemGroupedBackground))
            .navigationTitle("Rental")
        }
    }
    
    func price(for pack: String) -> Int {
        switch pack {
        case "2 Hours": return 199
        case "4 Hours": return 349
        case "8 Hours": return 699
        default: return 0
        }
    }
}

