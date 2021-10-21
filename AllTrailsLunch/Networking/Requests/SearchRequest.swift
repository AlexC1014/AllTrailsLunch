//
//  SearchRequest.swift
//  AllTrailsLunch
//
//  Created by Alex Carroll on 10/20/21.
//

import CoreLocation
import Foundation

class SearchRequest: Request {
    typealias Response = [Restaurant]
    
    var scheme: String = Constants.Networking.scheme
    var host: String = Constants.Networking.host
    var queryItems: [URLQueryItem]
    var path: String = Constants.Networking.searchPath
    var method: HTTPMethod = .GET
    
    init(search: String, location: CLLocation) {
        self.queryItems = [URLQueryItem(name: Constants.Networking.queryString, value: search), URLQueryItem(name: Constants.Networking.locationString, value: "\(location.coordinate.latitude), \(location.coordinate.longitude)"),URLQueryItem(name: Constants.Networking.typeString, value: Constants.Networking.typeValue), URLQueryItem(name: Constants.Networking.radiusString, value: "\(Constants.Values.mapRadius)")]
    }
    
    func decode(data: Data) throws -> [Restaurant] {
        let decoder = JSONDecoder()
        let response = try decoder.decode(PlacesResponse.self, from: data)
        return response.results
    }
}
