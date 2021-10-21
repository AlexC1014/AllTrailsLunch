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
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    func commonInit() {
        guard let view = loadViewFromNib() else { return }
        view.frame = self.bounds
        self.addSubview(view)
        //self.interpunctLabel.isAccessibilityElement = false
        //titleLabel.font = UIFont.systemFont(ofSize: <#T##CGFloat#>)
    }
    
    func loadViewFromNib() -> UIView? {
        let nib = UINib(nibName: "RestaurantView", bundle: nil)
        return nib.instantiate(withOwner: self, options: nil).first as? UIView
    }
}
