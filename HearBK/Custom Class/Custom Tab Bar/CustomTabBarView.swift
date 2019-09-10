//
//  CustomTabBarView.swift
//  Event Project
//
//  Created by Amisha on 20/07/17.
//  Copyright © 2017 AK Infotech. All rights reserved.
//

import UIKit

protocol CustomTabBarViewDelegate
{
    func tabSelectedAtIndex(index:Int)
}

class CustomTabBarView: UIView {
    
    @IBOutlet var btn1: UIButton!
    @IBOutlet var btn2: UIButton!
    @IBOutlet var btn3: UIButton!
    @IBOutlet var btn4: UIButton!
    
    @IBOutlet var lbl1: UILabel!
    @IBOutlet var lbl2: UILabel!
    @IBOutlet var lbl3: UILabel!
    @IBOutlet var lbl4: UILabel!
    
    var delegate:CustomTabBarViewDelegate?
    var lastIndex : NSInteger!
    
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
    
    func initialize()
    {
        lastIndex = 0
    }
    
    @IBAction func tabBtnClicked(_ sender: UIButton)
    {
        let btn: UIButton = sender
        lastIndex = btn.tag - 1
        
        resetAllButton()
        selectTabButton()
        
        
        
    }
    
    func resetAllButton()
    {
        btn1.isSelected = false
        btn2.isSelected = false
        btn3.isSelected = false
        btn4.isSelected = false
        
        btn1.alpha = 0.5
        btn2.alpha = 0.5
        btn3.alpha = 0.5
        btn4.alpha = 0.5
        
        lbl1.isHighlighted = false
        lbl2.isHighlighted = false
        lbl3.isHighlighted = false
        lbl4.isHighlighted = false
    }
    
    func selectTabButton()
    {
        switch lastIndex {
        case 0:
            btn1.isSelected = true
            lbl1.isHighlighted = true
            btn1.alpha = 1.0
            break
        case 1:
            btn2.isSelected = true
            lbl2.isHighlighted = true
            btn2.alpha = 1.0
            break
        case 2:
            btn3.isSelected = true
            lbl3.isHighlighted = true
            btn3.alpha = 1.0
            break
        case 3:
            btn4.isSelected = true
            lbl4.isHighlighted = true
            btn4.alpha = 1.0
            break
        default:
            break
            
        }
        delegate?.tabSelectedAtIndex(index: lastIndex)
    }
}
