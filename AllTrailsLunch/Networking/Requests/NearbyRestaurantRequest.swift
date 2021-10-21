//
//  NearbySearchRequest.swift
//  AllTrailsLunch
//
//  Created by Alex Carroll on 10/19/21.
//

import CoreLocation
import Foundation

protocol PlacesRequest: Request {}

class NearbyRestaurantRequest: PlacesRequest {
    typealias Response = [Restaurant]
    
    var location: CLLocation
    
    var path: String = Constants.Networking.nearbySearchPath
    var method: HTTPMethod = .GET
    var fullURL: String {
        return "\(self.baseURL)\(self.path)?\(String(format: Constants.Networking.locationPamater, location.coordinate.latitude, location.coordinate.longitude))&\(Constants.Networking.restaurantTypeParameter)&\(String(format: Constants.Networking.radiusParameter, 1500))&\(String(format: Constants.Networking.keyParameter, apiKey))"
    }
    var apiKey: String = ""
    
    init(location: CLLocation) {
        self.location = location
        if let key = Bundle.main.infoDictionary?["API_KEY"] as? String {
            apiKey = key
        }
    }
    
    func decode(data: Data) throws -> [Restaurant] {
        do {
            let res = try JSONSerialization.jsonObject(with: data, options: []) as? [String : Any]
            print(res)
        } catch {
            //Do nothig
        }
        
        let decoder = JSONDecoder()
        let response = try decoder.decode(PlacesResponse.self, from: data)
        return response.results
    }
}
