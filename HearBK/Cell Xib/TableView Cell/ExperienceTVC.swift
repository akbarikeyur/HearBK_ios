//
//  ExperienceTVC.swift
//  HearBK
//
//  Created by PC on 31/01/19.
//  Copyright © 2019 PC. All rights reserved.
//

import UIKit

class ExperienceTVC: UITableViewCell {

    @IBOutlet weak var positionLbl: Label!
    @IBOutlet weak var companyNameLbl: Label!
    @IBOutlet weak var dateLbl: Label!
    @IBOutlet var cancelBtn: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
