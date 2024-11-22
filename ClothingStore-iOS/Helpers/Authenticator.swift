//
//  Authenicator.swift
//  ClothingStore-iOS
//
//  Created by COBSCCOMPY4231P-15 on 2024-11-10.
//

import Foundation
// The Authenticator class responsible for managing authentication state of user
class Authenticator: ObservableObject {
    // Published property for track authentication state
    @Published var isAuthenticated: Bool = false
    static let shared = Authenticator()
    
    static var id: Int?
    static var name: String?
    static var email: String?
    static var age: Int?
    static var gender: String?
}
