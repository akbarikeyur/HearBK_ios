//
//  RatingVC.swift
//  HearBK
//
//  Created by PC on 31/01/19.
//  Copyright © 2019 PC. All rights reserved.
//

import UIKit

class RatingVC: UIViewController {

    @IBOutlet weak var responseTimeRatingView: FloatRatingView!
    @IBOutlet weak var serviceRatingView: FloatRatingView!
    @IBOutlet weak var recommendRatingView: FloatRatingView!
    
    @IBOutlet weak var commentTxt: TextField!
    var listener_id : String = ""
    var order_id : Int = Int()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        print(listener_id)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if tabBarController != nil
        {
            let tabBar : CustomTabBarController = self.tabBarController as! CustomTabBarController
            tabBar.setTabBarHidden(tabBarHidden: true)
        }
    }
    
    // MARK:- Button Click
    @IBAction func clickToBack(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func clickToSubmit(_ sender: UIButton) {
        if commentTxt.text?.trimmed.count == 0 {
            displayToast("Please enter comment")
        }
        else {
            var param : [String : Any] = [String : Any]()
            param["order_id"] = order_id
            param["listener_id"] = listener_id
            param["response"] = responseTimeRatingView.rating
            param["service"] = serviceRatingView.rating
            param["recommend"] = recommendRatingView.rating
            param["comment"] = commentTxt.text
            
            APIManager.shared.serviceCallToRateListener(param) {
                self.navigationController?.popToRootViewController(animated: true)
            }
        }        
       
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
