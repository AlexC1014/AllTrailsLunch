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
    let address: String?
    var geometry: Geometry?
    var photos: [Photo]?
    //let imageURL: String?
    //let image: UIImage? = nil
    
    enum CodingKeys: String, CodingKey {
        case name
        case priceLevel = "price_level"
        case rating
        case ratingCount = "user_ratings_total"
        case address = "vicinity"
        case geometry
        case photos
        //case imageURL
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

extension Restaurant {
    var formattedPrice: String {
        return String(repeating: "$", count: priceLevel ?? 0)
    }
}
