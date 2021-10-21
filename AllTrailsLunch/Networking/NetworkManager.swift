//
//  NetworkManager.swift
//  AllTrailsLunch
//
//  Created by Alex Carroll on 10/19/21.
//

import UIKit
import Foundation

fileprivate let imageCache = NSCache<AnyObject, UIImage>()

enum NetworkError: Error {
    case invalidURL
    case noData
    case errorResponse(Error?)
    case errorDecoding(Error?)
}

class NetworkManager {
    static let shared = NetworkManager()
    
    func request<R: Request>(_ request: R, completion: @escaping (Result<R.Response, Error>) -> Void) {
        
        var components = URLComponents()
        components.scheme = request.scheme
        components.host = request.host
        components.path = request.path
        components.queryItems = request.queryItems
        components.queryItems?.append(URLQueryItem(name: Constants.Networking.keyString, value: Bundle.main.infoDictionary?["API_KEY"] as? String))
        
        guard let url = components.url else {
            completion(.failure(NetworkError.invalidURL))
            return
        }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = request.method.rawValue
        URLSession.shared.dataTask(with: urlRequest) { data, response, err in
            DispatchQueue.main.async {
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
                    print(error)
                    completion(.failure(NetworkError.errorDecoding(error)))
                }
            }
        }.resume()
    }
    
    func downloadImage(reference: String, completion: @escaping (Result<UIImage, Error>) -> Void) {
        if let cachedImage = imageCache.object(forKey: reference as AnyObject) {
            completion(.success(cachedImage))
            return
        }
        
        var components = URLComponents()
        components.queryItems = [
            URLQueryItem(name: Constants.Networking.maxWidthString, value: Constants.Networking.maxWidthValue),
            URLQueryItem(name: Constants.Networking.photoReferenceString, value: reference),
            URLQueryItem(name: Constants.Networking.keyString, value: Bundle.main.infoDictionary?["API_KEY"] as? String ?? "")]
        components.scheme = Constants.Networking.scheme
        components.host = Constants.Networking.host
        components.path = Constants.Networking.imagePath
        
        guard let url = components.url else {
            completion(.failure(NetworkError.invalidURL))
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, err in
            guard err == nil else {
                completion(.failure(NetworkError.errorResponse(err)))
                return
            }
            
            guard let imageData = data else {
                completion(.failure(NetworkError.noData))
                return
            }
            
            if let image = UIImage(data: imageData) {
                completion(.success(image))
                imageCache.setObject(image, forKey: reference as AnyObject)
            }
        }.resume()
    }
}

