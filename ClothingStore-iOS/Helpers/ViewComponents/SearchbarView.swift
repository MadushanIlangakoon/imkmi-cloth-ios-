//
//  SearchbarView.swift
//  ClothingStore-iOS
//
//  Created by COBSCCOMPY4231P-15 on 2024-11-10.
//

import SwiftUI
// Custom Searchbar
struct SearchbarView: View {
    // Binding to a parent view
    @Binding var searchText: String
    
    // Closure that gets triggered when the search button is pressed
    
    var onSearch: (String) -> Void
    var body: some View {
        VStack {
            HStack {
                //Search Input
                TextField("Search", text: $searchText)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                // Search button
                Button(action: {
                    onSearch(searchText)
                }) {
                    //Search Icon
                    Image(systemName: "magnifyingglass")
                        .foregroundColor(BrandPrimary)
                }
            }
            .padding(EdgeInsets(top: 8, leading: 16, bottom: 8, trailing: 16))
        }
    }
}
