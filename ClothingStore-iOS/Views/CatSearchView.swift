//
//  CatSearchView.swift
//  ClothingStore-iOS
//
//  Created by Navin Thamindu on 2024-10-06.
//


import SwiftUI
import Kingfisher
import UIKit
// View for displaying search results
struct CatSearchView: View {
    // ViewModel to manage category search and sorting logic
    @StateObject private var viewModel = CatSearchViewModel()
    // State variable to keep track of selected sorting option
    @State private var sortOption: CatSearchViewModel.SortOption?
    
    // Category to filter
    var category: String?
    
    var body: some View {
        VStack {
            ScrollView {
                VStack {
                    HStack {
                        Text("Searching for '\(category ?? "Unknown")'")
                            .font(.callout)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .alignmentGuide(.leading) { _ in 0 }
                        Spacer()
                        // Menu for selecting
                        Menu {
                            ForEach(CatSearchViewModel.SortOption.allCases, id: \.self) { option in
                                Button(option.rawValue) {
                                    sortOption = option
                                    viewModel.sortResults(sortOption: option)
                                }
                            }
                        } label: {
                            // Button to open the sorting menu
                            Image(systemName: "slider.horizontal.3")
                                .foregroundColor(BrandPrimary)
                            Text("Refine").font(.caption)
                                .foregroundColor(BrandPrimary)
                        }
                    }
                    .padding(EdgeInsets(top: 8, leading: 16, bottom: 8, trailing: 16))
                }
                // Grid view for results
                LazyVGrid(columns: [GridItem(.flexible(), spacing: 16), GridItem(.flexible(), spacing: 16)], spacing: 16) {
                    ForEach(viewModel.searchResults) { cloth in
                        NavigationLink(destination: ProductView(product: cloth)) {
                            VStack(alignment: .leading, spacing: 8) {
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
            .navigationTitle("Catagories")  // Title
        }
        .onAppear {
            // Fetch category-specific products
            viewModel.fetchClothCategory(cat: category ?? "Unknown")
        }
    }
}

#Preview {
    CatSearchView()
}


