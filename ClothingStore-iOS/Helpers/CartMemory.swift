//
//  File.swift
//  ClothingStore-iOS
//
//  Created by COBSCCOMPY4231P-15 on 2024-11-10.
//

import Foundation

struct CartElement: Identifiable {
    var id = UUID() //cart get Univercial ID
    var item: Cloth // The item in cart (Cloth)
    var size: String
}
// GlobalVariables struct is used to manage global variables
// This holds a static global cart array and provides methods
struct GlobalVariables {
    // A static array stores all the cart items as CartElement objects
    static var globalCart: [CartElement] = []
    // A static function that removes a CartElement
    static func deleteItem(withId id: UUID) {
        globalCart.removeAll { $0.id == id }
    }
}
