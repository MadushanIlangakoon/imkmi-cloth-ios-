//
//  SplashscreenViewModel.swift
//  ClothingStore-iOS
//
//  Created by COBSCCOMPY4231P-15 on 2024-11-10.
//

import Foundation

class SplashscreenViewModel: ObservableObject {
    // Published property
    @Published var isAppReady = false
    
    init() {
        // Splash screen delay
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            self.isAppReady = true // App loading
        }
    }
}
