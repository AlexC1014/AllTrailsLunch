//
//  DetailViewController.swift
//  AllTrailsLunch
//
//  Created by Alex Carroll on 10/21/21.
//

import Foundation
import UIKit

class DetailViewController: UIViewController {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    
    var viewModel: RestaurantListViewModel?
    var restaurant: Restaurant?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.titleView = getTitleView()
        if let location = restaurant {
            viewModel?.loadRestarauntImage(for: location, completion: { [weak self] image in
                self?.imageView.image = image
            })
            nameLabel.text = location.name
            addressLabel.text = location.address ?? location.vicinity
        }
        
    }
}
