//
//  EditProfileVC.swift
//  HearBK
//
//  Created by PC on 31/01/19.
//  Copyright © 2019 PC. All rights reserved.
//

import UIKit
import DropDown

class EditProfileVC: UploadImageVC, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UITableViewDelegate, UITableViewDataSource, selectedTagDelegate, UITextFieldDelegate , selectedCountryStateDelegate, TagListViewDelegate {
    
   
    @IBOutlet var containerView: UIView!
    @IBOutlet var containerViewHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet var personalBackView: UIView!
    
    @IBOutlet var experienceBackView: UIView!
    
    @IBOutlet var proPersonalLineView: UIView!
    @IBOutlet var proExperienceLineView: UIView!
    @IBOutlet var personalBtn: Button!
    @IBOutlet var experienceBtn: Button!
    
    @IBOutlet var profileBtn: Button!
    @IBOutlet var nameTxt: TextField!
    
    @IBOutlet var maleBtn: Button!
    @IBOutlet var femaleBtn: Button!
    @IBOutlet var otherBtn: Button!
    @IBOutlet var dOBLbl: Label!

    @IBOutlet var headlineTxt: TextField!
    @IBOutlet var bioTxt: TextField!
    @IBOutlet var priceTxt: TextField!
    @IBOutlet var favouriteArtistTxt: TextField!
    @IBOutlet var countryTxt: TextField!
    @IBOutlet var stateTxt: TextField!
    @IBOutlet var cityTxt: TextField!
    
    @IBOutlet var positionTxt: TextField!
    @IBOutlet var companyTxt: TextField!
    @IBOutlet var fromDateTxt: TextField!
    @IBOutlet var toDateTxt: TextField!
    
    @IBOutlet weak var favoriteArtistTagView: TagListView!
    @IBOutlet weak var constraintHeightFavoriteArtistTagView: NSLayoutConstraint!
    
    
    @IBOutlet weak var favoriteGenrseTagView: TagListView!
    @IBOutlet weak var constraintHeightFavoriteGenrseTagView: NSLayoutConstraint!
    
    @IBOutlet weak var userTagView: TagListView!
    @IBOutlet weak var constraintHeightUserTagView: NSLayoutConstraint!
    
    @IBOutlet var musicAffiliationCollectionView: UICollectionView!
    @IBOutlet var musicAffiliationCollectionViewHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet var experienceTblView: UITableView!
    @IBOutlet var experienceTblViewHeightConstraint: NSLayoutConstraint!
    
    
    var COUNTRY_ARRAY : [String] = AppDelegate().sharedDelegate().getCountryList()
    var STATE_ARRAY : [String] = [String]()
    var CITY_ARRAY:[String] = []
    
    var countryId : String = ""
    var stateId:String = ""
    var cityId:String = ""
    var selectedDate : Date!
    
    var MusicAffArr : [String] = [String]()
    var MusicAffSelectionArr : [String] = [String]()
    
    let tagVC : TagSelectedView = TagSelectedView.instanceFromNib() as! TagSelectedView
    let SelectCountryVC : SelectionCountryView = SelectionCountryView.instanceFromNib() as! SelectionCountryView
    
    var ExperienceArr : [[String:Any]] = [[String:Any]]()
    
    var profileImg : UIImage?
    var imgData : Data = Data()
    
    var isPofileChange : Bool = false
    var isExperienceChange : Bool = false
    
    var tabType : Int = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        musicAffiliationCollectionView.register(UINib(nibName: "TagCVC", bundle: nil), forCellWithReuseIdentifier: "TagCVC")
        experienceTblView.register(UINib(nibName: "ExperienceTVC", bundle: nil), forCellReuseIdentifier: "ExperienceTVC")
        
        tagVC.delegate = self
        SelectCountryVC.delegate = self
    
        
        refereshView()
        personalBtn.setTitleColor(WhiteColor, for: .normal)
        proPersonalLineView.backgroundColor = GreenColor
       
