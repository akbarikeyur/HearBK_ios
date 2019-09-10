//
//  ResetPasswordVC.swift
//  HearBK
//
//  Created by Keyur on 16/11/18.
//  Copyright © 2018 PC. All rights reserved.
//

import UIKit

class ResetPasswordVC: UIViewController {

    @IBOutlet weak var codeTxt: TextField!
    @IBOutlet weak var passwordTxt: TextField!
    @IBOutlet weak var confirmPassword: TextField!
    
    var email : String = ""
    
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
        
        if passwordTxt.text?.count == 0
        {
            displayToast(NSLocalizedString("enter_password", comment: ""))
        }
        else if confirmPassword.text?.count == 0
        {
            displayToast("confirm_password")
        }
        else if (confirmPassword.text != passwordTxt.text)
        {
            displayToast(NSLocalizedString("confirm_password_match", comment: ""))
        }
        else
        {
            var param : [String : Any] = [String : Any]()
            param["email"] = email
            param["password"] = passwordTxt.text
            param["password_confirmation"] = confirmPassword.text
            param["code"] = codeTxt.text
            
            APIManager.shared.serviceCallToResetPassword(param) {
                displayToast("Paswsword changed successfully.")
                AppDelegate().sharedDelegate().navigateToLogin()
            }
        }
    }

}
