//
//  ListnerTVC.swift
//  HearBK
//
//  Created by PC on 02/02/19.
//  Copyright © 2019 PC. All rights reserved.
//

import UIKit

class ListnerTVC: UITableViewCell {

    @IBOutlet var profilImgBtn: Button!
    @IBOutlet var nameLbl: Label!
    @IBOutlet var selectbtn: Button!
    @IBOutlet var priceLbl: Label!
    
    @IBOutlet weak var verifyBtn: UIButton!
    
    @IBOutlet var headlineLbl: Label!
    @IBOutlet var descriptionLbl: Label!
    
    @IBOutlet var rateView: FloatRatingView!
    @IBOutlet var rateLbl: Label!
    
    @IBOutlet var FavoriteBtn: UIButton!
    @IBOutlet weak var tagView: TagListView!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
