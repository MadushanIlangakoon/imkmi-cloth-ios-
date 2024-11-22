//
//  HomeView.swift
//  ClothingStore-iOS
//
//  Created by Navin Thamindu on 2024-10-06.
//

import SwiftUI
import Kingfisher // A library used to load images from URLs asynchronously.

struct HomeView: View {
    // Creating an observable object to manage the home screen data
    @StateObject var viewModel = HomeViewModel()
    
    // Managing the state for different views and navigation actions
    @State private var isSidebarShowing = false // Controls visibility of sidebar (categories view)
    @State private var navigateToProfile = false // Determines for navigate to the profile screen
    
    @State private var selectedCategory: String? // Tracks selected category for filtering products
    @State private var navigateToCatSearch = false // Controls navigation to category search view
    
    
    
    var body: some View {
        NavigationView {
            
            
            VStack {
                
                Spacer()
                
                ScrollView {
                    //Main Banner
                    KFImage.url(URL(string:"https://i.ibb.co/TT4bnFV/banner-IOS.png")).resizable().scaledToFill().frame(height: 200).cornerRadius(1)
                    
                    HStack {
                        Text("Our Listings")
                            .font(.title)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .alignmentGuide(.leading) { _ in 0 }
                    }
                    .padding(EdgeInsets(top: 8, leading: 16, bottom: 8, trailing: 16))
                    // Product Grid 
                    LazyVGrid(columns: [GridItem(.flexible(), spacing: 16), GridItem(.flexible(), spacing: 16)], spacing: 16) {
                        ForEach(viewModel.cloths) { product in
                            NavigationLink(destination: ProductView(product: product)) {
                                VStack(alignment: .leading, spacing: 8) {
                                    KFImage.url(URL(string:product.imageurl)).resizable().scaledToFill().frame(height: 150 ).cornerRadius(8)
                                    
                                    Text(product.name)
                                        .font(.headline)
                                        .foregroundColor(.primary)
                                        .multilineTextAlignment(.leading)
                                    
                                    Text(product.category)
                                        .font(.subheadline)
                                        .foregroundColor(.gray)
                                    
                                    Text("Rs. \(product.price, specifier: "%.2f")")
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
                // Navigation Link to Category Search View
                NavigationLink(destination: CatSearchView(category: selectedCategory), isActive: $navigateToCatSearch) { EmptyView() }
                
            }
            .navigationBarTitle("IMKMI") //Title
            .navigationBarItems(
                leading: Spacer(),
                trailing:  // Trailing navigation items
                HStack {
                    NavigationLink(destination: SearchView()) {
                        Image(systemName: "magnifyingglass")
                            .foregroundColor(BrandPrimary)
                    }
                    
                    NavigationLink(destination: CartView()) {
                        Image(systemName: "cart.fill")
                            .foregroundColor(BrandPrimary)
                    }
                    
                    Button(action: {
                        isSidebarShowing.toggle()
                    }) {
                        Image(systemName: "circle.grid.3x3.fill")
                            .foregroundColor(BrandPrimary)
                    }
                    
                    NavigationLink(destination: ProfileView()) {
                        Image(systemName: "person.fill")
                            .foregroundColor(BrandPrimary)
                    }
                }
            )
            // Load data when the view appears
            .onAppear {
                viewModel.loadData()
            }
            // Show categories
            .sheet(isPresented: $isSidebarShowing) {
                CatagoriesView(
                    onCategorySelect: { category in
                        self.selectedCategory = category
                        self.navigateToCatSearch = true // This will trigger the navigation to CatSearchView
                        self.isSidebarShowing = false // Dismiss the sheet
                    },
                    selectedCategory: $selectedCategory
                )
            }
        }
        .navigationViewStyle(.stack)
        .onChange(of: selectedCategory) { newValue in
            if let category = newValue {
                navigateToCatSearch = true // Trigger navigation to CatSearchView
            }
        }
    }
}
