//
//  GiveFeedbackVC.swift
//  HearBK
//
//  Created by PC on 29/01/19.
//  Copyright © 2019 PC. All rights reserved.
//

import UIKit

class GiveFeedbackVC: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet var feedbackTblView: UITableView!
    
    @IBOutlet var loginBackView: UIView!
    
    var requestArr : [FeedBackModel] = [FeedBackModel]()
    var todayRequestArr : [FeedBackModel] = [FeedBackModel]()
    
    var refreshControl : UIRefreshControl = UIRefreshControl.init()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        feedbackTblView.register(UINib(nibName: "CustomFeedbackRequestTVC", bundle: nil), forCellReuseIdentifier: "CustomFeedbackRequestTVC")
        feedbackTblView.register(UINib(nibName: "CustomHeaderTVC", bundle: nil), forCellReuseIdentifier: "CustomHeaderTVC")
        feedbackTblView.register(UINib(nibName: "NoRequestHeaderTVC", bundle: nil), forCellReuseIdentifier: "NoRequestHeaderTVC")
        
        NotificationCenter.default.addObserver(self, selector: #selector(reloadTableView), name: NSNotification.Name.init(NOTIFICATION.UPDATE_CURRENT_USER_DATA), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(updateFeedbackRequestData(noti:)), name: NSNotification.Name.init(NOTIFICATION.UPDATE_FEEDBACK_REQUEST_DATA), object: nil)
        
        feedbackTblView.register(UINib.init(nibName: "CustomAddFeedbackTVC", bundle: nil), forCellReuseIdentifier: "CustomAddFeedbackTVC")
        
        refreshControl.tintColor = GreenColor
        refreshControl.addTarget(self, action: #selector(serviceCallToGetFeedbackRequest), for: .valueChanged)
        if #available(iOS 10.0, *) {
            feedbackTblView.refreshControl = refreshControl
        } else {
            feedbackTblView.addSubview(refreshControl)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if tabBarController != nil
        {
            let tabBar : CustomTabBarController = self.tabBarController as! CustomTabBarController
            tabBar.setTabBarHidden(tabBarHidden: true)
            self.extendedLayoutIncludesOpaqueBars = true
            edgesForExtendedLayout = UIRectEdge.bottom
        }
        
        if requestArr.count == 0 && todayRequestArr.count == 0
        {
            if isUserLogin() {
                loginBackView.isHidden = true
                feedbackTblView.isHidden = false
                serviceCallToGetFeedbackRequest()
            }else {
                loginBackView.isHidden = false
                feedbackTblView.isHidden = true
            }
        }
        
    }
    
    @objc func reloadTableView()
    {
        feedbackTblView.reloadData()
    }
    
    //MARK:- Broadcast Method
    @objc func updateFeedbackRequestData(noti : Notification)  {
        if let dict : [String : Any] = noti.object as? [String : Any]
        {
            let feedback : FeedBackModel = FeedBackModel.init(dict: dict)
            let index = todayRequestArr.firstIndex { (temp) -> Bool in
                temp.feedback_id == feedback.feedback_id
            }
            if index != nil
            {
                todayRequestArr.remove(at: index!)
            }
            else
            {
                let index1 = requestArr.firstIndex { (temp) -> Bool in
                    temp.feedback_id == feedback.feedback_id
                }
                if index1 != nil
                {
                    requestArr.remove(at: index1!)
                }
            }
            feedbackTblView.reloadData()
        }
    }
    
    //MARK:- Service Called
    @objc func serviceCallToGetFeedbackRequest()  {
        refreshControl.endRefreshing()
        APIManager.shared.serviceCallToGetFeedBackRequest { (data) in
            self.todayRequestArr = [FeedBackModel]()
            self.requestArr = [FeedBackModel]()
            
            let currentDate = getTodayDateFromCurrentDate()
            for item in data {
                
                let date : Date = getDateFromDateString(strDate: (item["created_at"] as! String), format: "yyyy-MM-dd HH:mm:ss")!
                let newDate : String = getDateStringFromDate(date: date, format: "yyyy-MM-dd")
                if  currentDate == newDate {
                    self.todayRequestArr.append(FeedBackModel.init(dict: item))
                } else {
                    self.requestArr.append(FeedBackModel.init(dict: item))
                }
            }
            self.todayRequestArr.reverse()
            self.requestArr.reverse()
            self.feedbackTblView.reloadData()
        }
        redirectToFeedbackRequestFromNotification()
    }
    
    
    //MARK: - Button Click
    @IBAction func clickToLogin(_ sender: Any) {
        self.view.endEditing(true)
        let vc : LoginVC = STORYBOARD.MAIN.instantiateViewController(withIdentifier: "LoginVC") as! LoginVC
        vc.screenType = 1
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func clickToSignUp(_ sender: Any) {
        self.view.endEditing(true)
        let vc : SignUpVC = STORYBOARD.MAIN.instantiateViewController(withIdentifier: "SignUpVC") as! SignUpVC
        vc.screenType = 1
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func clickToBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    //MARK: - Taleview delegate
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return todayRequestArr.count
        } else {
            return requestArr.count
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        if section == 0 {
            if todayRequestArr.count == 0 {
                let cell = feedbackTblView.dequeueReusableCell(withIdentifier: "NoRequestHeaderTVC") as! NoRequestHeaderTVC
                
                if isUserLogin() && AppModel.shared.currentUser.isBecomeListener == 1 {
                    cell.becomeLisnerBtnHeightConstraint.constant = 0
                }else {
                    cell.becomeLisnerBtnHeightConstraint.constant = 40
                    cell.becomeListenerBtn.addTarget(self, action: #selector(self.clickToBecomeListner), for: .touchUpInside)
                }
                cell.promoteYourprofileBtn.addTarget(self, action: #selector(self.clickToPromoteYourProfileListner), for: .touchUpInside)
                return cell.contentView
            } else {
                let cell = feedbackTblView.dequeueReusableCell(withIdentifier: "CustomHeaderTVC") as! CustomHeaderTVC
                cell.lbl.text = "New requests"
                cell.countLbl.isHidden = false
                cell.countLbl.text = "(\(todayRequestArr.count))"
                return cell.contentView
            }
        } else {
            let cell = feedbackTblView.dequeueReusableCell(withIdentifier: "CustomHeaderTVC") as! CustomHeaderTVC
            
            if requestArr.count == 0 {
                cell.lbl.text = ""
            }else {
                cell.lbl.text = "Old requests"
            }
            
            cell.countLbl.isHidden = true
            return cell.contentView
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            if todayRequestArr.count == 0 {
                if isUserLogin() && AppModel.shared.currentUser.isBecomeListener == 1 {
                    return 220
                }else {
                    return 260
                }
            } else {
                return 49
            }
        } else {
            return 49
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = feedbackTblView.dequeueReusableCell(withIdentifier: "CustomFeedbackRequestTVC", for: indexPath) as! CustomFeedbackRequestTVC
            let dict : FeedBackModel = todayRequestArr[indexPath.row]

            AppDelegate().sharedDelegate().setUserBackgroundImage(cell.profilePicBtn, dict.avatar)
            
            let songTitle = dict.track_title
            
            let attrs1 = [NSAttributedStringKey.font : UIFont(name: SFUI_BOLD, size: 16), NSAttributedStringKey.foregroundColor : UIColor.white]
            let attrs2 = [NSAttributedStringKey.font : UIFont(name: SFUI_MEDIUM, size: 15), NSAttributedStringKey.foregroundColor : UIColor.white]
            let attrs3 = [NSAttributedStringKey.font :  UIFont(name: SFUI_BOLD, size: 16), NSAttributedStringKey.foregroundColor : UIColor.white]
            
            
            let attributedString1 = NSMutableAttributedString(string: dict.display_name, attributes:attrs1)
            let attributedString2 = NSMutableAttributedString(string:" invited you to give feedback on ", attributes:attrs2)
            let attributedString3 = NSMutableAttributedString(string: "\"\(songTitle!)\"", attributes:attrs3)
            let attributedString4 = NSMutableAttributedString(string:" song.", attributes:attrs2)
            
            attributedString1.append(attributedString2)
            attributedString1.append(attributedString3)
            attributedString1.append(attributedString4)
            
            cell.titleLbl.attributedText = attributedString1 

            return cell
        } else {
            let cell = feedbackTblView.dequeueReusableCell(withIdentifier: "CustomFeedbackRequestTVC", for: indexPath) as! CustomFeedbackRequestTVC
            let dict : FeedBackModel = requestArr[indexPath.row]
            AppDelegate().sharedDelegate().setUserBackgroundImage(cell.profilePicBtn, dict.avatar)
            
            let songTitle = dict.track_title
            
            let attrs1 = [NSAttributedStringKey.font : UIFont(name: SFUI_BOLD, size: 16), NSAttributedStringKey.foregroundColor : UIColor.white]
            let attrs2 = [NSAttributedStringKey.font : UIFont(name: SFUI_MEDIUM, size: 15), NSAttributedStringKey.foregroundColor : UIColor.white]
            let attrs3 = [NSAttributedStringKey.font :  UIFont(name: SFUI_BOLD, size: 16), NSAttributedStringKey.foregroundColor : UIColor.white]
            
            
            let attributedString1 = NSMutableAttributedString(string: dict.display_name, attributes: attrs1)
            let attributedString2 = NSMutableAttributedString(string:" invited you to give feedback on ", attributes: attrs2)
            let attributedString3 = NSMutableAttributedString(string: "\"\(songTitle!)\"", attributes: attrs3)
            let attributedString4 = NSMutableAttributedString(string:" song.", attributes: attrs2)
            
            attributedString1.append(attributedString2)
            attributedString1.append(attributedString3)
            attributedString1.append(attributedString4)
            
            cell.titleLbl.attributedText = attributedString1
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var dict : FeedBackModel = FeedBackModel()
        if indexPath.section == 0 {
            dict = todayRequestArr[indexPath.row]
        }else {
            dict = requestArr[indexPath.row]
        }
        
        let vc : FeedbackRequestVC = STORYBOARD.HOME.instantiateViewController(withIdentifier: "FeedbackRequestVC") as! FeedbackRequestVC
        vc.selectedRequest = dict
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    //MARK:- Tableview Button click event
    @objc func clickToBecomeListner()  {
        let vc : BecomeListenerVC = STORYBOARD.MAIN.instantiateViewController(withIdentifier: "BecomeListenerVC") as! BecomeListenerVC
        self.navigationController?.pushViewController(vc, animated: true)
    }

    @objc func clickToPromoteYourProfileListner()  {
        let vc : PromoteProfileVC = STORYBOARD.SETTING.instantiateViewController(withIdentifier: "PromoteProfileVC") as! PromoteProfileVC
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    //MARK:- Push Notification redirection
    func redirectToFeedbackRequestFromNotification()
    {
        let order_id : Int = getOrderId()
        if order_id != -1
        {
            let index = todayRequestArr.firstIndex { (temp) -> Bool in
                temp.order_id == order_id
            }
            if index != nil
            {
                let vc : FeedbackRequestVC = STORYBOARD.HOME.instantiateViewController(withIdentifier: "FeedbackRequestVC") as! FeedbackRequestVC
                vc.selectedRequest = todayRequestArr[index!]
                self.navigationController?.pushViewController(vc, animated: true)
            }
            else
            {
                let index1 = requestArr.firstIndex { (temp) -> Bool in
                    temp.order_id == order_id
                }
                if index1 != nil
                {
                    let vc : FeedbackRequestVC = STORYBOARD.HOME.instantiateViewController(withIdentifier: "FeedbackRequestVC") as! FeedbackRequestVC
                    vc.selectedRequest = requestArr[index1!]
                    self.navigationController?.pushViewController(vc, animated: true)
                }
            }
            setOrderId(value: -1)
            setFeedbackRequestValue(value: false)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
