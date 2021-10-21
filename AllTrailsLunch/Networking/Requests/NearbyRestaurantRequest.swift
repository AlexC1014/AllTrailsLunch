//
//  NearbySearchRequest.swift
//  AllTrailsLunch
//
//  Created by Alex Carroll on 10/19/21.
//

import CoreLocation
import Foundation

class NearbyRestaurantRequest: Request {
    typealias Response = [Restaurant]
    
    var scheme: String = Constants.Networking.scheme
    var host: String = Constants.Networking.host
    var queryItems: [URLQueryItem]
    var path: String = Constants.Networking.nearbyPath
    var method: HTTPMethod = .GET

    init(location: CLLocation) {
        self.queryItems = [URLQueryItem(name: Constants.Networking.locationString, value: "\(location.coordinate.latitude), \(location.coordinate.longitude)"), URLQueryItem(name: Constants.Networking.radiusString, value: "\(Constants.Values.mapRadius)"), URLQueryItem(name: Constants.Networking.typeString, value: Constants.Networking.typeValue)]
    }
    
    func decode(data: Data) throws -> [Restaurant] {
        let decoder = JSONDecoder()
        let response = try decoder.decode(PlacesResponse.self, from: data)
        return response.results
    }
}
