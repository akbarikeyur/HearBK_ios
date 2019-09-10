//
//  SuccessErrorView.swift
//  HearBK
//
//  Created by Keyur on 02/02/19.
//  Copyright © 2019 PC. All rights reserved.
//

import UIKit

class SuccessErrorView: UIView {

    class func instanceFromNib() -> UIView {
        return Bundle.main.loadNibNamed("SuccessErrorView", owner: self, options: nil)![0] as! UIView
    }
    
    @IBAction func clickToDone(_ sender: Any) {
        self.endEditing(true)
        self.removeFromSuperview()
    }
    

}
