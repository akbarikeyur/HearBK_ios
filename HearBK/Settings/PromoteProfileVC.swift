//
//  PromoteProfileVC.swift
//  HearBK
//
//  Created by PC on 08/02/19.
//  Copyright © 2019 PC. All rights reserved.
//

import UIKit

class PromoteProfileVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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
