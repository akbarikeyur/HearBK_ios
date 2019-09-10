//
//  BalanceVC.swift
//  HearBK
//
//  Created by PC on 12/02/19.
//  Copyright © 2019 PC. All rights reserved.
//

import UIKit

class BalanceVC: UIViewController {

    @IBOutlet var balanceLbl: Label!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if isUserLogin() {
             balanceLbl.text =  displayPriceWithCurrency(AppModel.shared.currentUser.wallet_balance)
        }
        else {
             balanceLbl.text =  "0"
        }
       
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

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
 
}
