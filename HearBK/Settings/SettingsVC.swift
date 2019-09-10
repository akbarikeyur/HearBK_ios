//
//  SettingsVC.swift
//  HearBK
//
//  Created by PC on 08/02/19.
//  Copyright © 2019 PC. All rights reserved.
//

import UIKit

class SettingsVC: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet var tblView: UITableView!
    
    var arrSetting = ["Earnings","Balance","Paypal", "Account (Upgrade Now)", "Favorites", "Support (Coming Soon)", "Cosigns (Coming Soon)", "Get Verified (Coming Soon)",  "Logout"]
    var arrSettingImg = ["earnings","purse","paypals", "account", "favorites", "support", "cosigns", "getVerified", "logout"]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        tblView.register(UINib.init(nibName: "CustomSettingTVC", bundle: nil), forCellReuseIdentifier: "CustomSettingTVC")
        tblView.backgroundColor = UIColor.clear
    }

    override func viewWillAppear(_ animated: Bool) {
        if tabBarController != nil
        {
            let tabBar : CustomTabBarController = self.tabBarController as! CustomTabBarController
            tabBar.setTabBarHidden(tabBarHidden: false)
        }
        tblView.reloadData()
    }
    
    // MARK: - Tableview Delegate    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrSetting.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 5 || indexPath.row == 6 || indexPath.row == 7 {
            return 0
        }
        else if indexPath.row == 3 && AppModel.shared.currentUser.account_type == 1
        {
            return 0
        }
        else {
             return 50
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell : CustomSettingTVC = tblView.dequeueReusableCell(withIdentifier: "CustomSettingTVC") as! CustomSettingTVC
        
        cell.titleLbl.text = arrSetting[indexPath.row]
        if indexPath.row == 3
        {
            cell.titleLbl.text = "Account"
            cell.subTitleLbl.text = " (Upgrade Now)"
        }
        else
        {
            cell.subTitleLbl.text = ""
        }
        cell.imgBtn.setImage(UIImage.init(named: arrSettingImg[indexPath.row]), for: .normal)
        cell.backgroundColor = UIColor.clear
        cell.selectionStyle = UITableViewCellSelectionStyle.none
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 0:
            let vc : EarningsVC = STORYBOARD.SETTING.instantiateViewController(withIdentifier: "EarningsVC") as! EarningsVC
            self.navigationController?.pushViewController(vc, animated: true)
            break
        case 1:
            let vc : BalanceVC = STORYBOARD.SETTING.instantiateViewController(withIdentifier: "BalanceVC") as! BalanceVC
            self.navigationController?.pushViewController(vc, animated: true)
            break
        case 2:
            let vc : PaypalVC = STORYBOARD.SETTING.instantiateViewController(withIdentifier: "PaypalVC") as! PaypalVC
            self.navigationController?.pushViewController(vc, animated: true)
            break
        case 3:
            let vc : UpgradeVC = STORYBOARD.SETTING.instantiateViewController(withIdentifier: "UpgradeVC") as! UpgradeVC
            self.navigationController?.pushViewController(vc, animated: true)
            break
        case 4:
            let vc : FavoritesVC = STORYBOARD.SETTING.instantiateViewController(withIdentifier: "FavoritesVC") as! FavoritesVC
            self.navigationController?.pushViewController(vc, animated: true)
            break
        case 8:
            DispatchQueue.main.async {
                showAlertWithOption("HearBK", message: "Are you sure you want to logout?", completionConfirm: {
                    AppDelegate().sharedDelegate().logoutApp()
                }) {
                    
                }
            }
            break
        default:
            break
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
