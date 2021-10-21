//
//  Restaurant.swift
//  AllTrailsLunch
//
//  Created by Alex Carroll on 10/19/21.
//

import Foundation
import UIKit

struct Restaurant: Codable {
    let name: String?
    let priceLevel: Int?
    let rating: Double?
    let ratingCount: Int?
    let vicinity: String?
    let address: String?
    var openHours: OpenHours?
    var geometry: Geometry?
    var photos: [Photo]?
    
    enum CodingKeys: String, CodingKey {
        case name
        case priceLevel = "price_level"
        case rating
        case ratingCount = "user_ratings_total"
        case vicinity
        case address = "formatted_address"
        case openHours = "opening_hours"
        case geometry
        case photos
    }
}

struct PlacesResponse: Codable {
    var results: [Restaurant]
    var status: String
}

struct Geometry: Codable  {
    var location: Location
}

struct Location: Codable  {
    var lat: Double
    var lng: Double
}

struct Photo: Codable {
    var height: Double
    var width: Double
    var photoReference: String
    
    enum CodingKeys: String, CodingKey {
        case height
        case width
        case photoReference = "photo_reference"
    }
}

struct OpenHours: Codable {
    var isOpen: Bool?
    
    enum CodingKeys: String, CodingKey {
        case isOpen = "open_now"
    }
}

extension Restaurant {
    var formattedPrice: String {
        return String(repeating: "$", count: priceLevel ?? 0)
    }
}
