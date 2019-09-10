//
//  CustomFavoriteTVC.swift
//  HearBK
//
//  Created by Keyur on 09/02/19.
//  Copyright © 2019 PC. All rights reserved.
//

import UIKit

class CustomFavoriteTVC: UITableViewCell {

    @IBOutlet weak var profilePicBtn: Button!
    @IBOutlet weak var titleLbl: Label!
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
