import SwiftUI

struct PackageView: View {
    
    @State private var pickup = ""
    @State private var drop = ""
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                
                Image(systemName: "box.fill")
                    .font(.system(size: 60))
                    .foregroundStyle(.purple)
                
                Text("Send a Package")
                    .font(.title2)
                    .fontWeight(.bold)
                
                VStack(spacing: 15) {
                    TextField("Pickup Location", text: $pickup)
                        .padding()
                        .background(Color.white)
                        .cornerRadius(10)
                    
                    TextField("Drop Location", text: $drop)
                        .padding()
                        .background(Color.white)
                        .cornerRadius(10)
                }
                
                Spacer()
                
                Button("Send Package") {
                    print("Package requested")
                }
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.purple)
                .foregroundStyle(.white)
                .cornerRadius(12)
            }
            .padding()
            .background(Color(.systemGroupedBackground))
            .navigationTitle("Package")
        }
    }
}

