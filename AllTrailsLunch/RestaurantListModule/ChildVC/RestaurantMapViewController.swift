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
    let viewModel: RestaurantListViewModel
    
    init(delegate: MKMapViewDelegate, viewModel: RestaurantListViewModel) {
        self.mapView = MKMapView()
        self.mapView.delegate = delegate
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addSubview(mapView)
        let coord = viewModel.location.coordinate
        let coordinateRegion = MKCoordinateRegion(center: coord, latitudinalMeters: Constants.Values.mapRadius, longitudinalMeters: Constants.Values.mapRadius)
        mapView.setRegion(coordinateRegion, animated: false)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        mapView.frame = self.view.bounds
    }
}

extension RestaurantMapViewController: ChildViewController {
    func reloadData() {
        var annotations: [MKPointAnnotation] = []
        for restauant in viewModel.restaurants {
            if let lat = restauant.geometry?.location.lat, let lon = restauant.geometry?.location.lng {
                let annotation = MKPointAnnotation()
                annotation.coordinate = CLLocationCoordinate2D(latitude: lat, longitude: lon)
                annotation.title = restauant.name
                annotations.append(annotation)
            }
        }
        mapView.addAnnotations(annotations)
    }
}
