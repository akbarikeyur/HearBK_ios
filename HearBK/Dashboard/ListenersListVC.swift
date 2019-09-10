//
//  ListenersListVC.swift
//  HearBK
//
//  Created by PC on 07/02/19.
//  Copyright © 2019 PC. All rights reserved.
//

import UIKit

class ListenersListVC: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource , UICollectionViewDelegateFlowLayout {

    @IBOutlet var listenerCV: UICollectionView!
    @IBOutlet var titleLbl: Label!

    var arrFeatureListener : [UserModel] = [UserModel]()
    var page : Int = 1
    var isLoadNextData : Bool = true
    
    var refreshControl : UIRefreshControl = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        listenerCV.register(UINib(nibName: "CustomListenerCVC", bundle: nil), forCellWithReuseIdentifier: "CustomListenerCVC")
        
        refreshControl.tintColor = GreenColor
        refreshControl.addTarget(self, action: #selector(refreshUserData), for: .valueChanged)
        if #available(iOS 10.0, *) {
            listenerCV.refreshControl = refreshControl
        } else {
            listenerCV.addSubview(refreshControl)
        }
        
        
        titleLbl.text = "Featured Listeners"
        getFeaturedList()
        
    }

    @objc func refreshUserData()
    {
        refreshControl.endRefreshing()
        page = 1
        isLoadNextData = true
        getFeaturedList()
    }
    
    //MARK: - CollectionView Delegate
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrFeatureListener.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = listenerCV.dequeueReusableCell(withReuseIdentifier: "CustomListenerCVC", for: indexPath) as! CustomListenerCVC
        
        let user = arrFeatureListener[indexPath.row]
        
        AppDelegate().sharedDelegate().setUserBackgroundImage(cell.profilePicBtn, user.avatar)
        cell.nameLbl.text = user.display_name
        cell.starView.rating = user.rating
        cell.rateLbl.text = setFlotingRating(user.rating)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let Width = listenerCV.frame.size.width / 2
        let Height = Width + CGFloat(50)
        return CGSize(width: Width, height: Height)
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if (arrFeatureListener.count - 1) == indexPath.row && isLoadNextData
        {
            getFeaturedList()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let user = arrFeatureListener[indexPath.row]
        let vc : ProfileVC = STORYBOARD.PROFILE.instantiateViewController(withIdentifier: "ProfileVC") as! ProfileVC
        vc.isMyProfile = false
        vc.selectedUser = user
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    //MARK:- Service call to get listener list
    func getFeaturedList()
    {
        APIManager.shared.serviceCallToGetFeatureListeners(["page_no" : page]) { (data, totalpage) in
            if self.page == 1
            {
                self.arrFeatureListener = [UserModel]()
            }
            for temp in data
            {
                self.arrFeatureListener.append(UserModel.init(dict: temp))
            }
            self.listenerCV.reloadData()
            
            if self.page == totalpage {
                self.isLoadNextData = false
            }
            else
            {
                self.page += 1
            }
            
        }
    }
    
    //MARK: - Button click
    @IBAction func clickToBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}
