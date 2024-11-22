//
//  CatagoriesView.swift
//  ClothingStore-iOS
//
//  Created by COBSCCOMPY4231P-15 on 2024-11-10.
//

import SwiftUI
import Kingfisher

struct CatagoriesView: View {
    // Callback function that triggered when a category is select
    let onCategorySelect: (String) -> Void
    // Binding to store the currently selected categor
    @Binding var selectedCategory: String?
    // Sample data for categories,
    var body: some View {
        VStack{
            RoundedRectangle(cornerRadius: 4)
                .fill(Color.gray)
                .frame(width: 150, height: 5)
                .padding()
            HStack {
                Text("Browse Categories")
                    .font(.title2)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .alignmentGuide(.leading) { _ in 0 }
            }
            .padding(EdgeInsets(top: 8, leading: 25, bottom: 0, trailing: 16))
            
            HStack {
                ScrollView {
                    
                    
                    //Item Grid
                    LazyVGrid(columns: [GridItem(.flexible(), spacing: 16), GridItem(.flexible(), spacing: 16)], spacing: 2) {
                        
                        VStack {
                            KFImage.url(URL(string: "https://thebabynation.in/cdn/shop/files/H32A3189.jpg?v=1717585971")).resizable().scaledToFill().frame(width: 150, height: 150).cornerRadius(8)
                            Text("Bedtime Wear")
                                .font(.headline)
                                .foregroundColor(.gray)
                        }
                        .padding()
                        .cornerRadius(10)
                        .onTapGesture {
                            onCategorySelect("Bedtime") // Call the dismiss function, which will now trigger navigation
                        }
                        
                        VStack {
                            KFImage.url(URL(string: "https://m.media-amazon.com/images/I/61-DNzgvKsL._SL1024_.jpg"))
                                .resizable()
                                .scaledToFill()
                                .frame(width: 150, height: 150)
                                .cornerRadius(8)
                            
                            Text("Romper")
                                .font(.headline)
                                .foregroundColor(.gray)
                        }
                        .padding()
                        .cornerRadius(10)
                        .onTapGesture {
                            onCategorySelect("Romper") // Call the dismiss function, which will now trigger navigation
                        }
                        
                        VStack {
                            KFImage.url(URL(string: "https://m.media-amazon.com/images/I/5128qWWAisL._SX679_.jpg"))
                                .resizable()
                                .scaledToFill()
                                .frame(width: 150, height: 150)
                                .cornerRadius(8)
                            
                            Text("Hat")
                                .font(.headline)
                                .foregroundColor(.gray)
                        }
                        .padding()
                        .cornerRadius(10)
                        .onTapGesture {
                            onCategorySelect("Hats") // Call the dismiss function, which will now trigger navigation
                        }
                        
                        
                        VStack {
                            KFImage.url(URL(string: "https://thetrendytoddlers.com/cdn/shop/files/mustard_zebra_baby_jumpsuit_1200x.progressive.jpg?v=1683721245"))
                                .resizable()
                                .scaledToFill()
                                .frame(width: 150, height: 150)
                                .cornerRadius(8)
                            
                            Text("Playsuit")
                                .font(.headline)
                                .foregroundColor(.gray)
                        }
                        .padding()
                        .cornerRadius(10)
                        .onTapGesture {
                            onCategorySelect("Playsuit") // Call the dismiss function, which will now trigger navigation
                        }
                        
                        VStack {
                            KFImage.url(URL(string: "https://assets.shopstar.co.za/uploads/product_image/product_image/display_c4bf27b9-615c-4e08-bf74-9147fe57a66e.jpeg"))
                                .resizable()
                                .scaledToFill()
                                .frame(width: 150, height: 150)
                                .cornerRadius(8)
                            
                            Text("Formal")
                                .font(.headline)
                                .foregroundColor(.gray)
                        }
                        .padding()
                        .cornerRadius(10)
                        .onTapGesture {
                            onCategorySelect("Formal") // Call the dismiss function, which will now trigger navigation
                        }
                        
                        VStack {
                            KFImage.url(URL(string: "https://ae01.alicdn.com/kf/H9f2a5a78ef134d1e8b167768f6148567J.jpg_960x960.jpg"))
                                .resizable()
                                .scaledToFill()
                                .frame(width: 150, height: 150)
                                .cornerRadius(8)
                            
                            Text("Jumper")
                                .font(.headline)
                                .foregroundColor(.gray)
                        }
                        .padding()
                        .cornerRadius(10)
                        .onTapGesture {
                            onCategorySelect("Jumper") // Call the dismiss function, which will now trigger navigation
                        }
                    }
                    
                }
            }
            //padding around the sapce
            .padding(EdgeInsets(top: 8, leading: 16, bottom: 8, trailing: 16))
            
        }
        
    }
}
