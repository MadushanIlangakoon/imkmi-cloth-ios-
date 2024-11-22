//
//  HomeViewModel.swift
//  ClothingStore-iOS
//
//  Created by COBSCCOMPY4231P-15 on 2024-11-10.
//

import Foundation
import Combine

class HomeViewModel: ObservableObject {
    @Published var cloths: [Cloth] = [] // Published property to hold an array of Cloth objects,
    // FLoad data from the API
    func loadData() {
        guard let url = URL(string: "http://ec2-52-53-158-252.us-west-1.compute.amazonaws.com:3000/api/cloths") else {
            print("Invalid URL")
            return
        }
        // Create data task
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let data = data {
                if let decodedResponse = try? JSONDecoder().decode([Cloth].self, from: data) {
                    DispatchQueue.main.async {
                        self.cloths = decodedResponse
                    }
                    return
                }
            }
            print("Fetch failed: \(error?.localizedDescription ?? "Unknown error")")
        }.resume()
    }
}

