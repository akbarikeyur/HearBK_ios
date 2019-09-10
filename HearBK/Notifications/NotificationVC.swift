//
//  NotificationVC.swift
//  HearBK
//
//  Created by PC on 01/02/19.
//  Copyright © 2019 PC. All rights reserved.
//

import UIKit

class NotificationVC: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet var tblView: UITableView!
    @IBOutlet var noDataFoundLbl: Label!
    
    var refreshControl : UIRefreshControl = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        tblView.register(UINib.init(nibName: "CustomFeedbackRequestTVC", bundle: nil), forCellReuseIdentifier: "CustomFeedbackRequestTVC")
        tblView.backgroundColor = UIColor.clear
        
        refreshControl.tintColor = GreenColor
        refreshControl.addTarget(self, action: #selector(refreshAllData), for: .valueChanged)
        if #available(iOS 10.0, *) {
            tblView.refreshControl = refreshControl
        } else {
            tblView.addSubview(refreshControl)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if tabBarController != nil
        {
            let tabBar : CustomTabBarController = self.tabBarController as! CustomTabBarController
            tabBar.setTabBarHidden(tabBarHidden: false)
        }
    }
    
    @objc func refreshAllData()
    {
        refreshControl.endRefreshing()
    }
    
    @IBAction func clickToLogout(_ sender: Any) {
        
    }
    
    //MARK: - Taleview delegate
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tblView.dequeueReusableCell(withIdentifier: "CustomFeedbackRequestTVC", for: indexPath) as! CustomFeedbackRequestTVC
        cell.titleLbl.text = "You earned $7.00 for giving feedback on “Girls like you” by “Amisha”"
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}
