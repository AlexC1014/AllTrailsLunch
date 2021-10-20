//
//  Constants.swift
//  AllTrailsLunch
//
//  Created by Alex Carroll on 10/19/21.
//

import Foundation

struct Constants {
    struct Networking {
        static let baseURL = "https://maps.googleapis.com/maps/api/place/"
        static let nearbySearchPath = "nearbysearch/json"
        static let restaurantTypeParameter = "type=restaurant"
        static let locationPamater = "location=%f,%f"
        static let radiusParameter = "radius=%d"
    }
}
