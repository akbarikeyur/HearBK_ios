//
//  UpgradeVC.swift
//  HearBK
//
//  Created by PC on 08/02/19.
//  Copyright © 2019 PC. All rights reserved.
//

import UIKit

class UpgradeVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        NotificationCenter.default.addObserver(self, selector: #selector(clickToNoThanks(_:)), name: NSNotification.Name.init("REDIRECT_TO_BACK"), object: nil)
        
    }

    override func viewWillAppear(_ animated: Bool) {
        if tabBarController != nil
        {
            let tabBar : CustomTabBarController = self.tabBarController as! CustomTabBarController
            tabBar.setTabBarHidden(tabBarHidden: true)
        }
    }
    
    //MARK: - Button click Method
    @IBAction func clickToNoThanks(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func clickToUpgrade(_ sender: Any) {
        if !isUserLogin() {
            displayToast("In order to upgrade account, please create an account!")
            return
        }
        
        if AppModel.shared.currentUser.account_type == 1 {
            displayToast("You already upgraded a premium account.")
            return
        }
        let view1 : CardPaymentV = CardPaymentV.instanceFromNib() as! CardPaymentV
        view1.selectedScreen = 1
        displaySubViewtoParentView(self.view, subview: view1)
        self.view.addSubview(view1)
    }
    
    
    @IBAction func clickTOFrequentlyAskedQuestion(_ sender: Any) {
        self.view.endEditing(true)
        let vc : FaqVC = STORYBOARD.SETTING.instantiateViewController(withIdentifier: "FaqVC") as! FaqVC
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
