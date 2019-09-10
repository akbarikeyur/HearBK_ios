//
//  LoginVC.swift
//  HearBK
//
//  Created by PC on 28/01/19.
//  Copyright © 2019 PC. All rights reserved.
//

import UIKit

class LoginVC: UIViewController, UITextFieldDelegate {

    @IBOutlet var emailTxt: TextField!
    @IBOutlet var passwordTxt: TextField!
    @IBOutlet var checkMarkBtn: UIButton!
    
    var screenType : Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if let userDict = getLoginUserParameter() {
            emailTxt.text = userDict["email"] as? String
            passwordTxt.text = userDict["password"] as? String
        }
        
    }
    
    @IBAction func clickToBack(_ sender: Any) {
        self.view.endEditing(true)
        self.navigationController?.popViewController(animated: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if tabBarController != nil
        {
            let tabBar : CustomTabBarController = self.tabBarController as! CustomTabBarController
            tabBar.setTabBarHidden(tabBarHidden: true)
        }
    }
    
    @IBAction func clickToLogin(_ sender: Any) {
        self.view.endEditing(true)
        if emailTxt.text?.trimmed.count == 0
        {
            displayToast(NSLocalizedString("enter_email", comment: ""))
        }
        else if passwordTxt.text?.count == 0
        {
            displayToast(NSLocalizedString("enter_password", comment: ""))
        }
        else {
            AppModel.shared.currentUser = UserModel.init()
            AppModel.shared.currentUser.email = emailTxt.text
            AppModel.shared.currentUser.password = passwordTxt.text
            
            APIManager.shared.serviceCallToLogin(false) {
                
                if self.checkMarkBtn.isSelected
                {
                    var dict : [String : Any] = [String : Any]()
                    dict["email"] = self.emailTxt.text
                    dict["password"] = self.passwordTxt.text
                    setLoginUserParameter(dict)
                }
                setIsUserLogin(isUserLogin: true)
                if self.screenType == 0
                {
                    AppDelegate().sharedDelegate().navigateToDashBoard()
                }
                else if self.screenType == 1
                {
                    AppDelegate().sharedDelegate().getAllRequiredDataAfterLogin()
                    self.navigationController?.popViewController(animated: true)
                }
            }
        }
    }
    
    @IBAction func clickToCheckMark(_ sender: Any) {
        self.view.endEditing(true)
        if emailTxt.text?.trimmed.count == 0
        {
            displayToast(NSLocalizedString("enter_email", comment: ""))
        }
        else if passwordTxt.text?.count == 0
        {
            displayToast(NSLocalizedString("enter_password", comment: ""))
        }
        else {
            checkMarkBtn.isSelected = !checkMarkBtn.isSelected
            
        }
    }
    
    @IBAction func clickToFacebookBtn(_ sender: Any) {
        self.view.endEditing(true)
        AppDelegate().sharedDelegate().loginWithFacebook()
    }
    
    @IBAction func clickToForgotPassword(_ sender: Any) {
        self.view.endEditing(true)
        let vc : ForgotPasswordVC = STORYBOARD.MAIN.instantiateViewController(withIdentifier: "ForgotPasswordVC") as! ForgotPasswordVC
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
    //MARK: - TextField Delegate
    /**
     * Return cursor one by one from top to bottom for user to allow enter data
     *
     * @param
     */
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        if textField == emailTxt
        {
            passwordTxt.becomeFirstResponder()
        }
        else if textField == passwordTxt
        {
            passwordTxt.resignFirstResponder()
        }
        return true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}
