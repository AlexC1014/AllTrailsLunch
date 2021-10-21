//
//  RestaurantMapViewController.swift
//  AllTrailsLunch
//
//  Created by Alex Carroll on 10/19/21.
//

import CoreLocation
import Foundation
import MapKit
import UIKit

class RestaurantMapViewController: UIViewController {
    
    let mapView: MKMapView
    
    init(delegate: MKMapViewDelegate) {
        mapView = MKMapView()
        mapView.delegate = delegate
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addSubview(mapView)
        let coord = CLLocationManager().location?.coordinate ?? CLLocationCoordinate2D(latitude: 0, longitude: 0)
        let coordinateRegion = MKCoordinateRegion(center: coord, latitudinalMeters: Constants.Values.mapRadius, longitudinalMeters: Constants.Values.mapRadius)
        mapView.setRegion(coordinateRegion, animated: false)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        mapView.frame = self.view.bounds
    }
}

extension RestaurantMapViewController: ChildViewController {
    func reloadData(restauants: [Restaurant]) {
        // Handle new restaurants
    }
}
