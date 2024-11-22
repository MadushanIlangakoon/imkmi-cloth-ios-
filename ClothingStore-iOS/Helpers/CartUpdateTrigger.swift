//
//  CartUpdateTrigger.swift
//  ClothingStore-iOS
//
//  Created by COBSCCOMPY4231P-15 on 2024-11-10.
//

import Foundation
// Managing the state of the cart.
class CartUpdateTrigger: ObservableObject {
    @Published var shouldClearCart: Bool = false
}
