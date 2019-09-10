//
//  CustomTabBarController.swift
//  Event Project
//
//  Created by Amisha on 20/07/17.
//  Copyright © 2017 AK Infotech. All rights reserved.
//

import UIKit

class CustomTabBarController: UITabBarController, CustomTabBarViewDelegate {
   
    var tabBarView : CustomTabBarView = CustomTabBarView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.layoutIfNeeded()
        
        NotificationCenter.default.addObserver(self, selector: #selector(redirectToTabBar(noti:)), name: NSNotification.Name.init(NOTIFICATION.REDICT_TAB_BAR), object: nil)
        
        tabBarView = Bundle.main.loadNibNamed("CustomTabBarView", owner: nil, options: nil)?.last as! CustomTabBarView
        tabBarView.delegate = self
        addTabBarView()
        setup()
    }
    
    @objc func redirectToTabBar(noti : Notification)
    {
        if let dict : [String : Any] = noti.object as? [String : Any]
        {
            if let index : Int = dict["tabIndex"] as? Int
            {
                tabBarView.resetAllButton()
                tabBarView.lastIndex = index
                tabBarView.selectTabButton()
                tabSelectedAtIndex(index: index)
            }
        }
    }
    
    //MARK: - CUSTOM TABBAR SETUP
    func setup()
    {
        var viewControllers = [UINavigationController]()
        let navController1 : UINavigationController = STORYBOARD.HOME.instantiateViewController(withIdentifier: "HomeVCNavigation") as! UINavigationController
        viewControllers.append(navController1)
        
        let navController2 : UINavigationController = STORYBOARD.PROFILE.instantiateViewController(withIdentifier: "ProfileVCNavigation") as! UINavigationController
        viewControllers.append(navController2)
        
        let navController3 : UINavigationController = STORYBOARD.SETTING.instantiateViewController(withIdentifier: "SettingsVCNavigation") as! UINavigationController
        viewControllers.append(navController3)
        
        let navController5 : UINavigationController = STORYBOARD.HOME.instantiateViewController(withIdentifier: "NotificationVCNavigation") as! UINavigationController
        viewControllers.append(navController5)
        
        self.viewControllers = viewControllers;
        
        self.tabBarView.btn1.isSelected = true;
        self.tabBarView.lbl1.isHighlighted = true;
        self.tabBarView.btn1.alpha = 1.0
        self.tabBarView.btn2.alpha = 0.5
        self.tabBarView.btn3.alpha = 0.5
        self.tabBarView.btn4.alpha = 0.5
        
        self.tabSelectedAtIndex(index: 0)
    }
    
    func tabSelectedAtIndex(index: Int) {
        if isUserLogin() {
            setSelectedViewController(selectedViewController: (self.viewControllers?[index])!, tabIndex: index)
        } else {
            setSelectedViewController(selectedViewController: (self.viewControllers?[0])!, tabIndex: index)
            NotificationCenter.default.post(name: NSNotification.Name.init("CUSTOM_REGISTER_VIEW"), object: ["index" : index])
        }
    }
    
    func setSelectedViewController(selectedViewController:UIViewController, tabIndex:Int)
    {
        // pop to root if tapped the same controller twice
        if self.selectedViewController == selectedViewController {
            (self.selectedViewController as! UINavigationController).popToRootViewController(animated: true)
        }
        super.selectedViewController = selectedViewController
    }
    
    func addTabBarView()
    {
        self.tabBarView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(self.tabBarView)
        
        self.view.addConstraint(NSLayoutConstraint(item: self.tabBarView, attribute: NSLayoutAttribute.height, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: NSLayoutAttribute.notAnAttribute, multiplier: 1.0, constant: 50.0))
        
        self.view.addConstraint(NSLayoutConstraint(item: self.tabBarView, attribute: NSLayoutAttribute.leading, relatedBy: NSLayoutRelation.equal, toItem: self.view, attribute: NSLayoutAttribute.leading, multiplier: 1.0, constant: 0.0))
        
        self.view.addConstraint(NSLayoutConstraint(item: self.tabBarView, attribute: NSLayoutAttribute.bottom, relatedBy: NSLayoutRelation.equal, toItem: self.view, attribute: NSLayoutAttribute.bottom, multiplier: 1.0, constant: ((UIScreen.main.bounds.size.height >= 812) ? -34 : 0)))
        
        self.view.addConstraint(NSLayoutConstraint(item: self.tabBarView, attribute: NSLayoutAttribute.trailing, relatedBy: NSLayoutRelation.equal, toItem: self.view, attribute: NSLayoutAttribute.trailing, multiplier: 1.0, constant: 0.0))
        self.view.layoutIfNeeded()
    }
    
    func tabBarHidden() -> Bool
    {
        return self.tabBarView.isHidden && self.tabBar.isHidden
    }
    
    func setTabBarHidden(tabBarHidden:Bool)
    {
        self.tabBarView.isHidden = tabBarHidden
        self.tabBar.isHidden = true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
  
}
