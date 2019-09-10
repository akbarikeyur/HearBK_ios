//
//  HomeVC.swift
//  HearBK
//
//  Created by PC on 29/01/19.
//  Copyright © 2019 PC. All rights reserved.
//

import UIKit

class HomeVC: UIViewController , UICollectionViewDelegate, UICollectionViewDataSource , UICollectionViewDelegateFlowLayout {

    @IBOutlet var featuredCollectionView: UICollectionView!
    @IBOutlet var featuredCollectionViewHeightConstraint: NSLayoutConstraint!
    
    
    var arrFeatureListener : [UserModel] = [UserModel]()
    let registerVC : CustomRegisterView = CustomRegisterView.instanceFromNib() as! CustomRegisterView
    
    var page : Int = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(customRegisterView(noti:)), name: NSNotification.Name.init("CUSTOM_REGISTER_VIEW"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(clickToRegister), name: NSNotification.Name.init("REDIRECT_TO_REGISTER"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(clickToLogin), name: NSNotification.Name.init("REDIRECT_TO_LOGIN"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(clickToGiveFeedback(_:)), name: NSNotification.Name.init(NOTIFICATION.REDIRECT_TO_GIVE_FEEDBACK), object: nil)
        
        
        featuredCollectionView.register(UINib(nibName: "CustomListenerCVC", bundle: nil), forCellWithReuseIdentifier: "CustomListenerCVC")
        
        if isUserLogin() {
            AppDelegate().sharedDelegate().getLoginUserDetail()
            AppDelegate().sharedDelegate().getAllRequiredDataAfterLogin()
        }
        getFeaturedList()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if tabBarController != nil
        {
            let tabBar : CustomTabBarController = self.tabBarController as! CustomTabBarController
            tabBar.setTabBarHidden(tabBarHidden: false)
        }
    }
    
    @objc func customRegisterView(noti : Notification)  {
        if tabBarController != nil
        {
            let tabBar : CustomTabBarController = self.tabBarController as! CustomTabBarController
            tabBar.tabBarView.resetAllButton()
            tabBar.tabBarView.btn1.isSelected = true
            tabBar.tabBarView.btn1.alpha = 1.0
            tabBar.tabBarView.lbl1.isHighlighted = true
        }
        if let dict : [String : Any] = noti.object as? [String : Any]
        {
            if let index : Int = dict["index"] as? Int
            {
                if index == 0 {
                    registerVC.isHidden = true
                }else {
                    registerVC.isHidden = false
                    displaySubViewtoParentView(self.view, subview: registerVC)
                    self.view.addSubview(registerVC)
                }
            }
        }
    }
    
    @objc func clickToRegister() {
        self.view.endEditing(true)
        let vc : SignUpVC = STORYBOARD.MAIN.instantiateViewController(withIdentifier: "SignUpVC") as! SignUpVC
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func clickToLogin() {
        self.view.endEditing(true)
        let vc : LoginVC = STORYBOARD.MAIN.instantiateViewController(withIdentifier: "LoginVC") as! LoginVC
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
    //MARK: - Button click
    @IBAction func clickToGiveFeedback(_ sender: Any) {
        let vc : GiveFeedbackVC = STORYBOARD.HOME.instantiateViewController(withIdentifier: "GiveFeedbackVC") as! GiveFeedbackVC
        self.navigationController?.pushViewController(vc, animated: true)
    }
    @IBAction func clickToGetFeedBack(_ sender: Any) {
        let vc : SearchforListnerVC = STORYBOARD.HOME.instantiateViewController(withIdentifier: "SearchforListnerVC") as! SearchforListnerVC
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func clickToSeeAllFeaturedListeners(_ sender: Any) {
        self.view.endEditing(true)
        let vc : ListenersListVC = STORYBOARD.HOME.instantiateViewController(withIdentifier: "ListenersListVC") as! ListenersListVC
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
    //MARK: - CollectionView Delegate
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == featuredCollectionView {
            return arrFeatureListener.count
        }else {
            return 4
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = featuredCollectionView.dequeueReusableCell(withReuseIdentifier: "CustomListenerCVC", for: indexPath) as! CustomListenerCVC
        let user = arrFeatureListener[indexPath.row]
        
        AppDelegate().sharedDelegate().setUserBackgroundImage(cell.profilePicBtn, user.avatar)
        cell.nameLbl.text = user.display_name
        cell.starView.rating = user.rating
        cell.rateLbl.text = setFlotingRating(user.rating)
        
        featuredCollectionViewHeightConstraint.constant = featuredCollectionView.contentSize.height
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    
        let Width = featuredCollectionView.frame.size.width / 3
        let Height = Width + CGFloat(55)
        return CGSize(width: Width, height: Height)
    
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == featuredCollectionView {
            let user = arrFeatureListener[indexPath.row]
            let vc : ProfileVC = STORYBOARD.PROFILE.instantiateViewController(withIdentifier: "ProfileVC") as! ProfileVC
            vc.isMyProfile = false
            vc.selectedUser = user
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    func getFeaturedList()
    {
        APIManager.shared.serviceCallToGetFeatureListeners(["page_no" : page]) { (data, totalPage) in
            self.arrFeatureListener = [UserModel]()
            for temp in data
            {
                self.arrFeatureListener.append(UserModel.init(dict: temp))
            }
            self.featuredCollectionView.reloadData()
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
        
    }
    
}
