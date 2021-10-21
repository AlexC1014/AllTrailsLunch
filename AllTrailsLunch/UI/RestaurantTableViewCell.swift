//
//  RestarauntTableViewCell.swift
//  AllTrailsLunch
//
//  Created by Alex Carroll on 10/18/21.
//

import Foundation
import UIKit

class RestaurantTableViewCell: UITableViewCell {
    
    @IBOutlet weak var favoriteIcon: UIImageView!
    @IBOutlet weak var restaurantView: RestaurantView!
    @IBOutlet weak var containerView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        containerView.layer.borderWidth = 1.0
        containerView.layer.borderColor = UIColor.systemGray4.cgColor
        containerView.layer.cornerRadius = 10
    }
    
}
