//
//  FundHBKAccountVC.swift
//  HearBK
//
//  Created by PC on 04/02/19.
//  Copyright © 2019 PC. All rights reserved.
//

import UIKit
import NVActivityIndicatorView

class FundHBKAccountVC: UIViewController {

    @IBOutlet var balanceLbl: Label!
    @IBOutlet var successOrderView: View!
    
    @IBOutlet var totalPriceLbl: Label!
    @IBOutlet var progressContainerView: UIView!
    @IBOutlet weak var loaderView: UIView!
    @IBOutlet weak var progressLbl: Label!
    
    
    var param : [String : Any] = [String : Any]()
    var total : String = String()
    var audioData : Data = Data()
    var activityLoader : NVActivityIndicatorView!
    var requiredAmount : Float = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        NotificationCenter.default.addObserver(self, selector: #selector(updateUserDetail), name: NSNotification.Name.init(NOTIFICATION.UPDATE_CURRENT_USER_DATA), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(updateProgressValue(noti:)), name: NSNotification.Name.init(NOTIFICATION.UPDATE_PROGRESS_VALUE), object: nil)
        progressLbl.text = "0%"
        print(param)
        totalPriceLbl.text = total
        successOrderView.isHidden = true
        displaySubViewtoParentView(self.view, subview: successOrderView)
        if total != ""
        {
            requiredAmount = Float(total.replacingOccurrences(of: "$", with: ""))!
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if tabBarController != nil
        {
            let tabBar : CustomTabBarController = self.tabBarController as! CustomTabBarController
            tabBar.setTabBarHidden(tabBarHidden: true)
        }
        
        updateUserDetail()
    }
    
    
    @objc func updateUserDetail()
    {
        balanceLbl.text =  displayPriceWithCurrency(AppModel.shared.currentUser.wallet_balance)
    }
    
  
    @IBAction func clickToAddFund(_ sender: Any) {
        self.view.endEditing(true)
        
        let view1 : CardPaymentV = CardPaymentV.instanceFromNib() as! CardPaymentV
        view1.selectedScreen = 2
        view1.requiredAmount = (requiredAmount - AppModel.shared.currentUser.wallet_balance)
        displaySubViewtoParentView(self.view, subview: view1)
        self.view.addSubview(view1)
    }
    
    @IBAction func clickToPay(_ sender: Any) {
        self.view.endEditing(true)
        
        if AppModel.shared.currentUser.wallet_balance < requiredAmount
        {
            displayToast("Insufficient funds. Please add fund.")
            return
        }
        
        print(param)
        showProgress()
        APIManager.shared.serviceCallToPlaceOrder(audioData, param) {
            self.removeProgress()
            self.successOrderView.isHidden = false
            let total_amount : Float = Float(self.total.replacingOccurrences(of: "$", with: ""))!
            AppModel.shared.currentUser.wallet_balance -= total_amount
        }        
    }
    
    @IBAction func clickToBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func clickToDone(_ sender: Any) {
        successOrderView.isHidden = true
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    
    //MARK:- Progress Method
    func showProgress()
    {
        displaySubViewtoParentView(self.view, subview: progressContainerView)
        removeProgress()
        activityLoader = NVActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: loaderView.frame.size.width, height: loaderView.frame.size.height))
        activityLoader.type = .ballSpinFadeLoader
        activityLoader.color = GreenColor
        loaderView.addSubview(activityLoader)
        activityLoader.startAnimating()
    }

    func removeProgress()
    {
        if activityLoader == nil
        {
            return
        }
        activityLoader.stopAnimating()
        activityLoader.removeFromSuperview()
        activityLoader = nil
        progressContainerView.removeFromSuperview()
    }
    
    @objc func updateProgressValue(noti : Notification)
    {
        if let dict : [String : Double] = noti.object as? [String : Double]
        {
            if let value : Double = dict["value"]
            {
                progressLbl.text = String(Int(value)*100) + "%"
            }
            
        }
        
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}
