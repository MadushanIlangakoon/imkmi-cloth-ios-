//
//  ProoductViewModel.swift
//  ClothingStore-iOS
//
//  Created by COBSCCOMPY4231P-15 on 2024-11-10.
//

import Foundation

class ProductViewModel: ObservableObject {
    // Published properties
    @Published var selectedSize = "M"
    @Published var showAlert: Bool = false
    @Published var alertMessage: String = ""
    
    // Add a product to the cart
    func addToCart(product: Cloth) {
        GlobalVariables.globalCart.append(CartElement(item: product, size: selectedSize))
        // Trigger alert to inform to user the item was add
        addedAlert(itemName: product.name)
        //Testing
        print("DEBUG: Current cart list --")
        for item in GlobalVariables.globalCart {
            print(item.item.name)
        }
    }
    // Make alert message and trigger the alert in display
    func addedAlert(itemName: String) {
        alertMessage = "\(itemName) - Size: \(selectedSize) added to the cart"
        showAlert = true
        
    }
}
