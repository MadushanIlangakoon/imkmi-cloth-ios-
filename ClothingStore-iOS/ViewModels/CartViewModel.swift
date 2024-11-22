//
//  CartViewModel.swift
//  ClothingStore-iOS
//
//  Created by COBSCCOMPY4231P-15 on 2024-11-10.
//

import Foundation


// lass conforms to ObservableObject
//allowing class to be observed for changes
class CartViewModel: ObservableObject{
    func totalCartPrice() -> Double {
        //Global Cart start value is 0
        return GlobalVariables.globalCart.reduce(0.0) { $0 + $1.item.price }
    }
}
