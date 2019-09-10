//
//  AlertV.swift
//  HearBk
//
//  Created by PC on 08/01/19.
//  Copyright © 2019 PC. All rights reserved.
//

import UIKit

class AlertV: UIView {

    @IBOutlet var futureTransactionView: View!
    @IBOutlet var congratulationView: View!
    @IBOutlet var paymentFailedView: UIView!
    @IBOutlet var successView: View!
    
    @IBOutlet var alertBackGroundBtn: UIButton!
    
    
    var selectScreen = Int()
    
    class func instanceFromNib() -> UIView {
        return Bundle.main.loadNibNamed("AlertV", owner: self, options: nil)![0] as! UIView
    }
    
    @IBAction func clickToNoThankSBtn(_ sender: Any) {
        if selectScreen == 1 {
//            futureTransactionView.isHidden = true
//            congratulationView.isHidden = false
//            successView.isHidden = true
            clicktoAccountBackgroundBtn(self)
            
            let view1 : SuccessErrorView = SuccessErrorView.instanceFromNib() as! SuccessErrorView
            displaySubViewtoParentView(UIApplication.topViewController()?.view, subview: view1)
            UIApplication.topViewController()?.view.addSubview(view1)
            
        } else {
            alertBackGroundBtn.isUserInteractionEnabled = true
            futureTransactionView.isHidden = true
            congratulationView.isHidden = true
            successView.isHidden = false
        }
        clicktoAccountBackgroundBtn(self)
    }
    
    @IBAction func clickToYesBtn(_ sender: Any) {
        setDefaultCardID((AppModel.shared.CARD_LIST.last?.id)!)
        NotificationCenter.default.post(name: NSNotification.Name.init(NOTIFICATION.UPDATE_CARD_DATA), object: nil)
        if selectScreen == 1 {
//            alertBackGroundBtn.isUserInteractionEnabled = true
//            futureTransactionView.isHidden = true
//            congratulationView.isHidden = true
//            successView.isHidden = true
            
            clicktoAccountBackgroundBtn(self)
            
            let view1 : SuccessErrorView = SuccessErrorView.instanceFromNib() as! SuccessErrorView
            displaySubViewtoParentView(UIApplication.topViewController()?.view, subview: view1)
            UIApplication.topViewController()?.view.addSubview(view1)
            
        }else {
            alertBackGroundBtn.isUserInteractionEnabled = true
            futureTransactionView.isHidden = true
            congratulationView.isHidden = true
            successView.isHidden = false
        }
        clicktoAccountBackgroundBtn(self)
    }
    
    @IBAction func clickToDone(_ sender: Any) {
        clicktoAccountBackgroundBtn(self)
    }
    
    @IBAction func clickToCancelBtn(_ sender: Any) {
        clicktoAccountBackgroundBtn(self)
    }
        
    @IBAction func clickToRetry(_ sender: Any) {
        clicktoAccountBackgroundBtn(self)
    }
    
    @IBAction func clicktoAccountBackgroundBtn(_ sender: Any) {
        self.endEditing(true)
        self.removeFromSuperview()
    }
    
}
