//
//  CustomCardTVC.swift
//  HearBk
//
//  Created by Keyur on 02/12/18.
//  Copyright © 2018 PC. All rights reserved.
//

import UIKit

class CustomCardTVC: UITableViewCell {

    @IBOutlet weak var checkBtn: UIButton!
    @IBOutlet weak var cardTypeBtn: UIButton!
    @IBOutlet weak var cardNumberLbl: Label!
    @IBOutlet weak var cardNameLbl: Label!
    @IBOutlet weak var expireLbl: Label!
    @IBOutlet weak var deleteCard: UIButton!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
