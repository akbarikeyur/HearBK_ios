//
//  TrackTVC.swift
//  HearBK
//
//  Created by PC on 02/02/19.
//  Copyright © 2019 PC. All rights reserved.
//

import UIKit

class TrackTVC: UITableViewCell {

    @IBOutlet var nameLbl: Label!
    @IBOutlet var dateLbl: Label!
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
