//
//  BecomeListenerVC.swift
//  HearBK
//
//  Created by PC on 30/01/19.
//  Copyright © 2019 PC. All rights reserved.
//

import UIKit
import DropDown


class BecomeListenerVC: UploadImageVC, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout , selectedTagDelegate, UITextFieldDelegate, selectedCountryStateDelegate {
   
    @IBOutlet var profileBtn: Button!
    @IBOutlet var nameTxt: TextField!
    @IBOutlet var maleBtn: Button!
    @IBOutlet var femaleBtn: Button!
    @IBOutlet var otherBtn: Button!
    @IBOutlet var dOBLbl: Label!
    @IBOutlet var headlineTxt: TextField!
    @IBOutlet var bioTxt: TextField!
    @IBOutlet var priceTxt: TextField!
    @IBOutlet var favouriteGenrseTxt: TextField!
    @IBOutlet var countryTxt: TextField!
    @IBOutlet var stateTxt: TextField!
    @IBOutlet var cityTxt: TextField!
    
    @IBOutlet var favouriteCollectionView: UICollectionView!
    @IBOutlet var favouriteCollectioViewHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet var tagCollectionView: UICollectionView!
    @IBOutlet var tagcollectionViewHeightConstraint: NSLayoutConstraint!
    
    var COUNTRY_ARRAY : [String] = AppDelegate().sharedDelegate().getCountryList()
    var STATE_ARRAY : [String] = [String]()
    var CITY_ARRAY:[String] = []
    
    var countryId : String = ""
    var stateId:String = ""
    var cityId:String = ""
    
    let SelectCountryVC : SelectionCountryView = SelectionCountryView.instanceFromNib() as! SelectionCountryView
    
    var selectedDate : Date!
    
    var favouriteArr : [String] = [String]()
    var selectedTag : [String] = [String]()
    var profileImg : UIImage?
    
    var imgData : Data = Data()
    var gender = "Male"
    let tagVC : TagSelectedView = TagSelectedView.instanceFromNib() as! TagSelectedView
    
    var isFBLogin : Bool = false
    var screenType : Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tagCollectionView.register(UINib(nibName: "TagCVC", bundle: nil), forCellWithReuseIdentifier: "TagCVC")
        favouriteCollectionView.register(UINib(nibName: "TagCVC", bundle: nil), forCellWithReuseIdentifier: "TagCVC")

        maleBtn.isSelected = true
        tagVC.delegate = self
        SelectCountryVC.delegate = self
        
        NotificationCenter.default.addObserver(self, selector: #selector(updateUserDetail), name: NSNotification.Name.init(NOTIFICATION.TAG_RELOAD), object: nil)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if tabBarController != nil
        {
            let tabBar : CustomTabBarController = self.tabBarController as! CustomTabBarController
            tabBar.setTabBarHidden(tabBarHidden: true)
        }
    }
    
    
    func getSelectedTagArray(_ selectedData: [String], _ tagIndex: Int) {
        if tagIndex == 1 {
            selectedTag = selectedData
            tagCollectionView.reloadData()
        }else {
            favouriteArr = selectedData
            favouriteCollectionView.reloadData()
        }
    }
    
    @objc func updateUserDetail()  {
        tagCollectionView.reloadData()
    }
    
