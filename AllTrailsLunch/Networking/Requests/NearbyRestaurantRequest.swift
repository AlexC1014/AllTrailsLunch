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
    
    var path: String = Constants.Networking.nearbySearchPath
    var method: HTTPMethod = .GET
    var wrapper: String?
    var fullURL: String
    
    init(location: CLLocation) {
        self.fullURL = "\(self.baseURL)\(self.path)?\(String(format: Constants.Networking.locationPamater, location.coordinate.latitude, location.coordinate.latitude))&\(Constants.Networking.restaurantTypeParameter)&\(String(format: Constants.Networking.radiusParameter, 1500))"
    }
    
    func decode(data: Data) throws -> [Restaurant] {
        <#code#>
    }
    
    
    
}
