//
//  ReviewTVC.swift
//  HearBK
//
//  Created by PC on 02/02/19.
//  Copyright © 2019 PC. All rights reserved.
//

import UIKit

class ReviewTVC: UITableViewCell {

    @IBOutlet var profilePicBtn: Button!
    @IBOutlet var nameLbl: Label!
    @IBOutlet var descriptionLbl: Label!
    @IBOutlet var rateView: FloatRatingView!
    
    @IBOutlet var rateBackView: UIView!
    @IBOutlet var ratingBackViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet var listnerRateView: FloatRatingView!
    @IBOutlet var serviceRateView: FloatRatingView!
    @IBOutlet var buyAgainRateView: FloatRatingView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
