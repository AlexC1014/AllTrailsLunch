//
//  RestaurantListViewModel.swift
//  AllTrailsLunch
//
//  Created by Alex Carroll on 10/19/21.
//

import CoreLocation
import Foundation

protocol RestaurantListViewModelProtocol {
    func loadNearbyRestauants()
    func loadRestaurants(for search: String)
    
    var restaurants: [Restaurant] { get }
    var showRestaurants: (() -> Void)? { get set }
    var showEmpty: (() -> Void)? { get set }
    var showLoading: (() -> Void)? { get set }
    var hideLoading: (() -> Void)? { get set }
}

class RestaurantListViewModel: RestaurantListViewModelProtocol {
    
    var restaurants: [Restaurant] = []
    
    var showRestaurants: (() -> Void)?
    var showEmpty: (() -> Void)?
    var showError: (() -> Void)?
    var showLoading: (() -> Void)?
    var hideLoading: (() -> Void)?
    
    func loadNearbyRestauants() {
        guard let location = CLLocationManager().location else {
            showEmpty?()
        }
        
        let request = NearbyRestaurantRequest(location: location)
        NetworkManager.shared.request(request) { [weak self] result in
            switch result {
            case .failure(_):
                self?.showError?()
            case .success(let places):
                self?.restaurants = places
                if places.isEmpty {
                    self?.showEmpty?()
                } else {
                    self?.showRestaurants?()
                }
            }
        }
    }
    
    func loadRestaurants(for search: String) {
        <#code#>
    }
    
    
}
