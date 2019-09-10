//
//  CustomRegisterView.swift
//  HearBK
//
//  Created by PC on 18/02/19.
//  Copyright © 2019 PC. All rights reserved.
//

import UIKit

class CustomRegisterView: UIView {

    @IBOutlet var topLbl: Label!
    
    
    class func instanceFromNib() -> UIView {
        return UINib(nibName: "CustomRegisterView", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! UIView
    }

    
    @IBAction func clickToCreateAccount(_ sender: Any) {
        self.endEditing(true)
        self.removeFromSuperview()
        NotificationCenter.default.post(name: NSNotification.Name.init("REDIRECT_TO_REGISTER"), object: nil)
    }
    
    @IBAction func clickToLogin(_ sender: Any) {
        self.endEditing(true)
        self.removeFromSuperview()
        NotificationCenter.default.post(name: NSNotification.Name.init("REDIRECT_TO_LOGIN"), object: nil)
    }
    
    @IBAction func clickToClose(_ sender: Any) {
        self.removeFromSuperview()
    }
}
