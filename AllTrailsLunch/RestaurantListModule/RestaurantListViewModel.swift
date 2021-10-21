//
//  RestaurantListViewModel.swift
//  AllTrailsLunch
//
//  Created by Alex Carroll on 10/19/21.
//

import CoreLocation
import Foundation
import UIKit

protocol RestaurantListViewModelProtocol {
    func loadNearbyRestauants()
    func loadRestaurants(for search: String)
    func hasHalfRating(restaurant: Restaurant) -> Bool
    func loadRestarauntImage(for restaurant: Restaurant, completion: @escaping (UIImage?) -> Void)
    
    var restaurants: [Restaurant] { get }
    var location: CLLocation { get set }
    var showRestaurants: (() -> Void)? { get set }
    var showError: ((String, String) -> Void)? { get set }
    var showLoading: (() -> Void)? { get set }
    var hideLoading: (() -> Void)? { get set }
}

class RestaurantListViewModel: RestaurantListViewModelProtocol {
    
    var restaurants: [Restaurant] = []
    var location: CLLocation = CLLocation()
    
    var showRestaurants: (() -> Void)?
    var showError: ((String, String) -> Void)?
    var showLoading: (() -> Void)?
    var hideLoading: (() -> Void)?
    
    func loadNearbyRestauants() {
        showLoading?()
        restaurants = []
        let request = NearbyRestaurantRequest(location: location)
        NetworkManager.shared.request(request) { [weak self] result in
            guard let self = self else {return}
            self.handleRestaurantResponse(result: result)
        }
    }
    
    func loadRestaurants(for search: String) {
        showLoading?()
        restaurants = []
        let request = SearchRequest(search: search, location: location)
        NetworkManager.shared.request(request) { [weak self] result in
            guard let self = self else {return}
            self.handleRestaurantResponse(result: result)
        }
    }
    
    private func handleRestaurantResponse(result: Result<[Restaurant], Error>) {
        self.hideLoading?()
        switch result {
        case .failure(_):
            self.showError?(Constants.Strings.errorTitle, Constants.Strings.errorMessage)
        case .success(let places):
            self.restaurants = places
            self.showRestaurants?()
        }
    }
    
    func loadRestarauntImage(for restaurant: Restaurant, completion: @escaping (UIImage?) -> Void) {
        guard let ref = restaurant.photos?.first?.photoReference else {
            completion(nil)
            return
        }
        NetworkManager.shared.downloadImage(reference: ref) { result in
            DispatchQueue.main.async {
                switch result {
                case .failure(_):
                    completion(nil)
                case .success(let image):
                    completion(image)
                }
            }

        }
    }
    
    func hasHalfRating(restaurant: Restaurant) -> Bool {
        guard let rating = restaurant.rating else { return false }
        return rating.truncatingRemainder(dividingBy: 1) >= Constants.Values.minimumHalfStarRating
    }
}
