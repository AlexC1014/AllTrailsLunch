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
    
    init(delegate: UITableViewDelegate & UITableViewDataSource) {
        tableView = UITableView()
        tableView.delegate = delegate
        tableView.dataSource = delegate
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(tableView)
        registerTableView()
        tableView.separatorStyle = .none
        tableView.backgroundColor = .clear
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = self.view.bounds
    }
    
    fileprivate func registerTableView() {
        let nib = UINib(nibName: "RestaurantTableViewCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "restaurantCell")
    }
}

extension RestaurantListViewController: ChildViewController {
    func reloadData() {
        self.tableView.reloadData()
    }
}
