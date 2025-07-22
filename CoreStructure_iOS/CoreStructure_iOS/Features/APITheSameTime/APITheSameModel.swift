//
//  APITheSameModel.swift
//  CoreStructure_iOS
//
//  Created by Rath! on 21/7/25.
//

import Foundation

// Top-level response for paginated products
struct ProductListResponse: Codable {
    let count: Int
    let next: String?
    let previous: String?
    let results: [Product]?
}

// Single product model
struct Product: Codable {
    let id: Int
    let name: String
    let price: String
    let createdAt: String
    let createdBy: Int

    // Map JSON keys to Swift properties
    enum CodingKeys: String, CodingKey {
        case id, name, price
        case createdAt = "created_at"
        case createdBy = "created_by"
    }
}

