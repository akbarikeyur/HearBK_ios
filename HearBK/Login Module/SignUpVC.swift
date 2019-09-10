//
//  SignUpVC.swift
//  HearBK
//
//  Created by PC on 28/01/19.
//  Copyright © 2019 PC. All rights reserved.
//

import UIKit
import ActiveLabel

class SignUpVC: UIViewController, UITextFieldDelegate {

    @IBOutlet var nameTxt: TextField!
    @IBOutlet var emailTxt: TextField!
    @IBOutlet var passwordTxt: TextField!
    @IBOutlet var repeatPasswordTxt: TextField!
    @IBOutlet var termsLbl: ActiveLabel!
    @IBOutlet weak var constraintHeightTearmsLbl: NSLayoutConstraint!//50
    
    @IBOutlet var scrollView: UIScrollView!
    
    @IBOutlet var createAccountBtn: Button!
    @IBOutlet weak var constraintHeightCreateAccountBtn: NSLayoutConstraint!//45
    @IBOutlet var nextBtn: Button!
    
    @IBOutlet var backView: UIView!
    
    var type : Int = 0
    var screenType : Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUIDesigning()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if tabBarController != nil
        {
            let tabBar : CustomTabBarController = self.tabBarController as! CustomTabBarController
            tabBar.setTabBarHidden(tabBarHidden: true)
        }
    }
    
    func setUIDesigning()
    {
        setTearmsConditionLabel()
        if type == 1 {
            termsLbl.isHidden = true
            constraintHeightTearmsLbl.constant = 0
            createAccountBtn.isHidden = false
            constraintHeightCreateAccountBtn.constant = 45
            nextBtn.isHidden = true
        } else {
            termsLbl.isHidden = false
            constraintHeightTearmsLbl.constant = 50
            createAccountBtn.isHidden = true
            constraintHeightCreateAccountBtn.constant = 0
            nextBtn.isHidden = false
        }
    }
    
    func setTearmsConditionLabel()
    {
        let tearmsType = ActiveType.custom(pattern: "\\sTerms of Use, Refund Policy\\b") //Looks for "Terms of Use"
        let privacyType = ActiveType.custom(pattern: "\\sPrivacy Policy\\b") //Looks for "Privacy Policy"
        termsLbl.enabledTypes.append(tearmsType)
        termsLbl.enabledTypes.append(privacyType)
        termsLbl.customize { label in
            termsLbl.text = "By using our application you acknowledge that you’ve reviewed and agree to our Terms of Use, Refund Policy and Privacy Policy."
            termsLbl.numberOfLines = 0
            termsLbl.lineSpacing = 2
            termsLbl.font = UIFont(name: SFUI_MEDIUM, size: 12.0)
            termsLbl.textColor = WhiteColor
            termsLbl.mentionColor = ScreenBackGroundColor
            
            termsLbl.handleMentionTap { self.clickToTeamsPolicy("Mention", message: $0) }
            
            //Custom types
            termsLbl.customColor[tearmsType] = GreenColor
            termsLbl.customColor[privacyType] = GreenColor
            
            termsLbl.handleCustomTap(for: tearmsType) { self.clickToTeamsPolicy("Custom type", message: $0) }
            termsLbl.handleCustomTap(for: privacyType) { self.clickToTeamsPolicy("Custom type", message: $0) }
            
        }
    }
    
    //MARK: - Button click
    @IBAction func clickToBack(_ sender: Any) {
        self.view.endEditing(true)
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func clickToNext(_ sender: Any) {
        self.view.endEditing(true)
        if nameTxt.text?.trimmed.count == 0
        {
            displayToast(NSLocalizedString("enter_name", comment: ""))
        }
        else if emailTxt.text?.trimmed.count == 0
        {
            displayToast(NSLocalizedString("enter_email", comment: ""))
        }
        else if emailTxt.text?.isValidEmail == false
        {
            displayToast(NSLocalizedString("invalid_email", comment: ""))
        }
        else if passwordTxt.text?.count == 0
        {
            displayToast(NSLocalizedString("enter_password", comment: ""))
        }
        else if repeatPasswordTxt.text?.count == 0
        {
            displayToast("confirm_password")
        }
        else if (repeatPasswordTxt.text != passwordTxt.text)
        {
            displayToast(NSLocalizedString("confirm_password_match", comment: ""))
        }
        else
        {
            var param : [String : Any] = [String : Any]()
            param["display_name"] = nameTxt.text
            param["email"] = emailTxt.text
            param["password"] = passwordTxt.text
            param["confirm_password"] = repeatPasswordTxt.text
            
            var isDeviceTokenUpdate : Bool = false
            if AppDelegate().sharedDelegate().deviceToken != ""
            {
                isDeviceTokenUpdate = true
                param["deviceId"] = AppDelegate().sharedDelegate().deviceToken
                param["deviceType"] = "i"
            }
            
            if PLATFORM.isSimulator
            {
                isDeviceTokenUpdate = true
                param["deviceId"] = "0B79A7DA4BF6DA97875B47AB77F196536076641EA0250CC47DF1EA1CC35718CC"
                param["deviceType"] = "i"
            }
            
            APIManager.shared.serviceCallToSignUp(param) {
                if self.type == 1 {
                    AppDelegate().sharedDelegate().navigateToDashBoard()
                }else {
                    let vc : BecomeListenerVC = STORYBOARD.MAIN.instantiateViewController(withIdentifier: "BecomeListenerVC") as! BecomeListenerVC
                    vc.screenType = self.screenType
                    self.navigationController?.pushViewController(vc, animated: true)
                }
            }

        }
        
        
    }
    
    /**
     *
     * User will redirct to terms and condition screen
     *
     * @param
     */
    func clickToTeamsPolicy(_ title: String, message: String) {
        
        if message == "Terms of Use, Refund Policy"
        {
            let vc : TermsAndConditionVC = STORYBOARD.MAIN.instantiateViewController(withIdentifier: "TermsAndConditionVC") as! TermsAndConditionVC
            vc.pdfSelection = "HearBK_Terms_of_Use_"
            self.navigationController?.pushViewController(vc, animated: true)
        }
        else if message == "Privacy Policy"
        {
            let vc : TermsAndConditionVC = STORYBOARD.MAIN.instantiateViewController(withIdentifier: "TermsAndConditionVC") as! TermsAndConditionVC
            vc.pdfSelection = "HearBK_Privacy_Policy"
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    //MARK: - TextField Delegate Method
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        if textField == nameTxt
        {
            emailTxt.becomeFirstResponder()
        }
        else if textField == emailTxt
        {
            passwordTxt.becomeFirstResponder()
        }
        else if textField == passwordTxt
        {
            repeatPasswordTxt.becomeFirstResponder()
        }
        else if textField == repeatPasswordTxt
        {
            repeatPasswordTxt.resignFirstResponder()
        }
        
        return true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
