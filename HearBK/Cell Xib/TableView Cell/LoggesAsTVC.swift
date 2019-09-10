//
//  LoggesAsTVC.swift
//  HearBK
//
//  Created by PC on 02/02/19.
//  Copyright © 2019 PC. All rights reserved.
//

import UIKit

class LoggesAsTVC: UITableViewCell {

    @IBOutlet weak var profileBtn: Button!
    @IBOutlet weak var nameLbl: Label!
    @IBOutlet weak var emailLbl: Label!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
