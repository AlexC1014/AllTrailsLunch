//
//  RootViewController.swift
//  AllTrailsLunch
//
//  Created by Alex Carroll on 10/18/21.
//

import MapKit
import UIKit

class RootViewController: UIViewController {

    let viewModel: RestaurantListViewModel = RestaurantListViewModel()
    override func viewDidLoad() {
        super.viewDidLoad()
        // TODO: Set title view
        
        bindViewModel()
        //viewModel.loadNearbyRestauants()
        
    }
    
    fileprivate func bindViewModel() {
        viewModel.showLoading = {
            
        }
        
        viewModel.hideLoading = {
            
        }
        
        viewModel.showError = {
            
        }
        
        viewModel.showEmpty = {
            
        }
    }


}


extension RootViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "restaurantCell") as? RestaurantTableViewCell else {
            return UITableViewCell()
        }
        
        let restaurant = viewModel.restaurants[indexPath.row]
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.restaurants.count
    }
}

extension RootViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // TODO: Push VC?
    }
}

extension RootViewController: MKMapViewDelegate {
    
}

