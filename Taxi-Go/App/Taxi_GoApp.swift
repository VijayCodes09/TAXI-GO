//
//  Taxi_GoApp.swift
//  Taxi Go
//

import SwiftUI
import FirebaseCore

@main
struct Taxi_GoApp: App {
    
    // Register app delegate for Firebase setup
//    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    
    init() {
            FirebaseApp.configure()   
        }
    
    // Initialize AuthViewModel
    @StateObject private var authViewModel = AuthViewModel()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(authViewModel)
        }
    }
}
