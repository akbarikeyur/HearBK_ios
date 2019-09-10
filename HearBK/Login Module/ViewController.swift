//
//  ViewController.swift
//  HearBK
//
//  Created by PC on 28/01/19.
//  Copyright © 2019 PC. All rights reserved.
//

import UIKit
import ActiveLabel

class ViewController: UIViewController {
    
    @IBOutlet var termsLbl: ActiveLabel!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        setTearmsConditionLabel()
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
    
    //MARK: - Button Click
    @IBAction func clickToLogin(_ sender: Any) {
        self.view.endEditing(true)
        let vc : LoginVC = STORYBOARD.MAIN.instantiateViewController(withIdentifier: "LoginVC") as! LoginVC
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func clickToSignUp(_ sender: Any) {
        self.view.endEditing(true)
        let vc : SignUpVC = STORYBOARD.MAIN.instantiateViewController(withIdentifier: "SignUpVC") as! SignUpVC
        vc.type = 1
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func clickToSkip(_ sender: Any) {
        AppDelegate().sharedDelegate().navigateToDashBoard()
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
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

