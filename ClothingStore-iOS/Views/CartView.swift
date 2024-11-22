//
//  CartView.swift
//  ClothingStore-iOS
//
//  Created by Navin Thamindu on 2024-10-06.
//

import SwiftUI
import Kingfisher
// CartView displays user cart, including items, total price and checkout option

struct CartView: View {
    @ObservedObject var viewModel = CartViewModel()// Observed object to managing the view model to handles cart logic
    
    // State variables for managing the cart items
    @State private var cartItems = GlobalVariables.globalCart
    @State private var isSidebarShowing = false
    @State var isActive : Bool = false
    
    // Trigger handle cart updates/clearing
    @ObservedObject var updateTrigger = CartUpdateTrigger()
    
    @ViewBuilder
    private func CartItemView(listItem: CartElement) -> some View {
        HStack {
            KFImage.url(URL(string:listItem.item.imageurl))
                .resizable()
                .scaledToFill()
                .frame(width: 80, height: 80)
                .cornerRadius(8)
            
            VStack(alignment: .leading) {
                Text(listItem.item.name)
                    .font(.headline)
                Text("Rs. \(listItem.item.price, specifier: "%.2f")")
                    .font(.subheadline)
                    .foregroundColor(.gray)
                HStack{
                    Text(listItem.item.category)
                        .font(.caption)
                        .foregroundColor(.gray)
                    Text(listItem.size)
                        .font(.caption)
                        .foregroundColor(.gray)
                }
            }
            .padding(10)
            
            Spacer()
            
            Button(action: {
                // Action for trash button
                GlobalVariables.deleteItem(withId: listItem.id)
                cartItems = GlobalVariables.globalCart
            }) {
                Image(systemName: "trash")
                    .foregroundColor(AlertColor)
            }
        }
        .padding()
        .background(Color(UIColor.systemBackground))
        .cornerRadius(10)
    }
    
    
    
    var body: some View {
        
        VStack {
            // Show empty cart message if cart is empty
            if cartItems.isEmpty {
                Spacer()
                Text("Your cart is empty. Search and add items to cart!")
                    .font(.headline)
                    .foregroundColor(.gray)
                    .multilineTextAlignment(.center)
                    .padding()
                Spacer()
            } else {
                // ScrollView to display cart items
                ScrollView {
                    ForEach(cartItems) { item in
                        CartItemView(listItem: item)
                    }
                    Spacer()
                }
                .background(Color.gray.opacity(0.1).ignoresSafeArea())
            }
            VStack{
                HStack {
                    Text("Total:")
                        .font(.headline)
                    Spacer()
                    Text("Rs. \(viewModel.totalCartPrice(), specifier: "%.2f")")
                        .font(.headline)
                }
                .padding()
                
                HStack {
                    // Checkout button
                    NavigationLink(destination: PaymentView(rootIsActive: self.$isActive), isActive: self.$isActive) {
                        Text("Checkout")
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(BrandPrimary)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                    .isDetailLink(false)
                }
                .padding()
            }
            .padding()
        }
        
        .navigationTitle("Cart") //Title
        .onChange(of: updateTrigger.shouldClearCart) { _ in
            cartItems = []
            GlobalVariables.globalCart.removeAll() // Ensure the global cart is also cleared
        }
        .onAppear {
            // Update cart items in view
            cartItems = GlobalVariables.globalCart
        }
    }
}

struct CartView_Previews: PreviewProvider {
    static var previews: some View {
        CartView()
    }
}



