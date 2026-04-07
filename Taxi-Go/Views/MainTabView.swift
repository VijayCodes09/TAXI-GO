//
//  MainTabView.swift
//  Taxi Go
//

import SwiftUI

struct MainTabView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    @State private var selectedTab = 0
    
    var body: some View {
        TabView(selection: $selectedTab) {
            HomeView()
                .tabItem { Label("Home", systemImage: "house.fill") }
                .tag(0)
            
            ActivityView()
                .tabItem { Label("Activity", systemImage: "clock.fill") }
                .tag(1)
            
            ServicesView()
                .tabItem { Label("Services", systemImage: "square.grid.2x2.fill") }
                .tag(2)
            
            ProfileView()
                .tabItem { Label("Profile", systemImage: "person.fill") }
                .tag(3)
        }
        .tint(.orange)
    }
}

#Preview {
    MainTabView().environmentObject(AuthViewModel())
}

