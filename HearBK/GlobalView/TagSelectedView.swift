//
//  TagSelectedView.swift
//  HearBK
//
//  Created by PC on 02/02/19.
//  Copyright © 2019 PC. All rights reserved.
//

import UIKit


protocol selectedTagDelegate {
    func getSelectedTagArray(_ selectedData : [String],_ tagIndex : Int)
}


class TagSelectedView: UIView, UITableViewDelegate ,UITableViewDataSource, UITextFieldDelegate, TagListViewDelegate {

    @IBOutlet weak var titleLbl: Label!
    @IBOutlet var tagTxt: TextField!
    
    @IBOutlet weak var selectedTagView: TagListView!
    @IBOutlet weak var constraintHeightSelectedTagListView: NSLayoutConstraint!
    
    @IBOutlet var tagTblView: UITableView!
    @IBOutlet var addBtn: Button!
    
    class func instanceFromNib() -> UIView {
        return UINib(nibName: "TagSelectedView", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! UIView
    }
    
    var selectedArr : [String] = [String]()
    var arrFilterData : [String] = []
    var isRegisterd : Bool = false
    var isRegisterd1 : Bool = false
    
    var delegate : selectedTagDelegate?
    var arrData : [String] = [String]()
    var tagIndex : Int = 0
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    func setup() {
        if tagTblView == nil {
            delay(0) {
                self.setup()
            }
            return
        }
        
        if tagIndex == 1 {
            arrData = AppModel.shared.LISTNER_TAG
            titleLbl.text = "Tag"
        }
        else {
            arrData = GENRESARRAY
            titleLbl.text = "Favorite genres"
        }

        tagTblView.register(UINib(nibName: "TagTVC", bundle: nil), forCellReuseIdentifier: "TagTVC")
        tagTblView.reloadData()
        
        tagTxt.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        
        setSelectedTagData()
    }
    
    @objc func textFieldDidChange()
    {
        if tagTxt.text != ""
        {
            let predicate : NSPredicate = NSPredicate(format: "SELF CONTAINS[c] %@", tagTxt.text!)
            arrFilterData = (arrData as NSArray).filtered(using: predicate) as! [String]
            tagTblView.reloadData()
        }
        
    }
    
    //MARK: - Tableview Delegate
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        if (tagTxt.text?.count)! > 0 {
            return arrFilterData.count
        }
        else{
            return arrData.count
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 54
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if tagTblView != nil && !isRegisterd {
            setup()
            isRegisterd = true
        }
        
        let cell = tagTblView.dequeueReusableCell(withIdentifier: "TagTVC", for: indexPath) as! TagTVC
        if (tagTxt.text?.count)! > 0 {
            cell.lbl.text = arrFilterData[indexPath.row]
        }
        else {
            
            cell.lbl.text = arrData[indexPath.row]
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if (tagTxt.text?.count)! > 0 {
            
            let index = selectedArr.index(where: { (temp) -> Bool in
                temp == arrFilterData[indexPath.row]
            })
            if index == nil {
                selectedArr.append(arrFilterData[indexPath.row])
            }
        }
        else{
            let index = selectedArr.index(where: { (temp) -> Bool in
                temp == arrData[indexPath.row]
            })
            if index == nil {
                selectedArr.append(arrData[indexPath.row])
            }
        }
        setSelectedTagData()
    }
    
    @IBAction func clickToAdd(_ sender: Any) {
        self.endEditing(true)
        if tagTxt.text != "" {
            let index = selectedArr.index(where: { (temp) -> Bool in
                temp == tagTxt.text!
            })
            if index == nil {
                selectedArr.append(tagTxt.text!)
            }
            setSelectedTagData()
            tagTxt.text = ""
        }
    }
    
    func setSelectedTagData()
    {
        selectedTagView.removeAllTags()
        selectedTagView.addTags(selectedArr)
        constraintHeightSelectedTagListView.constant = selectedTagView.intrinsicContentSize.height
    }
    
    func tagRemoveButtonPressed(_ title: String, tagView: TagView, sender: TagListView) {
        selectedTagView.removeTag(title)
        selectedArr = selectedTagView.getAllTag()
    }
    
    @IBAction func clickToDone(_ sender: Any) {
        self.endEditing(true)
        delegate?.getSelectedTagArray(selectedArr, tagIndex)
        self.removeFromSuperview()
    }
    
}

