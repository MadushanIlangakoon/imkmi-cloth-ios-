//
//  CatSearchViewModel.swift
//  ClothingStore-iOS
//
//  Created by COBSCCOMPY4231P-15 on 2024-11-10.
//

import Foundation

class CatSearchViewModel: ObservableObject {
    @Published var resultedQuery = ""  // Stores the query used to fetch cloth category
    @Published var searchResults: [Cloth] = [] // Fetched search result (array of Cloth objects)
    // Adds an observer for the device shake event
    // dis't test yet . I havent device
    init() {
        // Register to listen for device shake notifications
        NotificationCenter.default.addObserver(self, selector: #selector(deviceShaken), name: NSNotification.Name("DeviceShaken"), object: nil)
    }
    // Triggered this when the device is shaken
    @objc func deviceShaken() {
        resetFilters()
        print("DEBUG: Device shaken")
    }
    // Fetch clothing item based given category
    func fetchClothCategory(cat: String) {
        let urlString = "http://ec2-52-53-158-252.us-west-1.compute.amazonaws.com:3000/api/cloths/category/\(cat)"
        print(urlString)
        guard let url = URL(string: urlString) else {
            print("Invalid URL")// Check URL
            return
        }
        // Data task to fetch the category data
        URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            if let data = data, error == nil {
                
                do {
                    let decodedResponse = try JSONDecoder().decode([Cloth].self, from: data)
                    DispatchQueue.main.async {
                        // Update the searchResults
                        self?.searchResults = decodedResponse
                    }
                } catch {
                    print("Decoding failed: \(error.localizedDescription)")
                }
            } else {
                print("Fetch failed: \(error?.localizedDescription ?? "Unknown error")")
            }
        }.resume()
    }
    
    // Sorts search results on search
    func sortResults(sortOption: SortOption) {
        searchResults.sort(by: sortOption.sortDescriptor)
    }
    // Provides the sort
    enum SortOption: String, CaseIterable {
        case nameAscending = "A-Z"
        case nameDescending = "Z-A"
        case priceAscending = "Lowest price to highest"
        case priceDescending = "Highest Price to Lowest"
        case reset = "Reset sorting"
        
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
    // Resets the search results to the default sorting (by ID) this will be intialized all the time
    func resetFilters() {
        searchResults.sort(by: SortOption.reset.sortDescriptor)
    }
}