    //MARK: - CollectionView Delegate
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == favouriteCollectionView {
            return favouriteArr.count
        } else {
            return selectedTag.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == favouriteCollectionView {
            let cell = favouriteCollectionView.dequeueReusableCell(withReuseIdentifier: "TagCVC", for: indexPath) as! TagCVC
            cell.tagLbl.text = favouriteArr[indexPath.row]
            
            cell.cancelBtn.tag = indexPath.row
            cell.cancelBtn.addTarget(self, action: #selector(self.clickToCancel), for: .touchUpInside)
            cell.cancelBtnWidthConstraint.constant = 30
            
            cell.tagLbl.textColor = WhiteColor
            favouriteCollectioViewHeightConstraint.constant = favouriteCollectionView.contentSize.height
            return cell
            
        } else {
            let cell = tagCollectionView.dequeueReusableCell(withReuseIdentifier: "TagCVC", for: indexPath) as! TagCVC
            
            cell.tagLbl.text = selectedTag[indexPath.row]
            
            cell.cancelBtn.tag = indexPath.row
            cell.cancelBtn.addTarget(self, action: #selector(self.clickToCancelSelectedTag(sender:)), for: .touchUpInside)
            cell.cancelBtnWidthConstraint.constant = 30
            
            cell.tagLbl.textColor = WhiteColor
            tagcollectionViewHeightConstraint.constant = tagCollectionView.contentSize.height
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

        if collectionView == favouriteCollectionView {
            let label = UILabel(frame: CGRect.zero)
            label.text = favouriteArr[indexPath.row]
            label.sizeToFit()
            return CGSize(width: label.frame.width + 20 + 30, height: 40)
        } else {
            let label = UILabel(frame: CGRect.zero)
            label.text = selectedTag[indexPath.row]
            label.sizeToFit()
            return CGSize(width: label.frame.width + 20 + 30, height: 40)
        }
    }
    
    //MARK: - Button click
    @objc func clickToCancel(sender : UIButton) {
        self.view.endEditing(true)
        let index = favouriteArr.index(where: { (temp) -> Bool in
            temp == favouriteArr[sender.tag]
        })
        if index != nil {
            favouriteArr.remove(at: index!)
            if favouriteArr.count == 0 {
                favouriteCollectioViewHeightConstraint.constant = 2
            }
        }
        favouriteCollectionView.reloadData()
    }
    
    @objc func clickToCancelSelectedTag(sender : UIButton) {
        self.view.endEditing(true)
        let index = selectedTag.index(where: { (temp) -> Bool in
            temp == selectedTag[sender.tag]
        })
        if index != nil {
            selectedTag.remove(at: index!)
            if selectedTag.count == 0 {
                tagcollectionViewHeightConstraint.constant = 2
            }
        }
        tagCollectionView.reloadData()
    }
    
    @IBAction func clickToProfileBtn(_ sender: Any) {
        self.view.endEditing(true)
        uploadImage()
    }
    
    override func selectedImage(choosenImage: UIImage) {
        profileBtn.setImage(choosenImage, for: .normal)
        profileBtn.imageView?.contentMode = .scaleAspectFill
        profileImg = choosenImage
    }
    
    @IBAction func clickToCalender(_ sender: Any) {
        self.view.endEditing(true)
        if selectedDate == nil
        {
            selectedDate = Date()
        }
        let maxDate : Date = Calendar.current.date(byAdding: .year, value: -18, to: Date())!
        DatePickerManager.shared.showPicker(title: "select_dob", selected: selectedDate, min: nil, max: maxDate) { (date, cancel) in
            if !cancel && date != nil {
                self.selectedDate = date!
            
                self.dOBLbl.text = getDateStringFromDate(date: self.selectedDate, format: "YYYY-MM-dd")
            }
        }
    }
    
    @IBAction func clickToCountry(_ sender: UIButton) {
        self.view.endEditing(true)
        displaySubViewtoParentView(self.view, subview: SelectCountryVC)
        SelectCountryVC.index = 1
        SelectCountryVC.arrData = COUNTRY_ARRAY
        SelectCountryVC.setup()
        SelectCountryVC.tagTblView.reloadData()
    }
    
    @IBAction func clickToState(_ sender: UIButton) {
        self.view.endEditing(true)
        if countryId != "" {
            if STATE_ARRAY.count == 0
            {
                loadStateFromCountry()
            }
            displaySubViewtoParentView(self.view, subview: SelectCountryVC)
            SelectCountryVC.index = 2
            SelectCountryVC.arrData = STATE_ARRAY
            SelectCountryVC.isSearch = false
            SelectCountryVC.tagTblView.reloadData()
            SelectCountryVC.setup()
            self.view.addSubview(SelectCountryVC)
        }
        else {
            displayToast(NSLocalizedString("select_country", comment: ""))
        }
        
    }
    
    @IBAction func clickToCity(_ sender: UIButton) {
        self.view.endEditing(true)
        if stateId != "" {
            if CITY_ARRAY.count == 0
            {
                loadCityFromState()
            }
            displaySubViewtoParentView(self.view, subview: SelectCountryVC)
            SelectCountryVC.index = 3
            SelectCountryVC.arrData = CITY_ARRAY
            SelectCountryVC.isSearch = false
            SelectCountryVC.tagTblView.reloadData()
            SelectCountryVC.setup()
            
        }
        else {
            displayToast("Select State")
        }
    }
    
    func loadStateFromCountry()
    {
        stateTxt.text = ""
        cityTxt.text = ""
        let url = Bundle.main.url(forResource: "states", withExtension: "json")!
        do {
            STATE_ARRAY = []
            AppModel.shared.STATE = [StateModel]()
            let jsonData = try Data(contentsOf: url)
            let json = try JSONSerialization.jsonObject(with: jsonData) as! [String:Any]
            print(json)
            
            let states = json["states"] as! [[String:Any]]
            
            for item in states {
                let state = StateModel.init(dict: item)
                if state.country_id == countryId {
                    AppModel.shared.STATE.append(StateModel.init(dict: item))
                    STATE_ARRAY.append(item["name"] as! String)
                }
            }
        }
        catch {
            print(error)
        }
    }
    
    func loadCityFromState()
    {
        let url = Bundle.main.url(forResource: "cities", withExtension: "json")!
        do {
            CITY_ARRAY = []
            AppModel.shared.CITY = [CityModel]()
            let jsonData = try Data(contentsOf: url)
            let json = try JSONSerialization.jsonObject(with: jsonData) as! [String:Any]
            print(json)
            
            let cities = json["cities"] as! [[String:Any]]
            
            for item in cities {
                let state = CityModel.init(dict: item)
                if state.state_id == String(stateId) {
                    AppModel.shared.CITY.append(CityModel.init(dict: item))
                    CITY_ARRAY.append(item["name"] as! String)
                }
            }
        }
        catch {
            print(error)
        }
    }
    
    func getSelectedCountryStateArray(_ selectedData: String, _ tagIndex: Int) {
        if tagIndex == 1 {
            countryTxt.text = selectedData
            let index = AppModel.shared.COUNTRY.index { (temp) -> Bool in
                temp.name == selectedData
            }
            if index != nil
            {
                countryId = AppModel.shared.COUNTRY[index!].id
            }
            delay(0.1, closure: {
                self.loadStateFromCountry()
            })
        }else if tagIndex == 2 {
            stateTxt.text = selectedData
            let index = AppModel.shared.STATE.index { (temp) -> Bool in
                temp.name == selectedData
            }
            if index != nil
            {
                stateId = AppModel.shared.STATE[index!].id
            }
            
            delay(0.1, closure: {
                self.loadCityFromState()
            })
        }else {
            cityTxt.text = selectedData
            let index = AppModel.shared.CITY.index { (temp) -> Bool in
                temp.name == selectedData
            }
            if index != nil
            {
                cityId = AppModel.shared.CITY[index!].id
            }
        }
    }
    
    @IBAction func clickToGender(_ sender: UIButton) {
        self.view.endEditing(true)
        resetGenderButton()
        sender.isSelected = true
    }
    
    func resetGenderButton()
    {
        maleBtn.isSelected = false
        femaleBtn.isSelected = false
        otherBtn.isSelected = false
    }
    
    @IBAction func clickToAdd(_ sender: Any) {
        self.view.endEditing(true)
        tagVC.selectedArr = favouriteArr
        tagVC.tagIndex = 0
        displaySubViewtoParentView(self.view, subview: tagVC)
        tagVC.setup()
        self.view.addSubview(tagVC)
    }
    
    @IBAction func clickToAddTags(_ sender: Any) {
        self.view.endEditing(true)
        tagVC.selectedArr = selectedTag
        tagVC.tagIndex = 1
        displaySubViewtoParentView(self.view, subview: tagVC)
        tagVC.setup()
        self.view.addSubview(tagVC)
    }
    
    @IBAction func clickToBack(_ sender: Any) {
        self.view.endEditing(true)
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func clickToCreate(_ sender: Any) {
        self.view.endEditing(true)
        if nameTxt.text?.trimmed.count == 0
        {
            displayToast(NSLocalizedString("enter_name", comment: ""))
        }
        else  if dOBLbl.text?.trimmed.count == 0
        {
            displayToast(NSLocalizedString("enter_date", comment: ""))
        }
        else  if headlineTxt.text?.trimmed.count == 0
        {
            displayToast(NSLocalizedString("enter_headlines", comment: ""))
        }
        else  if bioTxt.text?.trimmed.count == 0
        {
            displayToast(NSLocalizedString("enter_bio", comment: ""))
        }
        else  if priceTxt.text?.trimmed.count == 0
        {
            displayToast(NSLocalizedString("enter_price", comment: ""))
        }
        else if favouriteArr.count == 0 {
            displayToast(NSLocalizedString("enter_genres", comment: ""))
        }
        else  if countryTxt.text?.trimmed.count == 0
        {
            displayToast(NSLocalizedString("enter_country", comment: ""))
        }
        else  if stateTxt.text?.trimmed.count == 0
        {
            displayToast(NSLocalizedString("enter_state", comment: ""))
        }
        else  if cityTxt.text?.trimmed.count == 0
        {
            displayToast(NSLocalizedString("enter_city", comment: ""))
        }
        else if selectedTag.count == 0 {
            displayToast(NSLocalizedString("enter_tag", comment: ""))
        }
        else if profileImg == nil
        {
            displayToast(NSLocalizedString("select_image", comment: ""))
        }
        else
        {
            var param : [String : Any] = [String : Any]()
            
            param["display_name"] = nameTxt.text
            
            if maleBtn.isSelected {
                param["gender"] = "male"
            }
            else if femaleBtn.isSelected {
                param["gender"] = "female"
            }
            else if otherBtn.isSelected {
                param["gender"] = "other"
            }
            param["date_of_birth"] = dOBLbl.text
            
            param["headline"] = headlineTxt.text
            param["bio"] = bioTxt.text
            param["price"] = priceTxt.text
            param["favorite_genres"] = favouriteArr.joined(separator: ",")
            param["country"] = countryTxt.text
            param["state"] = stateTxt.text
            param["city"] = cityTxt.text
            param["tags"] = selectedTag.joined(separator: ",")
            
            if let imageData = UIImageJPEGRepresentation(profileImg!, 1) {
                imgData = imageData
            }

            APIManager.shared.serviceCallToBecomeListner(imgData, param) {
                if self.screenType == 0
                {
                    AppDelegate().sharedDelegate().navigateToDashBoard()
                }
                else if self.screenType == 1 || self.screenType == 2
                {
                    AppDelegate().sharedDelegate().getLoginUserDetail()
                    AppDelegate().sharedDelegate().getAllRequiredDataAfterLogin()
                    
                    for controller in self.navigationController!.viewControllers as Array {
                        if controller.isKind(of: (self.screenType == 1 ? GiveFeedbackVC.self : UploadMusicVC.self)) {
                            self.navigationController!.popToViewController(controller, animated: true)
                            return
                        }
                    }
                    AppDelegate().sharedDelegate().navigateToDashBoard()
                }
            }
            
        }
    }
    
    //MARK:- Textfield Delegate method
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        if textField == nameTxt
        {
            headlineTxt.becomeFirstResponder()
        }
        else if textField == headlineTxt
        {
            bioTxt.becomeFirstResponder()
        }
        else if textField == bioTxt
        {
            priceTxt.becomeFirstResponder()
        }
        else if textField == priceTxt
        {
            priceTxt.resignFirstResponder()
        }
        
        return true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }

}
