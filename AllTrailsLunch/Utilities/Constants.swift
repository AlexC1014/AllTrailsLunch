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
        static let keyParameter = "key=%@"
    }
    
    struct Strings {
        static let errorTitle = "An error occured"
        static let errorMessage = "Please try again"
        static let alertRetryButton = "Retry"
        static let mapButtongString = "Map"
        static let listButtonString = "List"
    }
    
    struct Values {
        static let mapRadius = 2500.0
        static let minimumHalfStarRating = 0.25
    }
}
