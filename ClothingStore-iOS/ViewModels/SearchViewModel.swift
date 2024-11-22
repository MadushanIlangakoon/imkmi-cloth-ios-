//
//  SearchViewModel.swift
//  ClothingStore-iOS
//
//  Created by COBSCCOMPY4231P-15 on 2024-11-10.
//

import Foundation
import SwiftUI
import UIKit

//Search Screen
class SearchViewModel: ObservableObject {
    @Published var searchText = ""
    @Published var resultedQuery = ""
    @Published var searchResults: [Cloth] = []
    //shake to reset the search
    init() {
        NotificationCenter.default.addObserver(self, selector: #selector(deviceShaken), name: NSNotification.Name("DeviceShaken"), object: nil)
    }
    
    @objc func deviceShaken() {
        resetFilters()
        print("DEBUG: Device shaken")
    }
    // Searching on API
    func searchCloths(query: String) {
        guard let url = URL(string: "http://ec2-52-53-158-252.us-west-1.compute.amazonaws.com:3000/api/cloths/search?query=\(query)") else {
            print("Invalid URL")
            return
        }
        // Create data task to fetch data from URL
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let data = data {
                if let decodedResponse = try? JSONDecoder().decode([Cloth].self, from: data) {
                    DispatchQueue.main.async {
                        self.searchResults = decodedResponse
                        self.resultedQuery = query
                    }
                    return
                }
            }
            print("Fetch failed: \(error?.localizedDescription ?? "Unknown error")")
        }.resume()// Start the data task
        
    }
    
    
    //Customized search bar
    func sortResults(sortOption: SortOption) {
        searchResults.sort(by: sortOption.sortDescriptor)
    }
    
    enum SortOption: String, CaseIterable {
        case nameAscending = "A-Z"
        case nameDescending = "Z-A"
        case priceAscending = "Lowest price to highest"
        case priceDescending = "Highest Price to Lowest"
        case reset = "Reset sorting"
        //Search handelling
        var sortDescriptor: (Cloth, Cloth) -> Bool {
            switch self {
            case .nameAscending:
                return { $0.name < $1.name }
            case .nameDescending:
                return { $0.name > $1.name }
            case .priceAscending:
                return { $0.price < $1.price }
            case .priceDescending:
                return { $0.price > $1.price }
            case .reset:
                return { $0.id < $1.id }
            }
        }
    }
    
    // Reset the filters
    func resetFilters() {
        searchResults.sort(by: SortOption.reset.sortDescriptor)
    }
}

