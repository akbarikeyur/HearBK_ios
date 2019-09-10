//
//  EarningsVC.swift
//  HearBK
//
//  Created by Keyur on 09/02/19.
//  Copyright © 2019 PC. All rights reserved.
//

import UIKit

class EarningsVC: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var earningScroll: UIScrollView!
    @IBOutlet weak var tblView: UITableView!
    @IBOutlet weak var constraintHeightTblView: NSLayoutConstraint!
    @IBOutlet weak var balanceLbl: Label!
    @IBOutlet weak var filterTypeLbl: Label!
    
    @IBOutlet weak var noDataLbl: Label!
    
    @IBOutlet var filterView: UIView!
    @IBOutlet weak var dateView: UIView!
    @IBOutlet weak var constraintHeightDateView: NSLayoutConstraint!//50
    @IBOutlet weak var fromDateTxt: TextField!
    @IBOutlet weak var toDateTxt: TextField!
    
    var selectedFromDate : Date?
    var selectedToDate : Date?
    var searchType : String = "all"
    var arrEarningData : [EarningModel] = [EarningModel]()
    var page : Int = 1
    var isLoadNextData : Bool = true
    var refreshControl : UIRefreshControl = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        tblView.register(UINib.init(nibName: "CustomEarningSTVC", bundle: nil), forCellReuseIdentifier: "CustomEarningSTVC")
        tblView.backgroundColor = UIColor.clear
        tblView.isScrollEnabled = false
        
        refreshControl.tintColor = GreenColor
        refreshControl.addTarget(self, action: #selector(refreshAllData), for: .valueChanged)
        if #available(iOS 10.0, *) {
            earningScroll.refreshControl = refreshControl
        } else {
            earningScroll.addSubview(refreshControl)
        }
        
        filterTypeLbl.text = ""
        balanceLbl.text = displayPriceWithCurrency(AppModel.shared.currentUser.my_earning)
        
        dateView.isHidden = true
        constraintHeightDateView.constant = 0
        
        refreshAllData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if tabBarController != nil
        {
            let tabBar : CustomTabBarController = self.tabBarController as! CustomTabBarController
            tabBar.setTabBarHidden(tabBarHidden: true)
        }
    }
    
    //MARK: - Refresh Earning List
    @objc func refreshAllData()
    {
        refreshControl.endRefreshing()
        page = 1
        isLoadNextData = true
        getEarningTransaction()
    }
    
    // MARK: - Tableview Method
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrEarningData.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell : CustomEarningSTVC = tblView.dequeueReusableCell(withIdentifier: "CustomEarningSTVC") as! CustomEarningSTVC
        
        let dict = arrEarningData[indexPath.row]
        cell.titleLbl.text = dict.trcak_name
        cell.rateBtn.setTitle(setFlotingRating(dict.rating), for: .normal)
        cell.priceLbl.text = displayPriceWithCurrency(dict.earning_amount)
        cell.dateLbl.text = getDateStringFromDate(date: getDateFromDateString(strDate: dict.date, format: "YYYY-MM-dd")!, format: "MMM d,YYYY")
        cell.subTitleLbl.text = dict.feedback
        cell.contentView.backgroundColor = UIColor.clear
        cell.selectionStyle = UITableViewCellSelectionStyle.none
        constraintHeightTblView.constant = tblView.contentSize.height
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if arrEarningData.count - 1 == indexPath.row && isLoadNextData
        {
            getEarningTransaction()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc : TrackDetailVC = STORYBOARD.HOME.instantiateViewController(withIdentifier: "TrackDetailVC") as! TrackDetailVC
        vc.track_id = arrEarningData[indexPath.row].track_id
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    // MARK: - Button click event
    @IBAction func clickToBack(_ sender: Any) {
        self.view.endEditing(true)
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func clickToFilter(_ sender: Any) {
        displaySubViewtoParentView(self.view, subview: filterView)
    }
    
    @IBAction func clickToSelectFilterType(_ sender: UIButton) {
        for i in 101...106
        {
            let btn : UIButton = self.view.viewWithTag(i) as! UIButton
            btn.isSelected = false
        }
        sender.isSelected = true
        if sender.tag == 106
        {
            dateView.isHidden = false
            constraintHeightDateView.constant = 40
        }
        else
        {
            dateView.isHidden = true
            constraintHeightDateView.constant = 0
        }
        
        switch sender.tag {
        case 101:
            filterTypeLbl.text = "Today"
            searchType = "today"
            break
        case 102:
            filterTypeLbl.text = "Yesterday"
            searchType = "yesterday"
            break
        case 103:
            filterTypeLbl.text = "This Week"
            searchType = "this_week"
            break
        case 104:
            filterTypeLbl.text = "This Month"
            searchType = "this_month"
            break
        case 105:
            filterTypeLbl.text = "Last Month"
            searchType = "last_month"
            break
        case 106:
            filterTypeLbl.text = ""
            searchType = "custom"
            break
        default:
            break
        }
    }
    
    @IBAction func clickToSelectFromDate(_ sender: Any) {
        if selectedFromDate == nil
        {
            selectedFromDate = Date()
        }
        let maxDate : Date = Date()
        DatePickerManager.shared.showPicker(title: "select_dob", selected: selectedFromDate, min: nil, max: maxDate) { (date, cancel) in
            if !cancel && date != nil {
                self.selectedFromDate = date!
                self.fromDateTxt.text = getDateStringFromDate(date: self.selectedFromDate!, format: "MM-dd-yyyy")
                self.toDateTxt.text = ""
                self.selectedToDate = nil
            }
        }
    }
    
    @IBAction func clickToSelectToDate(_ sender: Any) {
        if fromDateTxt.text == "" || selectedFromDate == nil
        {
            displayToast("Please select from date first")
            return
        }
        
        if selectedToDate == nil
        {
            selectedToDate = Calendar.current.date(byAdding: .day, value: -1, to: Date())!
        }
        let maxDate : Date = Date()
        let minDate : Date = selectedFromDate!
        DatePickerManager.shared.showPicker(title: "select_dob", selected: selectedToDate, min: minDate, max: maxDate) { (date, cancel) in
            if !cancel && date != nil {
                self.selectedToDate = date!
                self.toDateTxt.text = getDateStringFromDate(date: self.selectedToDate!, format: "MM-dd-yyyy")
                
                self.filterTypeLbl.text = getDateStringFromDate(date: self.selectedFromDate!, format: "dd MMM, yyyy") + " To " + getDateStringFromDate(date: self.selectedToDate!, format: "dd MMM, yyyy")
            }
        }
    }
    
    @IBAction func clickToResetFilter(_ sender: Any) {
        clickToCloseDateView(self)
        filterTypeLbl.text = ""
        searchType = "all"
        refreshAllData()
    }
    
    @IBAction func clickToApplyFilter(_ sender: Any) {
        clickToCloseDateView(self)
        refreshAllData()
    }
    
    
    @IBAction func clickToCloseDateView(_ sender: Any) {
        filterView.removeFromSuperview()
    }
    
    //MARK: - Service called
    func getEarningTransaction()
    {
        var param : [String : Any] = [String : Any]()
        param["page_no"] = page
        param["search"] = searchType
        if searchType == "custom"
        {
            param["fromDate"] = getDateStringFromDate(date: self.selectedFromDate!, format: "yyyy-MM-dd")
            param["toDate"] = getDateStringFromDate(date: self.selectedToDate!, format: "yyyy-MM-dd")
        }
        
        print(param)
        APIManager.shared.serviceCallToGetMyEarningHistory(param) { (data, totalpage) in
            if self.page == 1
            {
                self.arrEarningData = [EarningModel]()
            }
            
            for temp in data
            {
                self.arrEarningData.append(EarningModel.init(dict: temp))
            }
            if self.page == totalpage {
                self.isLoadNextData = false
            }
            else
            {
                self.page += 1
            }
            self.tblView.reloadData()
            self.constraintHeightTblView.constant = self.tblView.contentSize.height
            
            if self.arrEarningData.count == 0
            {
                if self.searchType == "custom"
                {
                    self.noDataLbl.text = "You have no any earning record from " + self.filterTypeLbl.text!
                }
                else if self.searchType == "all"
                {
                    self.noDataLbl.text = "You have no any earning record."
                }
                else
                {
                    self.noDataLbl.text = "You have no any earning record for " + (self.filterTypeLbl.text?.lowercased())!
                }
                self.noDataLbl.isHidden = false
            }
            else
            {
                self.noDataLbl.isHidden = true
            }
        }
    }
    
}
