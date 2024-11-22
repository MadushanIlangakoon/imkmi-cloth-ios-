//
//  ProductView.swift
//  ClothingStore-iOS
//
//  Created by Navin Thamindu on 2024-10-06.
//

import SwiftUI
import Kingfisher
// Extension to create a SwiftUI Color
extension Color {
    init(hex: String) {
        // Clean up the hex string by removing whitespace and the '#' prefix
        var hexSanitized = hex.trimmingCharacters(in: .whitespacesAndNewlines)
        hexSanitized = hexSanitized.replacingOccurrences(of: "#", with: "")
        
        var rgb: UInt64 = 0
        // Convert the sanitized hex string into a UInt64 value
        Scanner(string: hexSanitized).scanHexInt64(&rgb)
        // Extract red, green, and blue
        let red = Double((rgb & 0xFF0000) >> 16) / 255.0
        let green = Double((rgb & 0x00FF00) >> 8) / 255.0
        let blue = Double(rgb & 0x0000FF) / 255.0
        // Initialize the Color with the extracted RGB values
        self.init(red: red, green: green, blue: blue)
    }
}
// Displaying a product details
struct ProductView: View {
    // Managing product-related actions and state
    @ObservedObject var viewModel = ProductViewModel()
    // State variables for managing
    @State private var products: [Cloth] = []
    @State private var isSidebarShowing = false
    
    let sizes = ["XS", "S", "M", "L", "XL", "XXL"]
    var product: Cloth
    
    var body: some View {
        NavigationView {
            VStack {
                // Display the product image
                ScrollView{
                    KFImage.url(URL(string: product.imageurl)).resizable().scaledToFill().frame(width: 350, height: 250).cornerRadius(5).padding(10)
                    
                    VStack{
                        HStack{
                            Text(product.name)
                                .font(.title2)
                            Spacer()
                        }
                        HStack{
                            Text(product.category)
                                .font(.callout)
                            Spacer()
                        }
                        
                    }.padding(.horizontal, 20)
                    
                    VStack{
                        HStack{
                            Text(product.descrip)
                                .font(.caption)
                                .padding(.vertical, 1)
                            Spacer()
                        }
                        
                        
                    }.padding(.horizontal, 20)
                }
                .background(BackgroundAccent)
                
                Spacer()
                // Section for product details
                VStack{
                    
                    VStack{
                        HStack{
                            Rectangle()
                                .frame(width: 32, height: 32)
                                .foregroundColor(Color(hex: product.colorHex))
                                .cornerRadius(5)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 5)
                                        .stroke(Color.purple, lineWidth: 1)
                                )
                            VStack(alignment: .leading) {
                                Text("Color")
                                    .font(.caption)
                                
                                    .padding(.horizontal, 20)
                                    .multilineTextAlignment(.leading)
                                Text(product.color)
                                    .font(.callout)
                                    .padding(.horizontal, 20)
                                    .multilineTextAlignment(.leading)
                            }
                            .multilineTextAlignment(.leading)
                            
                            Spacer()
                            
                            Text("Rs. \(product.price, specifier: "%.2f")")
                                .font(.title2)
                                .padding(.horizontal, 20)
                                .multilineTextAlignment(.leading)
                        }
                        
                    }
                    .padding(20)
                    
                    HStack{
                        VStack {
                            Text("Selected Size: \(viewModel.selectedSize)")
                                .padding()
                                .multilineTextAlignment(.leading)
                        }
                        Spacer()
                        VStack{
                            
                            Picker("Size", selection: $viewModel.selectedSize) {
                                ForEach(sizes, id: \.self) { size in
                                    Text(size).tag(size)
                                }
                            }
                            .pickerStyle(WheelPickerStyle())
                            .frame(width: 150, height: 100)
                        }
                    }
                    .padding(.horizontal, 10)
                    //                    adding AR Funccanilty
                    //                    HStack {
                    //                        Button(action: {
                    //                            showAR = true
                    //                        }) {
                    //                            Text("Try in AR")
                    //                                .frame(maxWidth: .infinity)
                    //                                .padding()
                    //                                .background(Color.purple)
                    //                                .foregroundColor(.white)
                    //                                .cornerRadius(10)
                    //                        }
                    //                    }
                    //                    .padding()
                    //                    .sheet(isPresented: $showAR) {
                    //                        ARClothingView(product: product)
                    //                    }
                    HStack {
                        
                        Button(action: {
                            // Adding product to cart
                            viewModel.addToCart(product: product)
                        }) {
                            Text("Add to Cart")
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(BrandPrimary)
                                .foregroundColor(.white)
                                .cornerRadius(10)
                        }
                    }
                    .padding()
                    
                }
                
                
                
            }
            
        }
        .navigationViewStyle(.stack)
        // Alert to notify when product added to cart
        .alert(isPresented: $viewModel.showAlert) {
            Alert(title: Text("Product Added"), message: Text(viewModel.alertMessage), dismissButton: .default(Text("OK")))
        }
        
        
    }
}

