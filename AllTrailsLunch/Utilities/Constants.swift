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
        static let locationString = "location"
        static let radiusString = "radius"
        static let scheme = "https"
        static let host = "maps.googleapis.com"
        static let nearbyPath = "/maps/api/place/nearbysearch/json"
        static let searchPath = "/maps/api/place/textsearch/json"
        static let imagePath = "/maps/api/place/photo"
        static let queryString = "query"
        static let typeString = "type"
        static let typeValue = "restaurant"
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
        static let searchPlaceHolder = "Click icon to search for restaurants"
        static let isOpen = "Open now"
        static let isNotOpen = "Currently closed"
        static let unknownHours = "Hours not known"
    }
    
    struct Values {
        static let mapRadius = 2500.0
        static let minimumHalfStarRating = 0.25
    }
}