        MusicAffArr = ["ASCAP", "SESAC", "SACE"]
        
        setPersonalDetail()
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let tabBar : CustomTabBarController = self.tabBarController as! CustomTabBarController
        if tabBarController != nil
        {
            tabBar.setTabBarHidden(tabBarHidden: true)
            self.extendedLayoutIncludesOpaqueBars = true
            edgesForExtendedLayout = UIRectEdge.bottom
        }
    }
    
    //MARK:- Set User Data
    func setPersonalDetail() {
        print(AppModel.shared.currentUser.dictionary())
        
        AppDelegate().sharedDelegate().setUserBackgroundImage(profileBtn, AppModel.shared.currentUser.avatar)
        nameTxt.text = AppModel.shared.currentUser.display_name
        if AppModel.shared.currentUser.gender != ""
        {
            if AppModel.shared.currentUser.gender.lowercased() == "male" {
                maleBtn.isSelected = true
            }
            else if AppModel.shared.currentUser.gender.lowercased() == "female" {
                femaleBtn.isSelected = true
            }
            else {
                otherBtn.isSelected = true
            }
        }
        else
        {
            maleBtn.isSelected = false
            femaleBtn.isSelected = false
            otherBtn.isSelected = false
        }
        
        dOBLbl.text = AppModel.shared.currentUser.dob
        headlineTxt.text = AppModel.shared.currentUser.headline
        bioTxt.text = AppModel.shared.currentUser.bio
        priceTxt.text = String(AppModel.shared.currentUser.price)
        
        favoriteArtistTagView.removeAllTags()
        if AppModel.shared.currentUser.insight.favorite_artists != ""
        {
            favoriteArtistTagView.addTags(AppModel.shared.currentUser.insight.favorite_artists.components(separatedBy: ","))
        }
        else
        {
            constraintHeightFavoriteArtistTagView.constant = 0
        }
        
        favoriteGenrseTagView.removeAllTags()
        if AppModel.shared.currentUser.insight.favorite_genres != ""
        {
            favoriteGenrseTagView.addTags(AppModel.shared.currentUser.insight.favorite_genres.components(separatedBy: ","))
        }
        else
        {
            constraintHeightFavoriteGenrseTagView.constant = 0
        }
        
        countryTxt.text = AppModel.shared.currentUser.country
        stateTxt.text = AppModel.shared.currentUser.state
        cityTxt.text = AppModel.shared.currentUser.city
        
        userTagView.removeAllTags()
        if AppModel.shared.currentUser.tag != ""
        {
            userTagView.addTags(AppModel.shared.currentUser.tag.components(separatedBy: ","))
        }
        else
        {
            constraintHeightUserTagView.constant = 0
        }
        
        if AppModel.shared.currentUser.insight.music_affiliations != ""
        {
            MusicAffSelectionArr = AppModel.shared.currentUser.insight.music_affiliations.components(separatedBy: ",")
        }
        else
        {
            MusicAffSelectionArr = [String]()
        }
        musicAffiliationCollectionView.reloadData()
        
        clickToPersonal(self)
    }
    
    //MARK:- Tag Delegate method
    func getSelectedTagArray(_ selectedData: [String], _ tagIndex: Int) {
        if tagIndex == 1 {
            userTagView.removeAllTags()
            userTagView.addTags(selectedData)
            setPersonalViewHeight()
        }else {
            favoriteGenrseTagView.removeAllTags()
            favoriteGenrseTagView.addTags(selectedData)
            setPersonalViewHeight()
        }
    }
    
    //MARK:- Remove Tag method
    func tagRemoveButtonPressed(_ title: String, tagView: TagView, sender: TagListView) {
        if sender == favoriteArtistTagView
        {
            favoriteArtistTagView.removeTag(title)
        }
        else if sender == favoriteGenrseTagView
        {
            favoriteGenrseTagView.removeTag(title)
        }
        else if sender == userTagView
        {
            userTagView.removeTag(title)
        }
        setPersonalViewHeight()
    }
    
    //MARK: - TableView Delegate
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ExperienceArr.count
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 92
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = experienceTblView.dequeueReusableCell(withIdentifier: "ExperienceTVC", for: indexPath) as! ExperienceTVC
        let dict : [String : Any] = ExperienceArr[indexPath.row]
        
        cell.positionLbl.text = dict["position"] as? String
        cell.companyNameLbl.text = dict["company"] as? String
        if dict["fromDate"] as! String == dict["toDate"] as! String  {
            cell.dateLbl.text = "\(dict["fromDate"]!) - Present"
        } else {
            cell.dateLbl.text = "\(dict["fromDate"]!) - \(dict["toDate"]!)"
        }
        cell.cancelBtn.tag = indexPath.row
        cell.cancelBtn.addTarget(self, action: #selector(clickTocancelExperience(sender:)), for: .touchUpInside)
        setExperienceViewHeight()
        return cell
    }
    
    //MARK:- TableView Button Click
    @objc func clickTocancelExperience(sender : UIButton) {
        ExperienceArr.remove(at: sender.tag)
        if ExperienceArr.count == 0 {
            experienceTblViewHeightConstraint.constant = 2
        }
        
        var param : [String : Any] = [String : Any]()
        param["data"] = ExperienceArr
        param["user_id"] = ""
        APIManager.shared.serviceCallToMyProfileExperience(param) {
            
        }
        
        experienceTblView.reloadData()
    }
    
    //MARK: - CollectionView Delegate
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return MusicAffArr.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = musicAffiliationCollectionView.dequeueReusableCell(withReuseIdentifier: "TagCVC", for: indexPath) as! TagCVC
        
        let index = MusicAffSelectionArr.index { (temp) -> Bool in
            temp == MusicAffArr[indexPath.row]
        }
        if index != nil {
            cell.backView.layer.backgroundColor = GreenColor.cgColor
            cell.tagLbl.textColor = ScreenBackGroundColor
        } else {
            cell.backView.layer.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0.196990537)
            cell.tagLbl.textColor = WhiteColor
        }
        cell.tagLbl.text = MusicAffArr[indexPath.row]
        cell.cancelBtnWidthConstraint.constant = 0
        
        setPersonalViewHeight()
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let index = MusicAffSelectionArr.index { (temp) -> Bool in
            temp == MusicAffArr[indexPath.row]
        }
        if index != nil {
            MusicAffSelectionArr.remove(at: index!)
        }else {
            MusicAffSelectionArr.append(MusicAffArr[indexPath.row])
        }
        musicAffiliationCollectionView.reloadData()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let label = UILabel(frame: CGRect.zero)
        label.text = MusicAffArr[indexPath.row]
        label.sizeToFit()
        return CGSize(width: label.frame.width + 20, height: 40)
    }
    
    //MARK:- Button Click
    @IBAction func clickToPersonal(_ sender: Any) {
        if isExperienceChange
        {
            showAlertWithOption("", message: "Are you want to save changes?", btns: ["Yes", "No"], completionConfirm: {
                self.updateExperienceDetail(false)
            }) {
                self.isExperienceChange = false
                self.showPersonalView()
            }
        }
        else
        {
            showPersonalView()
        }
    }
    
    @IBAction func clickToExperience(_ sender: Any) {
        if isPofileChange
        {
            showAlertWithOption("", message: "Are you want to save changes?", btns: ["Yes", "No"], completionConfirm: {
                self.updatePersonalDetail(false)
            }) {
                self.isPofileChange = false
                self.setPersonalDetail()
                self.showExperienceView()
            }

        }
        else
        {
            showExperienceView()
        }
    }
    
    func showPersonalView()
    {
        refereshView()
        tabType = 1
        proPersonalLineView.backgroundColor = GreenColor
        personalBackView.isHidden = false
        experienceBackView.isHidden = true
        personalBtn.setTitleColor(WhiteColor, for: .normal)
        displaySubViewtoParentView(containerView, subview: personalBackView)
        setPersonalViewHeight()
    }
    
    func showExperienceView()
    {
        refereshView()
        tabType = 2
        proExperienceLineView.backgroundColor = GreenColor
        personalBackView.isHidden = true
        experienceBackView.isHidden = false
        experienceBtn.setTitleColor(WhiteColor, for: .normal)
        experienceTblView.reloadData()
        displaySubViewtoParentView(containerView, subview: experienceBackView)
        setExperienceViewHeight()
    }
    
    func refereshView()  {
        proPersonalLineView.backgroundColor = ClearColor
        proExperienceLineView.backgroundColor = ClearColor
        
        personalBtn.setTitleColor(LightGrayColor, for: .normal)
        experienceBtn.setTitleColor(LightGrayColor, for: .normal)
    }
    
    @IBAction func clickToProfileBtn(_ sender: Any) {
        self.view.endEditing(true)
        uploadImage()
    }
    
    override func selectedImage(choosenImage: UIImage) {
        isPofileChange = true
        profileBtn.setImage(choosenImage, for: .normal)
        profileBtn.imageView?.contentMode = .scaleAspectFill
        profileImg = choosenImage
    }
    
    @objc func clickToCancelAffiliation (_ sender  : UIButton) {
        self.view.endEditing(true)
        isPofileChange = true
        let index = MusicAffArr.index(where: { (temp) -> Bool in
            temp == MusicAffArr[sender.tag]
        })
        if index != nil {
            MusicAffArr.remove(at: index!)
            if MusicAffArr.count == 0 {
                musicAffiliationCollectionViewHeightConstraint.constant = 2
            }
        }
        musicAffiliationCollectionView.reloadData()
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
    
    @IBAction func clickToBack(_ sender: Any) {
        self.view.endEditing(true)
        
        if isPofileChange
        {
            showAlertWithOption("", message: "Are you want to save changes?", btns: ["Yes", "No"], completionConfirm: {
                self.updatePersonalDetail(true)
            }) {
                self.navigationController?.popViewController(animated: true)
            }
        }
        else if isExperienceChange
        {
            showAlertWithOption("", message: "Are you want to save changes?", btns: ["Yes", "No"], completionConfirm: {
                self.updateExperienceDetail(true)
                return
            }) {
                self.navigationController?.popViewController(animated: true)
            }
        }
        else
        {
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    @IBAction func clickToDone(_ sender: Any) {
        self.view.endEditing(true)
        if tabType == 1
        {
            updatePersonalDetail(true)
        }
        else if tabType == 2
        {
            updateExperienceDetail(true)
        }
    }
    
    func checkPersonalDetailValidation() -> Bool
    {
        if nameTxt.text?.trimmed.count == 0
        {
            displayToast(NSLocalizedString("enter_name", comment: ""))
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
        else if favoriteArtistTagView.getAllTag().count == 0 {
            displayToast(NSLocalizedString("enter_artist", comment: ""))
        }
        else if favoriteGenrseTagView.getAllTag().count == 0 {
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
        else if userTagView.getAllTag().count == 0 {
            displayToast(NSLocalizedString("enter_tag", comment: ""))
        }
        else if MusicAffSelectionArr.count == 0 {
            displayToast(NSLocalizedString("enter_afference", comment: ""))
        }
        else
        {
            return true
        }
        return false
    }
    
    func updatePersonalDetail(_ isBack : Bool)
    {
        if isPofileChange
        {
            if checkPersonalDetailValidation()
            {
                isPofileChange = false
                
                var param : [String : Any] = [String : Any]()
                param["display_name"] = nameTxt.text
                param["headline"] = headlineTxt.text
                param["bio"] = bioTxt.text
                param["price"] = priceTxt.text
                param["favorite_genres"] = favoriteGenrseTagView.getAllTag().joined(separator: ",")
                param["country"] = countryTxt.text
                param["state"] = stateTxt.text
                param["city"] = cityTxt.text
                param["tags"] = userTagView.getAllTag().joined(separator: ",")
                param["favorite_artists"] = favoriteArtistTagView.getAllTag().joined(separator: ",")
                param["music_affiliations"] = MusicAffSelectionArr.joined(separator: ",")
                print(param)
                if profileImg != nil {
                    if let imageData = UIImageJPEGRepresentation(profileImg!, 1) {
                        imgData = imageData
                    }
                }
                
                APIManager.shared.serviceCallToUpdateUserDetail(imgData, param) {
                    AppDelegate().sharedDelegate().getLoginUserDetail()
                    if isBack
                    {
                        self.navigationController?.popViewController(animated: true)
                    }
                    else
                    {
                        self.showExperienceView()
                    }
                }
            }
        }
        else
        {
            if isBack
            {
                self.navigationController?.popViewController(animated: true)
            }
            else
            {
                self.showExperienceView()
            }
        }
    }
    
    func updateExperienceDetail(_ isBack : Bool)
    {
        if isExperienceChange
        {
            if ExperienceArr.count == 0 {
                displayToast(NSLocalizedString("enter_experience", comment: ""))
            }
            else
            {
                isExperienceChange = false
                var param : [String : Any] = [String : Any]()
                param["data"] = self.ExperienceArr
                param["user_id"] = ""
                APIManager.shared.serviceCallToMyProfileExperience(param) {
                    AppDelegate().sharedDelegate().getProfileAboutData()
                    if isBack
                    {
                        self.navigationController?.popViewController(animated: true)
                    }
                    else
                    {
                        self.showPersonalView()
                    }
                }
            }
        }
        else
        {
            if isBack
            {
                self.navigationController?.popViewController(animated: true)
            }
            else
            {
                self.showExperienceView()
            }
        }
    }
    
    @IBAction func clickToAddArtist(_ sender: Any) {
        self.view.endEditing(true)
        if favouriteArtistTxt.text != "" {
            
            favoriteArtistTagView.addTag(favouriteArtistTxt.text!)
            constraintHeightFavoriteArtistTagView.constant = favoriteArtistTagView.intrinsicContentSize.height
            favouriteArtistTxt.text = ""
        }
        isPofileChange = true
    }
    
    @IBAction func clickToAddGenres(_ sender: Any) {
        self.view.endEditing(true)
        tagVC.selectedArr = favoriteGenrseTagView.getAllTag()
        tagVC.tagIndex = 0
        displaySubViewtoParentView(self.view, subview: tagVC)
        tagVC.setup()
        self.view.addSubview(tagVC)
        isPofileChange = true
    }
    
    @IBAction func clickToAddTags(_ sender: Any) {
        self.view.endEditing(true)
        tagVC.selectedArr = userTagView.getAllTag()
        tagVC.tagIndex = 1
        displaySubViewtoParentView(self.view, subview: tagVC)
        tagVC.setup()
        self.view.addSubview(tagVC)
        isPofileChange = true
    }
    
    @IBAction func clickToAddExperience(_ sender: Any) {
        if positionTxt.text?.trimmed.count == 0 {
            displayToast("Please enter position")
        }
        else if companyTxt.text?.trimmed.count == 0 {
            displayToast("Please enter company name")
        }
        else if fromDateTxt.text?.trimmed.count == 0 {
            displayToast("Please enter date")
        }
        else if toDateTxt.text?.trimmed.count == 0 {
            displayToast("Please enter date")
        }
        else {
            var experienceDict : [String : Any] = [String : Any]()
            experienceDict["position"] = positionTxt.text
            experienceDict["company"] = companyTxt.text
            experienceDict["fromDate"] = fromDateTxt.text
            experienceDict["toDate"] = toDateTxt.text
            ExperienceArr.append(experienceDict)
            
            var param : [String : Any] = [String : Any]()
            param["data"] = ExperienceArr
            
            self.experienceTblView.reloadData()
            self.experienceTblViewHeightConstraint.constant = self.experienceTblView.contentSize.height
            
            self.positionTxt.text = ""
            self.companyTxt.text = ""
            self.fromDateTxt.text = ""
            self.toDateTxt.text = ""
            isExperienceChange = true
        }
    }
    
    @IBAction func clickToFromBtn(_ sender: Any) {
        self.view.endEditing(true)
        isPofileChange = true
        if selectedDate == nil
        {
            selectedDate = Date()
        }
        let maxDate : Date = Calendar.current.date(byAdding: .day, value: -1, to: Date())!
        DatePickerManager.shared.showPicker(title: "select_dob", selected: selectedDate, min: nil, max: maxDate) { (date, cancel) in
            if !cancel && date != nil {
                self.selectedDate = date!
                
          //      let components : DateComponents = Calendar.current.dateComponents([.year,.month,.day], from: self.selectedDate)
                self.fromDateTxt.text = getDateStringFromDate(date: self.selectedDate, format: "MMM yyyy")
               // self.fromDateTxt.text = String(components.year!) + "/" + String(components.month!)
                
                // self.dobBtn.setTitle(getDateStringFromDate(date: self.selectedDate), for: .normal)
            }
        }
    }
    
    @IBAction func clickToToBtn(_ sender: Any) {
        self.view.endEditing(true)
        isPofileChange = true
        if selectedDate == nil
        {
            selectedDate = Date()
        }
        //let maxDate : Date = Calendar.current.date(byAdding: .day, value: -1, to: Date())!
        DatePickerManager.shared.showPicker(title: "select_dob", selected: selectedDate, min: nil, max: Date()) { (date, cancel) in
            if !cancel && date != nil {
                self.selectedDate = date!
                
           //   let components : DateComponents = Calendar.current.dateComponents([.year,.month,.day], from: self.selectedDate)
                self.toDateTxt.text = getDateStringFromDate(date: self.selectedDate, format: "MMM yyyy")
           //   self.toDateTxt.text = String(components.year!) + "/" + String(components.month!)
                
                // self.dobBtn.setTitle(getDateStringFromDate(date: self.selectedDate), for: .normal)
            }
        }
    }
  
    //MARK:- Get Country state city Method
    func loadStateFromCountry()
    {
        stateTxt.text = ""
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
    
    //MARK:- Country state city Delegate
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
        isPofileChange = true
    }
    
    //MARK: - Textfield delegate
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
        isPofileChange = true
        return true
    }

    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == nameTxt || textField == headlineTxt || textField == bioTxt || textField == priceTxt
        {
            isPofileChange = true
        }
        else
        {
            isExperienceChange = true
        }
    }
    
    //MARK:- Set Height
    func setPersonalViewHeight()
    {
        constraintHeightFavoriteArtistTagView.constant = favoriteArtistTagView.intrinsicContentSize.height
        constraintHeightFavoriteGenrseTagView.constant = favoriteGenrseTagView.intrinsicContentSize.height
        constraintHeightUserTagView.constant = userTagView.intrinsicContentSize.height
        musicAffiliationCollectionViewHeightConstraint.constant = musicAffiliationCollectionView.contentSize.height
        
        containerViewHeightConstraint.constant = 1150 + constraintHeightFavoriteArtistTagView.constant + constraintHeightFavoriteGenrseTagView.constant + constraintHeightUserTagView.constant + musicAffiliationCollectionViewHeightConstraint.constant
    }
    
    func setExperienceViewHeight()
    {
        experienceTblViewHeightConstraint.constant = experienceTblView.contentSize.height
        containerViewHeightConstraint.constant = experienceTblViewHeightConstraint.constant + 340
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    

}
