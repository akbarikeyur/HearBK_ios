//
//  CustomTransactionTVC.swift
//  HearBK
//
//  Created by Keyur on 09/02/19.
//  Copyright © 2019 PC. All rights reserved.
//

import UIKit

class CustomTransactionTVC: UITableViewCell {

    @IBOutlet weak var titleLbl: Label!
    @IBOutlet weak var rateBtn: Button!
    @IBOutlet weak var priceLbl: Label!
    @IBOutlet weak var dateLbl: Label!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
