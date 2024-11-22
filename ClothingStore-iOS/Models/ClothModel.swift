//
//  ClothModel.swift
//  ClothingStore-iOS
//
//  Created by Navin Thamindu on 2024-10-06.
//
// from JSON and Identifiable to provide a unique identifier for each item
struct Cloth: Codable, Identifiable {
    let id: Int
    let name: String
    let category: String
    let price: Double
    let imageurl: String
    let descrip: String
    let color: String
    let colorHex: String // The hex color code for the cloth's color (e.g., "#FF5733")
}
