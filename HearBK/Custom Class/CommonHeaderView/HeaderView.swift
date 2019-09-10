//
//  HeaderView.swift
//  9-MAG
//
//  Created by Amisha on 1/22/18.
//  Copyright © 2018 Amisha. All rights reserved.
//

import UIKit


protocol HeaderViewDelegate {
    
    func locationBtnTap(sender : UIButton)
    func notificationTap(sender : UIButton)
    func profileTap(sender : UIButton)
    func settingTap(sender : UIButton)
}

class HeaderView: UIView {
    
     var delegate:HeaderViewDelegate?
    
    @IBOutlet weak var constraintwidthofgreekyImg: NSLayoutConstraint!
    @IBOutlet weak var locationBtn: UIButton!
    @IBOutlet weak var notificationBtn: UIButton!
    @IBOutlet weak var profileBtn: UIButton!
    @IBOutlet weak var settingBtn: UIButton!
    
    @IBOutlet weak var constaintHeightTopView: NSLayoutConstraint!
    
    @IBOutlet weak var notificationLblBtn: Button!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initialize()
    }
    
    convenience init(frame: CGRect, title: String) {
        self.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        initialize()
        
      
    }
    func initialize()  {
        
    }
    
  
    @IBAction func onLocationBtnTap(_ sender: UIButton) {
        delegate?.locationBtnTap(sender: sender)
    }
    @IBAction func onNotificationBtnTap(_ sender: UIButton) {
        delegate?.notificationTap(sender: sender)
    }
    @IBAction func onProfileBtnTap(_ sender: UIButton) {
        delegate?.profileTap(sender: sender)
    }
    @IBAction func onSettingBtnTap(_ sender: UIButton) {
        delegate?.settingTap(sender: sender)
    }
    
  
}

class temVC: UIViewController {
    
}
   
    

