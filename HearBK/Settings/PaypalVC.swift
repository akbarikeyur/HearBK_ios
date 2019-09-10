//
//  PaypalVC.swift
//  HearBK
//
//  Created by PC on 12/02/19.
//  Copyright © 2019 PC. All rights reserved.
//

import UIKit

class PaypalVC: UIViewController {

    @IBOutlet var nameTxt: TextField!
    @IBOutlet var emailtxt: TextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        nameTxt.text = AppModel.shared.currentUser.paypal_legal_name
        emailtxt.text = AppModel.shared.currentUser.paypal_email
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if tabBarController != nil
        {
            let tabBar : CustomTabBarController = self.tabBarController as! CustomTabBarController
            tabBar.setTabBarHidden(tabBarHidden: true)
        }
    }
    
    //MARK: - Button click Method
    @IBAction func clickToBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func clickToSubmit(_ sender: Any) {
        self.view.endEditing(true)
        
        if nameTxt.text?.trimmed == ""
        {
            displayToast("Please enter your name.")
        }
        else if emailtxt.text?.trimmed == ""
        {
            displayToast("Please enter your paypal email.")
        }
        else if !(emailtxt.text?.isValidEmail)!
        {
            displayToast("Invalid email.")
        }
        else
        {
            showAlertWithOption("HearBK", message: "We will transfer your wallet amount on this paypal account. Make sure your paypal detail is correct.", btns: ["Continue", "Cancel"], completionConfirm: {
                var param : [String : Any] = [String : Any]()
                param["paypal_legal_name"] = self.nameTxt.text
                param["paypal_email"] = self.emailtxt.text
                APIManager.shared.serviceCallToUpdateUserPaypalDetail(param, {
                    AppModel.shared.currentUser.paypal_email = self.emailtxt.text
                    AppModel.shared.currentUser.paypal_legal_name = self.nameTxt.text
                    setLoginUserData(AppModel.shared.currentUser.dictionary())
                    displayToast("Your paypal information updated successfully.")
                    self.navigationController?.popViewController(animated: true)
                })
            }) {
                
            }
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
}
