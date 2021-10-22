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
    
    enum LoadingState {
        case none
        case loading
        case loaded
    }
    
    let viewModel: RestaurantListViewModel = RestaurantListViewModel()
    let locationManager = CLLocationManager()
    var viewState: ViewState = .list
    var loadingState: LoadingState = .none
    var activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView()
    var mainChildVC: ChildViewController?
    let searchController = UISearchController()
    
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var toggleViewButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.titleView = getTitleView()
        self.containerView.backgroundColor = .systemGroupedBackground
        
        bindViewModel()
        addChildVC(RestaurantListViewController(delegate: self))
        
        toggleViewButton.addTarget(self, action: #selector(toggleView), for: .touchUpInside)
        toggleViewButton.layer.cornerRadius = 8
        toggleViewButton.layer.shadowColor = UIColor.label.cgColor
        toggleViewButton.layer.shadowOpacity = 0.1
        toggleViewButton.layer.shadowRadius = 4
        addSearchBar()
        
        locationManager.delegate = self
        if locationManager.authorizationStatus == .authorizedWhenInUse {
            locationManager.startUpdatingLocation()
        } else {
            locationManager.requestWhenInUseAuthorization()
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        searchController.searchBar.searchTextField.rightViewMode = .always
    }
    
    fileprivate func bindViewModel() {
        
        viewModel.showLoading = { [weak self] in
            guard let self = self else {return}
            self.loadingState = .loading
            self.containerView.alpha = 0
            self.activityIndicator = UIActivityIndicatorView()
            self.activityIndicator.center = self.view.center
            self.activityIndicator.style = .large
            self.view.addSubview(self.activityIndicator)
            self.activityIndicator.startAnimating()
        }
        
        viewModel.hideLoading = { [weak self] in
            guard let self = self else {return}
            self.loadingState = .loaded
            self.containerView.alpha = 1
            self.activityIndicator.hidesWhenStopped = true
            self.activityIndicator.stopAnimating()
        }
        
        viewModel.showError = { [weak self] title, message in
            guard let self = self else {return}
            let alertVC = UIAlertController(title: title, message: message, preferredStyle: .alert)
            let okAction = UIAlertAction(title: Constants.Strings.alertRetryButton, style: .default, handler: nil)
            alertVC.addAction(okAction)
            self.present(alertVC, animated: true) { [weak self] in
                self?.viewModel.loadNearbyRestauants()
            }
        }
        viewModel.showRestaurants = { [weak self] in
            self?.mainChildVC?.reloadData()
        }
    }
    
    @objc fileprivate func toggleView() {
        guard let childVC = mainChildVC else {
            return
        }
        guard loadingState != .loading else {
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
    
    fileprivate func addSearchBar() {
        searchController.searchBar.placeholder = Constants.Strings.searchPlaceHolder
        searchController.searchBar.searchTextField.leftView = nil
        let rightTextFieldButton = UIButton()
        rightTextFieldButton.setImage(UIImage(named: "Search Icon"), for: .normal)
        rightTextFieldButton.addTarget(self, action: #selector(didSearch), for: .touchUpInside)
        searchController.searchBar.searchTextField.rightView = rightTextFieldButton
        searchController.searchBar.searchTextField.rightViewMode = .always
        searchController.searchBar.setNeedsLayout()
        navigationItem.hidesSearchBarWhenScrolling = false
        self.navigationItem.searchController = searchController
    }
    
    @objc fileprivate func didSearch() {
        if let text = searchController.searchBar.text {
            viewModel.loadRestaurants(for: text)
        }
    }
    
    @objc fileprivate func didTapAnnotation(sender: UIGestureRecognizer) {
        guard let restaurant = (sender.view as? RestaurantView)?.restaurant else { return }
        performSegue(withIdentifier: "detailSegue", sender: restaurant)
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "detailSegue", let detailVC = segue.destination as? DetailViewController, let restaurant = sender as? Restaurant {
            detailVC.viewModel = self.viewModel
            detailVC.restaurant = restaurant
        }
    }
}

//MARK: TableView and MkMapView data source/delegates for child view controllers

extension RootViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "restaurantCell") as? RestaurantTableViewCell else {
            return UITableViewCell()
        }
        let restaurant = viewModel.restaurants[indexPath.row]
        cell.restaurantView.configure(for: restaurant, hasHalfRating: viewModel.hasHalfRating(restaurant: restaurant))
        cell.selectionStyle = .none
        viewModel.loadRestarauntImage(for: restaurant) { image in
            if let referenceCell = tableView.cellForRow(at: indexPath) as? RestaurantTableViewCell {
                referenceCell.restaurantView.imageView.image = image
            }
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.restaurants.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}

extension RootViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "detailSegue", sender: viewModel.restaurants[indexPath.row])
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
        pin.canShowCallout = true
        if let restAnnotation = annotation as? RestaurantAnnotation {
            let restaurant = restAnnotation.restaurant
            let customCalloutView: RestaurantView? = RestaurantView(frame: CGRect(x: 0, y: 0, width: 40, height: 20))
            customCalloutView?.configure(for: restaurant, hasHalfRating: viewModel.hasHalfRating(restaurant: restaurant))
            viewModel.loadRestarauntImage(for: restaurant) { image in
                customCalloutView?.imageView.image = image
            }
            let tap = UITapGestureRecognizer(target: self, action: #selector(didTapAnnotation))
            customCalloutView?.addGestureRecognizer(tap)
            pin.detailCalloutAccessoryView = customCalloutView
        }
        return pin
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        view.image = UIImage(named: "activePin")
    }
    
    func mapView(_ mapView: MKMapView, didDeselect view: MKAnnotationView) {
        view.image = UIImage(named: "selectedPin")
    }
    
    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        let center = mapView.centerCoordinate
        viewModel.location = CLLocation(latitude: center.latitude, longitude: center.longitude)
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
            if loadingState != .loading {
                viewModel.loadNearbyRestauants()
            }
            manager.stopUpdatingLocation()
        }
    }
}

//MARK: Behavior driving protocols and functionality adding extensions

protocol ChildViewController: UIViewController {
    func reloadData()
}

extension UIViewController {
    func getTitleView() -> UIView {
        let imageView = UIImageView(image: UIImage(named:"Logo"))
        let titleLabel = UILabel()
        
        let boldTitle = Constants.Strings.titleBold
        let boldAttrs: [NSAttributedString.Key : Any] = [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 22),
                                                         NSAttributedString.Key.foregroundColor: UIColor(named: "BoldTitleGray") ?? .darkGray]
        let boldString = NSAttributedString(string: boldTitle, attributes: boldAttrs )
        
        let grayTitle = Constants.Strings.titleGray
        let grayAttrs: [NSAttributedString.Key : Any] = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 22, weight: .semibold),
                                                         NSAttributedString.Key.foregroundColor: UIColor(named: "LightTitleGray") ?? .systemGray4]
        let grayString = NSAttributedString(string: grayTitle, attributes: grayAttrs)
        
        let titleString = NSMutableAttributedString(attributedString: boldString)
        titleString.append(grayString)
        titleLabel.attributedText = titleString
        
        let stack = UIStackView(arrangedSubviews: [imageView, titleLabel])
        stack.axis = .horizontal
        return stack
    }
}
