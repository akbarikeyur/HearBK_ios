//
//  SearchPeopleTVC.swift
//  HearBK
//
//  Created by PC on 02/02/19.
//  Copyright © 2019 PC. All rights reserved.
//

import UIKit

class SearchPeopleTVC: UITableViewCell {

    @IBOutlet weak var profileBtn: Button!
    @IBOutlet weak var nameLbl: Label!
    @IBOutlet weak var priceLbl: Label!
    @IBOutlet weak var closeBtn: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
