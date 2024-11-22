//
//  User.swift
//  ClothingStore-iOS
//
//  Created by COBSCCOMPY4231P-15 on 2024-11-10.
//

import Foundation
// The User struct
struct User: Codable {
    var id: Int
    var name: String
    var email: String
    var age: Int
    var gender: String
}
// The UserUpdate struct
struct UserUpdate: Codable {
    var name: String
    var email: String
    var age: Int
    var gender: String
    var passwd: String
    
    // This struct allows the user to send a request to update their details on the backend system.
    // Note that the password is included to ensure that the user is authenticated before making changes.
}
