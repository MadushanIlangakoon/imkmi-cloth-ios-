//
//  SearchView.swift
//  ClothingStore-iOS
//
//  Created by Navin Thamindu on 2024-10-06.
//

import SwiftUI
import Kingfisher
import UIKit
// SearchView allows the user to search for products
struct SearchView: View {
    @StateObject private var viewModel = SearchViewModel() // View model that handles the data and logic
    @State private var sortOption: SearchViewModel.SortOption? // State to hold the selected sorting option
    
    
    var body: some View {
        
        VStack {
            SearchbarView(searchText: $viewModel.searchText, onSearch: viewModel.searchCloths)
            
            ScrollView {
                VStack {
                    HStack {
                        //Product search
                        Text("Searching for '\(viewModel.resultedQuery)'")
                            .font(.callout)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .alignmentGuide(.leading) { _ in 0 }
                        Spacer()
                        // Menu for sorting results
                        Menu {
                            ForEach(SearchViewModel.SortOption.allCases, id: \.self) { option in
                                Button(option.rawValue) {
                                    sortOption = option
                                    viewModel.sortResults(sortOption: option)
                                }
                            }
                        } label: {
                            Image(systemName: "slider.horizontal.3")
                                .foregroundColor(BrandPrimary)
                            Text("Refine").font(.caption)
                                .foregroundColor(BrandPrimary)
                        }
                    }
                    .padding(EdgeInsets(top: 8, leading: 16, bottom: 8, trailing: 16))
                }
                //product get
                LazyVGrid(columns: [GridItem(.flexible(), spacing: 16), GridItem(.flexible(), spacing: 16)], spacing: 16) {
                    ForEach(viewModel.searchResults) { cloth in
                        NavigationLink(destination: ProductView(product: cloth)) {
                            VStack(alignment: .leading, spacing: 8) {
                                // Make the image resizable
                                KFImage.url(URL(string: cloth.imageurl)).resizable().scaledToFill().frame(height: 150).cornerRadius(8)
                                
                                Text(cloth.name)
                                    .font(.headline)
                                    .foregroundColor(.primary)
                                    .multilineTextAlignment(.leading)
                                
                                Text(cloth.category)
                                    .font(.subheadline)
                                    .foregroundColor(.gray)
                                
                                Text("Rs. \(cloth.price, specifier: "%.2f")")
                                    .font(.headline)
                                    .foregroundColor(BrandPrimary)
                            }
                            .padding()
                            .background(Color(UIColor.systemBackground))
                            .cornerRadius(10)
                        }
                    }
                }
                .padding()
            }
            .background(Color.gray.opacity(0.1).ignoresSafeArea())
            .navigationTitle("Search")
            
            
        }
    }
}

