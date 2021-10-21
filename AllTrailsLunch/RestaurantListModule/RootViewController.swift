//
//  RootViewController.swift
//  AllTrailsLunch
//
//  Created by Alex Carroll on 10/18/21.
//

import MapKit
import UIKit

class RootViewController: UIViewController {
    
    enum ViewState {
        case list
        case map
        
        mutating func toggle() {
            switch self {
            case .list:
                self = .map
            case .map:
                self = .list
            }
        }
    }
    
    let viewModel: RestaurantListViewModel = RestaurantListViewModel()
    let locationManager = CLLocationManager()
    var viewState: ViewState = .list
    var activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView()
    var mainChildVC: ChildViewController?
    
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var toggleViewButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //FIXME: Set title view
        self.title = "All Trails Lunch"
        
        bindViewModel()
        addChildVC(RestaurantListViewController(delegate: self))
        
        // Handle locations
        locationManager.delegate = self
        
        toggleViewButton.addTarget(self, action: #selector(toggleView), for: .touchUpInside)
        toggleViewButton.layer.cornerRadius = 8
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if locationManager.authorizationStatus == .authorizedWhenInUse {
            locationManager.startUpdatingLocation()
        } else {
            locationManager.requestWhenInUseAuthorization()
        }
    }
    
    fileprivate func bindViewModel() {
        viewModel.showLoading = { [weak self] in
            guard let self = self else {return}
            self.containerView.alpha = 0
            self.activityIndicator = UIActivityIndicatorView()
            self.activityIndicator.center = self.view.center
            self.activityIndicator.style = .large
            self.view.addSubview(self.activityIndicator)
            self.activityIndicator.startAnimating()
        }
        
        viewModel.hideLoading = { [weak self] in
            self?.containerView.alpha = 1
            guard let self = self else {return}
            self.activityIndicator.hidesWhenStopped = true
            self.activityIndicator.stopAnimating()
        }
        
        viewModel.showError = { [weak self] title, message in
            guard let self = self else {return}
            let alertVC = UIAlertController(title: title, message: message, preferredStyle: .alert)
            let okAction = UIAlertAction(title: Constants.Strings.alertRetryButton, style: .default, handler: nil)
            alertVC.addAction(okAction)
            self.present(alertVC, animated: true, completion: nil)
        }
        
        viewModel.showEmpty = { [weak self] in
            
            //Remove child VC and show retry button
            
            //            guard let self = self else {return}
            //            let button = UIButton()
            //            button.setTitle(Constants.retryButtonText, for: .normal)
            //            button.setTitleColor(.white, for: .normal)
            //            button.addTarget(self, action: #selector(self.handleRetryButtonTapped), for: .touchUpInside)
            //            self.tableView.backgroundView = button
            //            self.tableView.backgroundView?.isUserInteractionEnabled = true
        }
        
        viewModel.showRestaurants = { [weak self] in
            self?.mainChildVC?.reloadData()
        }
    }
    
    @objc fileprivate func toggleView() {
        guard let childVC = mainChildVC else {
            return
        }
        
        viewState.toggle()
        removeChildVC(childVC: childVC)
        
        let vc: ChildViewController
        switch viewState {
        case .list:
            vc = RestaurantListViewController(delegate: self)
            if let mapImage = UIImage(named: "ButtonMap") {
                toggleViewButton.setImage(mapImage, for: .normal)
                toggleViewButton.setTitle(Constants.Strings.mapButtongString, for: .normal)
            }
        case .map:
            vc = RestaurantMapViewController(delegate: self, viewModel: viewModel)
            if let listImage = UIImage(named: "ButtonList") {
                toggleViewButton.setImage(listImage, for: .normal)
                toggleViewButton.setTitle(Constants.Strings.listButtonString, for: .normal)
            }
        }
        addChildVC(vc)
    }
    
    
    fileprivate func addChildVC(_ childVC: ChildViewController) {
        addChild(childVC)
        containerView.addSubview(childVC.view)
        childVC.view.frame = containerView.bounds
        childVC.didMove(toParent: self)
        mainChildVC = childVC
        mainChildVC?.reloadData()
    }
    
    func removeChildVC(childVC: UIViewController) {
        childVC.willMove(toParent: nil)
        childVC.view.removeFromSuperview()
        childVC.removeFromParent()
    }
}

extension RootViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "restaurantCell") as? RestaurantTableViewCell else {
            return UITableViewCell()
        }
        let restaurant = viewModel.restaurants[indexPath.row]
        cell.restaurantView.nameLabel.text = restaurant.name
        cell.restaurantView.priceLabel.text = restaurant.formattedPrice
        cell.restaurantView.descriptionLabel.text = restaurant.address
        
        for subview in cell.restaurantView.ratingView.arrangedSubviews {
            cell.restaurantView.ratingView.removeArrangedSubview(subview)
        }
        if let stars = restaurant.rating {
            for _ in 0...Int(stars) {
                let image = UIImage(systemName: "star.fill")?.withTintColor(.systemYellow, renderingMode: .alwaysOriginal)
                cell.restaurantView.ratingView.addArrangedSubview(UIImageView(image: image))
            }
            if viewModel.hasHalfRating(restaurant: restaurant) {
                let image = UIImage(systemName: "star.leadinghalf.fill")?.withTintColor(.systemYellow, renderingMode: .alwaysOriginal)
                cell.restaurantView.ratingView.addArrangedSubview(UIImageView(image: image))
            }
            let starCount = cell.restaurantView.ratingView.arrangedSubviews.count
            if starCount < 5 {
                let grayStars: [UIView] = Array(repeating: UIImageView(image: UIImage(systemName: "star.fill")?.withTintColor(.systemGray, renderingMode: .alwaysOriginal)), count: 5 - starCount)
                for star in grayStars {
                    cell.restaurantView.ratingView.addArrangedSubview(star)
                }
            }
            
        }
        
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
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation is MKUserLocation {
            return nil
        }
        let id = "Identifier"
        var pin: MKPinAnnotationView
        if let dequeuedView = mapView.dequeueReusableAnnotationView(withIdentifier: id) as? MKPinAnnotationView {
            dequeuedView.annotation = annotation
            pin = dequeuedView
        }else{
            pin = MKPinAnnotationView(annotation: annotation, reuseIdentifier: id)
        }
        pin.image = UIImage(named: "staticPin")
        return pin
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        view.image = UIImage(named: "activePin")
    }
    
    func mapView(_ mapView: MKMapView, didDeselect view: MKAnnotationView) {
        view.image = UIImage(named: "selectedPin")
    }
}

extension RootViewController: CLLocationManagerDelegate {
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        if manager.authorizationStatus == .authorizedWhenInUse {
            manager.startUpdatingLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let loc = manager.location {
            viewModel.location = loc
            viewModel.loadNearbyRestauants()
            manager.stopUpdatingLocation()
        }
    }
}

protocol ChildViewController: UIViewController {
    func reloadData()
}
