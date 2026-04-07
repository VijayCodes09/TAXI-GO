import SwiftUI

struct IntercityView: View {
    
    @State private var from = ""
    @State private var to = ""
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                
                Image(systemName: "map.fill")
                    .font(.system(size: 60))
                    .foregroundStyle(.green)
                
                Text("Intercity Travel")
                    .font(.title2)
                    .fontWeight(.bold)
                
                VStack(spacing: 15) {
                    TextField("From City", text: $from)
                        .padding()
                        .background(Color.white)
                        .cornerRadius(10)
                    
                    TextField("To City", text: $to)
                        .padding()
                        .background(Color.white)
                        .cornerRadius(10)
                }
                
                Spacer()
                
                Button("Search Rides") {
                    print("Searching intercity rides")
                }
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.green)
                .foregroundStyle(.white)
                .cornerRadius(12)
            }
            .padding()
            .background(Color(.systemGroupedBackground))
            .navigationTitle("Intercity")
        }
    }
}


