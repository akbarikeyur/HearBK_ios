//
//  FavoritesVC.swift
//  HearBK
//
//  Created by Keyur on 09/02/19.
//  Copyright © 2019 PC. All rights reserved.
//

import UIKit

class FavoritesVC: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var tblView: UITableView!
    @IBOutlet weak var noDataLbl: Label!
    
    var refreshControl : UIRefreshControl = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        NotificationCenter.default.addObserver(self, selector: #selector(loadFavoriteData), name: NSNotification.Name.init(NOTIFICATION.UPDATE_FAVORITE_USER), object: nil)
        
        tblView.register(UINib.init(nibName: "CustomFavoriteTVC", bundle: nil), forCellReuseIdentifier: "CustomFavoriteTVC")
        tblView.backgroundColor = UIColor.clear
        
        refreshControl.tintColor = GreenColor
        refreshControl.addTarget(self, action: #selector(refreshFavoriteData), for: .valueChanged)
        if #available(iOS 10.0, *) {
            tblView.refreshControl = refreshControl
        } else {
            tblView.addSubview(refreshControl)
        }
        
        if AppModel.shared.MyFavoriteUserArr.count == 0
        {
            noDataLbl.isHidden = false
        }
        else
        {
            noDataLbl.isHidden = true
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if tabBarController != nil
        {
            let tabBar : CustomTabBarController = self.tabBarController as! CustomTabBarController
            tabBar.setTabBarHidden(tabBarHidden: true)
        }
        tblView.reloadData()
    }
    
    //MARK: - Load new data
    @objc func refreshFavoriteData()
    {
        refreshControl.endRefreshing()
        AppDelegate().sharedDelegate().serviceCallMyFavorite()
        loadFavoriteData()
    }
    
    @objc func loadFavoriteData()
    {
        tblView.reloadData()
        if AppModel.shared.MyFavoriteUserArr.count == 0
        {
            noDataLbl.isHidden = false
        }
        else
        {
            noDataLbl.isHidden = true
        }
    }
    
    // MARK: - Button click event
    @IBAction func clickToBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    // MARK: - Tableview Method
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return AppModel.shared.MyFavoriteUserArr.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell : CustomFavoriteTVC = tblView.dequeueReusableCell(withIdentifier: "CustomFavoriteTVC") as! CustomFavoriteTVC
        let dict : UserModel = AppModel.shared.MyFavoriteUserArr[indexPath.row]
        
        cell.profilePicBtn.isUserInteractionEnabled = false
        cell.titleLbl.text = dict.display_name
        AppDelegate().sharedDelegate().setUserBackgroundImage(cell.profilePicBtn, dict.avatar)
        
        if dict.tag != ""
        {
            let tagArr : [String] = dict.tag.components(separatedBy: ",")
            if tagArr.count > 0
            {
                cell.tagView.addTag(tagArr[0])
                if tagArr.count > 1
                {
                    cell.tagView.addTag(tagArr[1])
                    
                    if tagArr.count > 2
                    {
                        if tagArr.count == 3
                        {
                            cell.tagView.addTag(tagArr[2])
                        }
                        else
                        {
                            cell.tagView.addTag(("+" + String(tagArr.count-2)))
                        }
                    }
                }
            }
        }
        cell.contentView.backgroundColor = UIColor.clear
        cell.selectionStyle = UITableViewCellSelectionStyle.none
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc : ProfileVC = STORYBOARD.PROFILE.instantiateViewController(withIdentifier: "ProfileVC") as! ProfileVC
        vc.isMyProfile = false
        vc.isFavorite = true
        vc.selectedUser = AppModel.shared.MyFavoriteUserArr[indexPath.row]
        self.navigationController?.pushViewController(vc, animated: true)
    }
 }
