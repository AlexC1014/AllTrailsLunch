//
//  RestaurantMapViewController.swift
//  AllTrailsLunch
//
//  Created by Alex Carroll on 10/19/21.
//

import Foundation
import MapKit
import UIKit

class RestaurantMapViewController: UIViewController {
    
    let mapView: MKMapView
    
    init() {
        mapView = MKMapView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.frame = self.view.bounds
    }
}
