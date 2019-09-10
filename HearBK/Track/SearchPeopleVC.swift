//
//  SearchPeopleVC.swift
//  HearBK
//
//  Created by PC on 02/02/19.
//  Copyright © 2019 PC. All rights reserved.
//

import UIKit

class SearchPeopleVC: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var searchTbl: UITableView!
    @IBOutlet weak var searchTxt: TextField!
    
    var arrSelectedData : [UserModel] = [UserModel]()
    var arrSearchData : [UserModel] = [UserModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        NotificationCenter.default.addObserver(self, selector: #selector(updateUserDetail), name: NSNotification.Name.init(NOTIFICATION.SELECTED_LISTENER), object: nil)
        
        searchTxt.addTarget(self, action: #selector(textFieldDidChange(textField:)), for: .editingChanged)
        searchTbl.register(UINib.init(nibName: "SearchPeopleTVC", bundle: nil), forCellReuseIdentifier: "SearchPeopleTVC")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if tabBarController != nil
        {
            let tabBar : CustomTabBarController = self.tabBarController as! CustomTabBarController
            tabBar.setTabBarHidden(tabBarHidden: true)
            self.extendedLayoutIncludesOpaqueBars = true
            edgesForExtendedLayout = UIRectEdge.bottom
        }
    }
    
    // handle notification
    @objc func updateUserDetail(notification: NSNotification) {
        let dict = notification.object as! [UserModel]
        arrSelectedData = dict
        searchTbl.reloadData()
    }
    
    // MARK:- Table View
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searchTxt.text != ""
        {
            return arrSearchData.count
        }
        return arrSelectedData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = searchTbl.dequeueReusableCell(withIdentifier: "SearchPeopleTVC", for: indexPath) as! SearchPeopleTVC
        
        var user : UserModel = UserModel.init()
        if searchTxt.text != ""
        {
            user = arrSearchData[indexPath.row]
        }
        else
        {
            user = arrSelectedData[indexPath.row]
        }
        AppDelegate().sharedDelegate().setUserBackgroundImage(cell.profileBtn, user.avatar)
        cell.nameLbl.text = user.display_name
        cell.priceLbl.text = displayPriceWithCurrency(user.price)
        
        cell.closeBtn.tag = indexPath.row
        cell.closeBtn.addTarget(self, action: #selector(clickToClose(_:)), for: .touchUpInside)
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    // MARK:- Button Click
    
    @IBAction func clickToClose(_ sender: UIButton) {
        self.view.endEditing(true)
        
        var user : UserModel = UserModel.init()
        if searchTxt.text != ""
        {
            user = arrSearchData[sender.tag]
        }
        else
        {
            user = arrSelectedData[sender.tag]
        }
        
        let index = arrSelectedData.index { (temp) -> Bool in
            temp.uId == user.uId
        }
        if index != nil
        {
            arrSelectedData.remove(at: index!)
        }
        
        let index1 = arrSearchData.index { (temp) -> Bool in
            temp.uId == user.uId
        }
        if index1 != nil
        {
            arrSearchData.remove(at: index1!)
        }
        searchTbl.reloadData()
        NotificationCenter.default.post(name: NSNotification.Name.init(NOTIFICATION.SELECTED_LISTENER), object: arrSelectedData)
    }
    
    @IBAction func clickToBack(_ sender: UIButton) {
        self.view.endEditing(true)
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func clickToSearchBtn(_ sender: Any) {
        self.view.endEditing(true)
        let vc : SearchforListnerVC = STORYBOARD.HOME.instantiateViewController(withIdentifier: "SearchforListnerVC") as! SearchforListnerVC
        vc.selectedUser = arrSelectedData
        vc.type1 = 1
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func textFieldDidChange(textField : UITextField)
    {
        arrSearchData = [UserModel]()
        arrSearchData = arrSelectedData.filter({ (temp) -> Bool in
            let name: NSString = temp.display_name! as NSString
            
            return (name.range(of: searchTxt.text!, options: NSString.CompareOptions.caseInsensitive).location) != NSNotFound
        })
        searchTbl.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
