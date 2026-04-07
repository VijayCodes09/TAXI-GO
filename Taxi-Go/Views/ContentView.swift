//
//  ContentView.swift
//  Taxi Go
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    
    var body: some View {
        Group {
            if authViewModel.isLoading {
                SplashView()
            } else if authViewModel.userSession != nil {
                MainTabView()
            } else {
                LoginView()
            }
        }
    }
}

struct SplashView: View {
    var body: some View {
        ZStack {
            Color.orange.ignoresSafeArea()
            VStack(spacing: 20) {
                Image(systemName: "car.fill")
                    .font(.system(size: 100))
                    .foregroundStyle(.white)
                Text("Taxi Go")
                    .font(.system(size: 48, weight: .bold))
                    .foregroundStyle(.white)
                ProgressView()
                    .tint(.white)
                    .scaleEffect(1.5)
            }
        }
    }
}

#Preview {
    ContentView().environmentObject(AuthViewModel())
}
