//
//  TrackDetailTVC.swift
//  HearBK
//
//  Created by PC on 15/02/19.
//  Copyright © 2019 PC. All rights reserved.
//

import UIKit

class TrackDetailTVC: UITableViewCell {

    @IBOutlet var profileBtnImg: Button!
    @IBOutlet var nameLbl: Label!
    @IBOutlet var descriptionLbl: Label!
    @IBOutlet var rateBtn: Button!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
