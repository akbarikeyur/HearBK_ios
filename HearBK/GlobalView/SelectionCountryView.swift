//
//  SelectionCountryView.swift
//  HearBK
//
//  Created by PC on 16/02/19.
//  Copyright © 2019 PC. All rights reserved.
//

import UIKit

protocol selectedCountryStateDelegate {
    func getSelectedCountryStateArray(_ selectedData : String,_ tagIndex : Int)
}


class SelectionCountryView: UIView, UITableViewDelegate ,UITableViewDataSource, UITextFieldDelegate {

    @IBOutlet var topLbl: Label!
    @IBOutlet var tagTblView: UITableView!
    @IBOutlet var searchTxt: TextField!
    
    
    class func instanceFromNib() -> UIView {
        return UINib(nibName: "SelectionCountryView", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! UIView
    }
    
    var selectedString : String = String()
    var arrFilterData : [String] = [String]()
    var isSearch : Bool = false
    var isRegisterd : Bool = false
    
    var delegate : selectedCountryStateDelegate?
    var arrData : [String] = [String]()
    var index : Int = 0
    
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
       
        tagTblView.register(UINib(nibName: "TagTVC", bundle: nil), forCellReuseIdentifier: "TagTVC")
        tagTblView.reloadData()
        searchTxt.text = ""
        searchTxt.addTarget(self, action: #selector(textFieldDidChange(textField:)), for: .editingChanged)
        searchTxt.placeholderColorString = "Search"
        switch index {
        case 1:
            topLbl.text = "Select Country"
            break
        case 2:
            topLbl.text = "Select State"
            break
        case 3:
            topLbl.text = "Select City"
            break
        default:
            break
        }
    }
    
    @objc func textFieldDidChange(textField : UITextField)
    {
        arrFilterData = [String]()
        let searchPredicate = NSPredicate(format: "SELF CONTAINS[c] %@", textField.text!)
        let array = (arrData as NSArray).filtered(using: searchPredicate)
        arrFilterData = array as! [String]
        
        if textField.text == "" {
            isSearch = false
            tagTblView.reloadData()
        }
        else {
            isSearch = true
        }
        tagTblView.reloadData()
    }
    
    @IBAction func clickToClose(_ sender: Any) {
        self.removeFromSuperview()
    }
    
    
    //MARK: - Tableview Delegate
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int  {
        if isSearch {
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
        if isSearch {
            cell.lbl.text = arrFilterData[indexPath.row]
        }
        else {
            cell.lbl.text = arrData[indexPath.row]
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if isSearch {
            selectedString = arrFilterData[indexPath.row]
        }
        else{
            selectedString = arrData[indexPath.row]
        }
        
        self.endEditing(true)
        searchTxt.text = ""
        delegate?.getSelectedCountryStateArray(selectedString, index)
        self.removeFromSuperview()
    }

}
