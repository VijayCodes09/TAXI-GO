//
//  ProfileView.swift
//  Taxi Go
//

import SwiftUI

struct ProfileView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    @State private var showingEditProfile = false
    @State private var showingSignOutAlert = false
    
    var body: some View {
        NavigationStack {
            List {
                Section {
                    HStack(spacing: 15) {
                        Circle()
                            .fill(Color.orange.gradient)
                            .frame(width: 70, height: 70)
                            .overlay {
                                Text(authViewModel.currentUser?.fullName.prefix(1) ?? "U")
                                    .font(.largeTitle)
                                    .fontWeight(.bold)
                                    .foregroundStyle(.white)
                            }
                        VStack(alignment: .leading, spacing: 5) {
                            Text(authViewModel.currentUser?.fullName ?? "User")
                                .font(.title3)
                                .fontWeight(.bold)
                            Text(authViewModel.currentUser?.email ?? "")
                                .font(.subheadline)
                                .foregroundStyle(.gray)
                            Text(authViewModel.currentUser?.phoneNumber ?? "")
                                .font(.caption)
                                .foregroundStyle(.gray)
                        }
                        Spacer()
                    }
                    .padding(.vertical, 8)
                }
                
                Section {
                    HStack {
                        StatView(title: "Total Rides", value: "\(authViewModel.currentUser?.totalRides ?? 0)")
                        Divider()
                        StatView(title: "Rating", value: String(format: "%.1f", authViewModel.currentUser?.rating ?? 0.0))
                        Divider()
                        StatView(title: "Points", value: "250")
                    }
                    .padding(.vertical, 5)
                }
                
                Section("Account") {
                    Button {
                        showingEditProfile = true
                    } label: {
                        Label("Edit Profile", systemImage: "person.circle")
                    }
                    NavigationLink {
                        Text("Payment Methods")
                    } label: {
                        Label("Payment Methods", systemImage: "creditcard")
                    }
                    NavigationLink {
                        Text("Addresses")
                    } label: {
                        Label("Saved Addresses", systemImage: "mappin.circle")
                    }
                }
                
                Section("Preferences") {
                    NavigationLink {
                        Text("Notifications")
                    } label: {
                        Label("Notifications", systemImage: "bell")
                    }
                    NavigationLink {
                        Text("Privacy")
                    } label: {
                        Label("Privacy & Security", systemImage: "lock.shield")
                    }
                }
                
                Section("Support") {
                    NavigationLink {
                        Text("Help Center")
                    } label: {
                        Label("Help Center", systemImage: "questionmark.circle")
                    }
                    NavigationLink {
                        Text("About")
                    } label: {
                        Label("About Taxi Go", systemImage: "info.circle")
                    }
                }
                
                Section {
                    Button(role: .destructive) {
                        showingSignOutAlert = true
                    } label: {
                        Label("Sign Out", systemImage: "arrow.right.square")
                            .foregroundStyle(.red)
                    }
                }
            }
            .navigationTitle("Profile")
            .sheet(isPresented: $showingEditProfile) {
                EditProfileView().environmentObject(authViewModel)
            }
            .alert("Sign Out", isPresented: $showingSignOutAlert) {
                Button("Cancel", role: .cancel) { }
                Button("Sign Out", role: .destructive) {
                    authViewModel.signOut()
                }
            } message: {
                Text("Are you sure you want to sign out?")
            }
        }
    }
}

struct StatView: View {
    let title: String
    let value: String
    
    var body: some View {
        VStack(spacing: 5) {
            Text(value)
                .font(.title2)
                .fontWeight(.bold)
            Text(title)
                .font(.caption)
                .foregroundStyle(.gray)
        }
        .frame(maxWidth: .infinity)
    }
}

struct EditProfileView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    @Environment(\.dismiss) var dismiss
    @State private var fullName = ""
    @State private var phoneNumber = ""
    @State private var city = ""
    @State private var address = ""
    @State private var isSaving = false
    
    var body: some View {
        NavigationStack {
            Form {
                Section("Personal Information") {
                    TextField("Full Name", text: $fullName)
                    TextField("Phone Number", text: $phoneNumber)
                        .keyboardType(.phonePad)
                }
                Section("Location") {
                    TextField("City", text: $city)
                    TextField("Address", text: $address)
                }
            }
            .navigationTitle("Edit Profile")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") { dismiss() }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        saveProfile()
                    }
                    .disabled(isSaving)
                }
            }
            .onAppear {
                loadUserData()
            }
        }
    }
    
    private func loadUserData() {
        guard let user = authViewModel.currentUser else { return }
        fullName = user.fullName
        phoneNumber = user.phoneNumber
        city = user.city ?? ""
        address = user.address ?? ""
    }
    
    private func saveProfile() {
        guard var user = authViewModel.currentUser else { return }
        user.fullName = fullName
        user.phoneNumber = phoneNumber
        user.city = city
        user.address = address
        isSaving = true
        Task {
            let success = await authViewModel.updateUserProfile(user: user)
            isSaving = false
            if success { dismiss() }
        }
    }
}

#Preview {
    ProfileView().environmentObject(AuthViewModel())
}

