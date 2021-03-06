//
//  Request.swift
//  AllTrailsLunch
//
//  Created by Alex Carroll on 10/19/21.
//

import Foundation

enum HTTPMethod: String {
    case GET
    case POST
    case PUT
    case DELETE
}

protocol Request {
    associatedtype Response
    var scheme: String { get }
    var host: String { get }
    var path: String { get }
    var queryItems: [URLQueryItem] { get }
    var method: HTTPMethod { get }
    
    func decode(data: Data) throws -> Response
}

extension Request {
    var baseURL: String {
        return Constants.Networking.baseURL
    }
}
