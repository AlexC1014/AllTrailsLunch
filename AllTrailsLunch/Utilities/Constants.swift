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
        
        static let scheme = "https"
        static let host = "maps.googleapis.com"
        static let nearbyPath = "/maps/api/place/nearbysearch/json"
        static let searchPath = "/maps/api/place/textsearch/json"
        static let imagePath = "/maps/api/place/photo"
        static let photoURL = "https://maps.googleapis.com/maps/api/place/photo?maxwidth=1000&photo_reference=photo_reference&key=YOUR_API_KEY"
        static let maxWidthString = "maxwidth"
        static let maxWidthValue = "1000"
        static let photoReferenceString = "photo_reference"
        static let keyString = "key"
    }
    
    struct Strings {
        static let titleBold = "AllTrails"
        static let titleGray = " at Lunch"
        static let errorTitle = "An error occured"
        static let errorMessage = "Please try again"
        static let alertRetryButton = "Retry"
        static let mapButtongString = "Map"
        static let listButtonString = "List"
        static let searchPlaceHolder = "Restaurants"
    }
    
    struct Values {
        static let mapRadius = 2500.0
        static let minimumHalfStarRating = 0.25
    }
}
