//
//  FaqVC.swift
//  HearBK
//
//  Created by PC on 14/02/19.
//  Copyright © 2019 PC. All rights reserved.
//

import UIKit

class FaqVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
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
