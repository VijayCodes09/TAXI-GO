import SwiftUI

struct ActivityView: View {
    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                
                Image(systemName: "clock.fill")
                    .font(.system(size: 60))
                    .foregroundStyle(.orange)
                
                Text("Activity")
                    .font(.title2)
                    .fontWeight(.bold)
                
                Text("Your ride history and upcoming bookings will appear here")
                    .multilineTextAlignment(.center)
                    .foregroundStyle(.gray)
            }
            .padding()
            .navigationTitle("Activity")
        }
    }
}

