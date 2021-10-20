//
//  RestaurantListViewController.swift
//  AllTrailsLunch
//
//  Created by Alex Carroll on 10/19/21.
//

import Foundation
import UIKit

class RestaurantListViewController: UIViewController {
    
    let tableView: UITableView
    
    init() {
        tableView = UITableView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.frame = self.view.bounds
    }
}
