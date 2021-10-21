//
//  RestaurantView.swift
//  AllTrailsLunch
//
//  Created by Alex Carroll on 10/19/21.
//

import Foundation
import UIKit

class RestaurantView: UIView {
    
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var ratingView: UIStackView!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var interpunctLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    var restaurant: Restaurant?
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        sharedInit()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        sharedInit()
    }
    
    func sharedInit() {
        guard let view = loadViewFromNib() else { return }
        view.frame = self.bounds
        self.addSubview(view)
        self.interpunctLabel.isAccessibilityElement = false
        nameLabel.font = UIFont.boldSystemFont(ofSize: 14)
        priceLabel.font = UIFont.systemFont(ofSize: 12)
        interpunctLabel.font = UIFont.boldSystemFont(ofSize: 12)
        descriptionLabel.font = UIFont.systemFont(ofSize: 12)
        
        nameLabel.textColor = .secondaryLabel
        priceLabel.textColor = .tertiaryLabel
        interpunctLabel.textColor = .tertiaryLabel
        descriptionLabel.textColor = .tertiaryLabel
    }
    
    func loadViewFromNib() -> UIView? {
        let nib = UINib(nibName: "RestaurantView", bundle: nil)
        return nib.instantiate(withOwner: self, options: nil).first as? UIView
    }
    
    func configure(for restaurant: Restaurant, hasHalfRating: Bool) {
        self.restaurant = restaurant
        nameLabel.text = restaurant.name
        priceLabel.text = restaurant.formattedPrice
        if let isOpen = restaurant.openHours?.isOpen {
            descriptionLabel.text = isOpen ? Constants.Strings.isOpen : Constants.Strings.isNotOpen
        } else {
            descriptionLabel.text = Constants.Strings.unknownHours
        }
        
        nameLabel.sizeToFit()
        
        if restaurant.priceLevel == nil || restaurant.priceLevel == 0 {
            priceLabel.isHidden = true
            interpunctLabel.isHidden = true
        } else {
            priceLabel.isHidden = false
            interpunctLabel.isHidden = false
        }
        
        guard let rating = restaurant.rating else {
            return
        }
        for (index,subview) in ratingView.arrangedSubviews.enumerated() {
            guard let imageView = subview as? UIImageView else {
                continue
            }
            if index < Int(rating) {
                imageView.image = UIImage(systemName: "star.fill")?.withTintColor(.systemYellow, renderingMode: .alwaysOriginal)
            } else if index == Int(rating) && hasHalfRating {
                imageView.image = UIImage(systemName: "star.leadinghalf.fill")?.withTintColor(.systemYellow, renderingMode: .alwaysOriginal)
            } else {
                imageView.image = UIImage(systemName: "star.fill")?.withTintColor(.systemGray, renderingMode: .alwaysOriginal)
            }
        }
        
    }
}
