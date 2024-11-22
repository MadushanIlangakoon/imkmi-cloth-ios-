//
//  ContentView.swift
//  ClothingStore-iOS
//
//  Created by Navin Thamindu on 2024-10-06.
//

import SwiftUI
// Main content view of the application
struct ContentView: View {
    @ObservedObject private var authenticator = Authenticator.shared
    // Observing the shared Authenticator instance to manage authentication state
    var body: some View {
        if authenticator.isAuthenticated {
            HomeView()// Display home
        } else {
            LoginView()// Display login
        }
    }
}

#Preview {
    ContentView()
}


