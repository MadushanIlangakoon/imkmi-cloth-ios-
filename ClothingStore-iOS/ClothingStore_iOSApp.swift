//
//  ClothingStore_iOSApp.swift
//  ClothingStore-iOS
//
//  Created by Navin Thamindu on 2024-10-06.
//

import SwiftUI

@main
struct ClothingStore_iOSApp: App {
    // Using UIApplicationDelegateAdaptor to manage app lifecycle events
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    // StateObject to manage the state
    @StateObject var viewModel = SplashscreenViewModel()
    
    var body: some Scene {
        // The main scene
        WindowGroup {
            if viewModel.isAppReady {
                ContentView() // Main content
            } else {
                SplashscreenView()// Splash screen
            }
        }
    }
}

