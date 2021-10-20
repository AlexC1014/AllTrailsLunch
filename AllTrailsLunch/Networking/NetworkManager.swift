//
//  NetworkManager.swift
//  AllTrailsLunch
//
//  Created by Alex Carroll on 10/19/21.
//

import Foundation

enum NetworkError: Error {
    case invalidURL
    case noData
    case errorResponse(Error?)
    case errorDecoding(Error?)
}

class NetworkManager {
    static let shared = NetworkManager()
    
    func request<R: Request>(_ request: R, completion: @escaping (Result<R.Response, Error>) -> Void) {
        
        guard let url = URL(string: request.fullURL) else {
            completion(.failure(NetworkError.invalidURL))
            return
        }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = request.method.rawValue
        URLSession.shared.dataTask(with: urlRequest) { data, response, err in
            guard err == nil else {
                completion(.failure(NetworkError.errorResponse(err)))
                return
            }
            
            guard let responseData = data else {
                completion(.failure(NetworkError.noData))
                return
            }
            
            do {
                let response = try request.decode(data: responseData)
                completion(.success(response))
            } catch {
                completion(.failure(NetworkError.errorDecoding(error)))
            }
        }.resume()
    }
}

