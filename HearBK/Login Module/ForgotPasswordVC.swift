//
//  ForgotPasswordVC.swift
//  HearBK
//
//  Created by Keyur on 16/11/18.
//  Copyright © 2018 PC. All rights reserved.
//

import UIKit

class ForgotPasswordVC: UIViewController {

    @IBOutlet weak var emailTxt: TextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func clickToBack(_ sender: Any) {
        self.view.endEditing(true)
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func clickToSubmit(_ sender: Any) {
        self.view.endEditing(true)
        if emailTxt.text?.trimmed.count == 0
        {
            displayToast(NSLocalizedString("enter_email", comment: ""))
        }
        else if emailTxt.text?.isValidEmail == false
        {
            displayToast(NSLocalizedString("invalid_email", comment: ""))
        }
        else
        {
            var param : [String : Any] = [String : Any]()
            param["email"] = emailTxt.text
            APIManager.shared.serviceCallToForgotPassword(param) {
                displayToast("We have e-mailed you code!")
                let vc : ResetPasswordVC = STORYBOARD.MAIN.instantiateViewController(withIdentifier: "ResetPasswordVC") as! ResetPasswordVC
                vc.email = self.emailTxt.text!
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
    }
 
}
