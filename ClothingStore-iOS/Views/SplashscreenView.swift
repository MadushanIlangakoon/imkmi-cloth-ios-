//
//  SplashscreenView.swift
//  ClothingStore-iOS
//
//  Created by Navin Thamindu on 2024-10-06.
//

import SwiftUI
// Displaying a splash screen
struct SplashscreenView: View {
    var body: some View {
        ZStack {
            Color(.systemBackground).edgesIgnoringSafeArea(.all)
            // Loading indicator with a message
            ProgressView("Loading...")
                .progressViewStyle(CircularProgressViewStyle(tint: .purple))
                .scaleEffect(1)
        }
    }
}
#Preview {
    SplashscreenView()
}
