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
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
}
