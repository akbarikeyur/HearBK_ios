//
//  SearchforListnerVC.swift
//  HearBK
//
//  Created by PC on 02/02/19.
//  Copyright © 2019 PC. All rights reserved.
//

import UIKit
import DropDown
import ZMSwiftRangeSlider

class SearchforListnerVC: UIViewController , UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UITableViewDelegate, UITableViewDataSource, selectedTagDelegate, UITextFieldDelegate, selectedCountryStateDelegate {
    
    @IBOutlet var listnerBackView: View!
    @IBOutlet weak var searchTxt: TextField!
    
    @IBOutlet var selectedCollectionView: UICollectionView!
    @IBOutlet var selectedCollectionViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet var listnerTblView: UITableView!
    
    @IBOutlet var containerView: UIView!
    @IBOutlet var containerViewHeightConstraint: NSLayoutConstraint!
    
    
    @IBOutlet var filterBackView: View!
    @IBOutlet var filterScrollView: UIScrollView!
    @IBOutlet var filterBtn: UIButton!
    
    @IBOutlet var favouriteArtistCollectionView: UICollectionView!
    @IBOutlet var favouriteArtistCollectioViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet var favouriteGenrseCollectionView: UICollectionView!
    @IBOutlet var favouriteGenrseCollectioViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet var tagCollectionView: UICollectionView!
    @IBOutlet var tagcollectionViewHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet var maleBtn: Button!
    @IBOutlet var femaleBtn: Button!
    @IBOutlet var otherBtn: Button!
    @IBOutlet var countryTxt: TextField!
    @IBOutlet var stateTxt: TextField!
    @IBOutlet var cityTxt: TextField!
    @IBOutlet var favoriteArtistTxt: TextField!
    
    @IBOutlet weak var rangeSlider: RangeSlider!
    @IBOutlet weak var minLbl: UILabel!
    @IBOutlet weak var maxLbl: UILabel!
    
    @IBOutlet var doneBtn: Button!
    
    var COUNTRY_ARRAY : [String] = AppDelegate().sharedDelegate().getCountryList()
    var STATE_ARRAY : [String] = [String]()
    var CITY_ARRAY:[String] = []
    
    var countryId : String = ""
    var stateId:String = ""
    var cityId:String = ""
    
    var selectedDate : Date!
    
    var FavouriteArtistArr : [String] = [String]()
    var FavouriteGenresArr : [String] = [String]()
    var selectedTag : [String] = [String]()
    let tagVC : TagSelectedView = TagSelectedView.instanceFromNib() as! TagSelectedView
    let SelectCountryVC : SelectionCountryView = SelectionCountryView.instanceFromNib() as! SelectionCountryView
    
    var type1 : Int = 0
    
    var arrUserData : [UserModel] = [UserModel]()
    var selectedUser : [UserModel] = [UserModel]()
    var searchTimer : Timer? = nil
    
    var page : Int = 1
    var totalPage : Int = 1
    var isFilterData : Bool = false
    var flag : Bool = true
    
    var refreshControl : UIRefreshControl = UIRefreshControl()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tagCollectionView.register(UINib(nibName: "TagCVC", bundle: nil), forCellWithReuseIdentifier: "TagCVC")
        favouriteArtistCollectionView.register(UINib(nibName: "TagCVC", bundle: nil), forCellWithReuseIdentifier: "TagCVC")
        favouriteGenrseCollectionView.register(UINib(nibName: "TagCVC", bundle: nil), forCellWithReuseIdentifier: "TagCVC")
        
        listnerTblView.register(UINib(nibName: "ListnerTVC", bundle: nil), forCellReuseIdentifier: "ListnerTVC")
        selectedCollectionView.register(UINib(nibName: "SelectedUserCVC", bundle: nil), forCellWithReuseIdentifier: "SelectedUserCVC")
        
        NotificationCenter.default.addObserver(self, selector: #selector(updateUserDetail), name: NSNotification.Name.init(NOTIFICATION.SELECTED_LISTENER), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(addToSelectedListner(noti:)), name: NSNotification.Name.init(NOTIFICATION.REDIRECT_SERCHFOR_LISNER), object: nil)
        
        
        searchTxt.addTarget(self, action: #selector(textFieldChange(textField:)), for: .editingChanged)
        
        maleBtn.isSelected = true
        tagVC.delegate = self
        SelectCountryVC.delegate = self
        
        rangeSlider.setValueChangedCallback { (minValue, maxValue) in
            self.minLbl.text = String(minValue)
            self.maxLbl.text = String(maxValue)
        }
        rangeSlider.setMinAndMaxValue(0, maxValue: 100)
        minLbl.text = "0"
        maxLbl.text = "100"
        
        refreshControl.tintColor = GreenColor
        refreshControl.addTarget(self, action: #selector(refreshUserData), for: .valueChanged)
        if #available(iOS 10.0, *) {
            listnerTblView.refreshControl = refreshControl
        } else {
            listnerTblView.addSubview(refreshControl)
        }
        refreshUserData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if tabBarController != nil
        {
            let tabBar : CustomTabBarController = self.tabBarController as! CustomTabBarController
            tabBar.setTabBarHidden(tabBarHidden: true)
            self.extendedLayoutIncludesOpaqueBars = true
            edgesForExtendedLayout = UIRectEdge.bottom
        }
        if type1 == 0 {
            doneBtn.setTitle("Next", for: .normal)
            listnerTblView.reloadData()
        } else {
            doneBtn.setTitle("Done", for: .normal)
            selectedCollectionView.reloadData()
            listnerTblView.reloadData()
        }
    }
    
    //MARK:- Refresh listener data
    @objc func refreshUserData()
    {
        refreshControl.endRefreshing()
        page = 1
        serviceCallToSearchListener()
    }
    
    //MARK:- Handle Brodcast
    @objc func updateUserDetail(notification: NSNotification) {
        let dict = notification.object as! [UserModel]
        selectedUser = dict
        selectedCollectionView.reloadData()
        listnerTblView.reloadData()
    }
    
    @objc func addToSelectedListner(noti : Notification)  {
        let dict = noti.object as! UserModel
        
        let index = selectedUser.firstIndex { (temp) -> Bool in
            temp.uId == dict.uId
        }
        if index == nil
        {
            selectedUser.append(dict)
        }
        else
        {
            selectedUser.remove(at: index!)
        }
        selectedCollectionView.reloadData()
        listnerTblView.reloadData()
    }
    
    //MARK:- Tag Selection Delegate
    func getSelectedTagArray(_ selectedData: [String], _ tagIndex: Int) {
        if tagIndex == 1 {
            selectedTag = selectedData
            tagCollectionView.reloadData()
        }else {
            FavouriteGenresArr = selectedData
            favouriteGenrseCollectionView.reloadData()
        }
    }
    
    //MARK: - TableView Delegate
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrUserData.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = listnerTblView.dequeueReusableCell(withIdentifier: "ListnerTVC", for: indexPath) as! ListnerTVC
        
        let user : UserModel = arrUserData[indexPath.row]
        AppDelegate().sharedDelegate().setUserBackgroundImage(cell.profilImgBtn, user.avatar)
        cell.nameLbl.text = user.display_name
        cell.headlineLbl.text = user.headline
        cell.descriptionLbl.text = user.bio
        cell.priceLbl.text = displayPriceWithCurrency(user.price)
        cell.selectbtn.tag = indexPath.row
        
        cell.rateView.rating = user.rating_as_listener
        cell.rateLbl.text = setFlotingRating(user.rating_as_listener)
        
        let index = selectedUser.index(where: { (temp) -> Bool in
            temp.uId == user.uId
        })
        if index != nil {
            cell.selectbtn.isSelected = true
        }else {
            cell.selectbtn.isSelected = false
        }
        
        if user.verify == 0
        {
            cell.verifyBtn.isHidden = true
        }
        else
        {
            cell.verifyBtn.isHidden = false
        }
        
        let index1 = AppModel.shared.MyFavoriteUserArr.index(where: { (temp) -> Bool in
            temp.uId == user.uId
        })
        if index1 != nil {
            cell.FavoriteBtn.isSelected = true
        }else {
            cell.FavoriteBtn.isSelected = false
        }
        cell.FavoriteBtn.tag = indexPath.row
        cell.FavoriteBtn.addTarget(self, action: #selector(self.clickToFavoriteBtn(_:)), for: .touchUpInside)
        cell.selectbtn.addTarget(self, action: #selector(self.clickToAddUser), for: .touchUpInside)
      
        if cell.tagView.tagViews.count > 0
        {
            cell.tagView.removeAllTags()
        }
        
        if user.tag != ""
        {
            let tagArr : [String] = user.tag.components(separatedBy: ",")
            
            if tagArr.count > 0
            {
                cell.tagView.addTag(tagArr[0])
                if tagArr.count > 1
                {
                    cell.tagView.addTag(tagArr[1])
                    
                    if tagArr.count > 2
                    {
                        if tagArr.count == 3
                        {
                            cell.tagView.addTag(tagArr[2])
                        }
                        else
                        {
                            cell.tagView.addTag(("+" + String(tagArr.count-2)))
                        }
                    }
                }
            }
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if arrUserData.count - 1 == indexPath.row {
            if self.page < totalPage {
                if isFilterData {
                    self.page += 1
                    clickToApply(self)
                }else {
                    self.page += 1
                    serviceCallToSearchListener()
                }
            }
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let user : UserModel = arrUserData[indexPath.row]
        let vc : ProfileVC = STORYBOARD.PROFILE.instantiateViewController(withIdentifier: "ProfileVC") as! ProfileVC
        vc.type = 1
        vc.selectedUser = user
        vc.selectedConnectUser = selectedUser
        vc.isMyProfile = false
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    //MARK: - CollectionView Delegate
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == favouriteArtistCollectionView {
            return FavouriteArtistArr.count
        }
        else if collectionView == favouriteGenrseCollectionView {
            return FavouriteGenresArr.count
        }
        else if collectionView == selectedCollectionView {
            return selectedUser.count
        }
        else    {
            return selectedTag.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == favouriteArtistCollectionView {
            let cell = favouriteArtistCollectionView.dequeueReusableCell(withReuseIdentifier: "TagCVC", for: indexPath) as! TagCVC
            cell.tagLbl.text = FavouriteArtistArr[indexPath.row]
            
            cell.cancelBtn.tag = indexPath.row
            cell.cancelBtn.addTarget(self, action: #selector(self.clickToCancelArtist(sender:)), for: .touchUpInside)
            cell.cancelBtnWidthConstraint.constant = 30
            
            cell.tagLbl.textColor = WhiteColor
            favouriteArtistCollectioViewHeightConstraint.constant = favouriteArtistCollectionView.contentSize.height
            return cell
            
        }
        else if collectionView == favouriteGenrseCollectionView {
            let cell = favouriteGenrseCollectionView.dequeueReusableCell(withReuseIdentifier: "TagCVC", for: indexPath) as! TagCVC
            cell.tagLbl.text = FavouriteGenresArr[indexPath.row]
            
            cell.cancelBtn.tag = indexPath.row
            cell.cancelBtn.addTarget(self, action: #selector(self.clickToCancelGenres(sender:)), for: .touchUpInside)
            cell.cancelBtnWidthConstraint.constant = 30
            
            cell.tagLbl.textColor = WhiteColor
            favouriteGenrseCollectioViewHeightConstraint.constant = favouriteGenrseCollectionView.contentSize.height
            return cell
        }
        else if collectionView == selectedCollectionView {
            let cell = selectedCollectionView.dequeueReusableCell(withReuseIdentifier: "SelectedUserCVC", for: indexPath) as! SelectedUserCVC
    
            let user : UserModel = selectedUser[indexPath.row]
            AppDelegate().sharedDelegate().setUserBackgroundImage(cell.profileImgBtn, user.avatar)
            
            cell.cancelBtn.tag = indexPath.row
            cell.cancelBtn.addTarget(self, action: #selector(self.clickToCancelUser(sender:)), for: .touchUpInside)
            
            selectedCollectionViewHeightConstraint.constant = 50
            return cell
        }
        else {
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
        
        if collectionView == favouriteArtistCollectionView {
            let label = UILabel(frame: CGRect.zero)
            label.text = FavouriteArtistArr[indexPath.row]
            label.sizeToFit()
            return CGSize(width: label.frame.width + 20 + 30, height: 40)
        }
        else if collectionView == favouriteGenrseCollectionView {
            let label = UILabel(frame: CGRect.zero)
            label.text = FavouriteGenresArr[indexPath.row]
            label.sizeToFit()
            return CGSize(width: label.frame.width + 20 + 30, height: 40)
        }
        else if collectionView == selectedCollectionView {
            return CGSize(width: 50, height: 50)
        }
        else {
            let label = UILabel(frame: CGRect.zero)
            label.text = selectedTag[indexPath.row]
            label.sizeToFit()
            return CGSize(width: label.frame.width + 20 + 30, height: 40)
        }
    }
    
    //MARK:- Collectionview button click event
    @objc func clickToCancelArtist(sender : UIButton) {
        self.view.endEditing(true)
        let index = FavouriteArtistArr.index(where: { (temp) -> Bool in
            temp == FavouriteArtistArr[sender.tag]
        })
        if index != nil {
            FavouriteArtistArr.remove(at: index!)
            if FavouriteArtistArr.count == 0 {
                favouriteArtistCollectioViewHeightConstraint.constant = 2
            }
        }
        favouriteArtistCollectionView.reloadData()
    }
    
    @objc func clickToCancelGenres(sender : UIButton) {
        self.view.endEditing(true)
        let index = FavouriteGenresArr.index(where: { (temp) -> Bool in
            temp == FavouriteGenresArr[sender.tag]
        })
        if index != nil {
            FavouriteGenresArr.remove(at: index!)
            if FavouriteGenresArr.count == 0 {
                favouriteGenrseCollectioViewHeightConstraint.constant = 2
            }
        }
        favouriteGenrseCollectionView.reloadData()
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
    
    //MARK:- Tableview button click event
    @objc @IBAction func clickToFavoriteBtn(_ sender: UIButton) {
        if !isUserLogin() {
            displayToast("In order to favorite listener, please login or create an account!")
            return
        }
        let selectedUser = arrUserData[sender.tag]
        if sender.isSelected {
            APIManager.shared.serviceCallToRemoveFavorite(selectedUser.uId) {
                sender.isSelected = false
                let index = AppModel.shared.MyFavoriteUserArr.index(where: { (temp) -> Bool in
                    temp.uId == selectedUser.uId
                })
                if index != nil
                {
                    AppModel.shared.MyFavoriteUserArr.remove(at: index!)
                }
            }
        }
        else
        {
            APIManager.shared.serviceCallToAddToFavorite(selectedUser.uId) { (favId) in
                sender.isSelected = true
                let index = AppModel.shared.MyFavoriteUserArr.index(where: { (temp) -> Bool in
                    temp.uId == selectedUser.uId
                })
                if index == nil
                {
                    AppModel.shared.MyFavoriteUserArr.append(selectedUser)
                }
            }
        }
    }
    
    @objc func clickToAddUser(sender : UIButton) {
        self.view.endEditing(true)
        let index = selectedUser.index { (temp) -> Bool in
            temp.uId == arrUserData[sender.tag].uId
        }
        
        if index != nil
        {
            selectedUser.remove(at: index!)
        }
        else
        {
            selectedUser.append(arrUserData[sender.tag])
            selectedCollectionViewHeightConstraint.constant = 50
           
        }
         listnerTblView.reloadRows(at: [IndexPath(row: sender.tag, section: 0)], with: .none)
        selectedCollectionView.reloadData()
    }
    
    @objc func clickToCancelUser(sender : UIButton) {
        self.view.endEditing(true)
        selectedUser.remove(at: sender.tag)
        selectedCollectionView.reloadData()
        listnerTblView.reloadData()
        if selectedUser.count == 0 {
            selectedCollectionViewHeightConstraint.constant = 0
        }else {
            selectedCollectionViewHeightConstraint.constant = 50
        }
    }
    
    @IBAction func clickToFilter(_ sender: Any) {
        if !isUserLogin() {
            displayToast("In order to apply filter, please login or create an account!")
            return
        }
        if filterBtn.isSelected == true {
            filterBtn.isSelected = false
            listnerBackView.isHidden = false
            filterBackView.isHidden = true
            flag = true
        }else {
            if AppModel.shared.currentUser.account_type == 1 {
                filterBtn.isSelected = true
                self.view.endEditing(true)
                listnerBackView.isHidden = true
                filterBackView.isHidden = false
                
                displaySubViewtoParentView(containerView, subview: filterBackView)
                containerViewHeightConstraint.constant = filterScrollView.contentSize.height
            } else {
                displayToast("Please upgrade to premium account to apply advance filter.")
            }
            
        }
    }
    
    @IBAction func clickToDone(_ sender: Any) {
        self.view.endEditing(true)
        if type1 == 0 {
            if selectedUser.count > 0 {
                let vc : UploadMusicVC = STORYBOARD.HOME.instantiateViewController(withIdentifier: "UploadMusicVC") as! UploadMusicVC
                vc.arrSelectedListener = selectedUser
                self.navigationController?.pushViewController(vc, animated: true)
            }
            else {
                displayToast("Please select Listener")
            }
        } else {
            NotificationCenter.default.post(name: NSNotification.Name.init(NOTIFICATION.SELECTED_LISTENER), object: selectedUser)
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    @IBAction func clickToBack(_ sender: Any) {
        self.view.endEditing(true)
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func clickToReset(_ sender: Any) {
        self.view.endEditing(true)
        searchTxt.text = ""
        maleBtn.isSelected = true
        minLbl.text = ""
        maxLbl.text = ""
        FavouriteGenresArr = []
        favouriteGenrseCollectionView.reloadData()
        FavouriteArtistArr = []
        favouriteArtistCollectionView.reloadData()
        countryTxt.text = ""
        stateTxt.text = ""
        cityTxt.text = ""
        selectedTag = []
        tagCollectionView.reloadData()
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
    
    @IBAction func clickToApply(_ sender: Any) {
        var param : [String : Any] = [String : Any]()
        param["name"] = searchTxt.text
        if maleBtn.isSelected {
            param["gender"] = "male"
        }
        else if femaleBtn.isSelected {
            param["gender"] = "female"
        }
        else if otherBtn.isSelected {
            param["gender"] = "other"
        }
        param["age"] = minLbl.text! + "," + maxLbl.text!
        param["favorite_genres"] = FavouriteGenresArr.joined(separator: ",")
        param["country"] = countryTxt.text
        param["state"] = stateTxt.text
        param["city"] = cityTxt.text
        param["tags"] = selectedTag.joined(separator: ",")
        param["verify"] = 0
        
        
        if flag {
            page = 1
            flag = false
        }
        
        param["page_no"] = page
        
        serviceCallToAdvanceSearchListner(param)
        
        filterBtn.isSelected = false
        listnerBackView.isHidden = false
        filterBackView.isHidden = true
        
    }
    
    @IBAction func clickToFavouriteArtistAdd(_ sender: Any) {
        self.view.endEditing(true)
        if favoriteArtistTxt.text != "" {
            FavouriteArtistArr.append(favoriteArtistTxt.text!)
            favouriteArtistCollectionView.reloadData()
            favoriteArtistTxt.text = ""
        }
    }
    
    @IBAction func clickToFAvouriteGenresAdd(_ sender: Any) {
        self.view.endEditing(true)
        tagVC.selectedArr = FavouriteGenresArr
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
        let url = Bundle.main.url(forResource: "states", withExtension: "json")!
        do {
            STATE_ARRAY = []
            AppModel.shared.STATE = [StateModel]()
            let jsonData = try Data(contentsOf: url)
            let json = try JSONSerialization.jsonObject(with: jsonData) as! [String:Any]
            
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
    
    //MARK:- TextField Delegate Method
    @objc func textFieldChange(textField : UITextField)
    {
        if textField.text?.trimmed != ""
        {
            if searchTimer != nil
            {
                searchTimer?.invalidate()
            }
            if #available(iOS 10.0, *) {
                searchTimer = Timer.scheduledTimer(withTimeInterval: 2.0, repeats: false, block: { (isTimer) in
                    self.page = 1
                    self.serviceCallToSearchListener()
                    
                })
            } else {
                // Fallback on earlier versions
            }
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == searchTxt
        {
            self.view.endEditing(true)
            if searchTimer != nil
            {
                searchTimer?.invalidate()
            }
            self.page = 1
            serviceCallToSearchListener()
        }
        return true
    }
    
    //MARK:- Service Called
    func serviceCallToSearchListener()
    {
        var param : [String : Any] = [String : Any]()
        param["search_term"] = searchTxt.text
        param["page_no"] = page
        
        APIManager.shared.serviceCallToSearchListner(param) { (data, totalpage) in
            if self.page == 1 {
                self.arrUserData = [UserModel]()
            }
            self.totalPage = totalpage
            for temp in data
            {
                self.arrUserData.append(UserModel.init(dict: temp))
            }
            self.listnerTblView.reloadData()
            
        }
    }
    
    func serviceCallToAdvanceSearchListner(_ param : [String : Any]) {
        APIManager.shared.serviceCallToAdvanceSearchListner(param) { (data, totalpage)  in
            if self.page == 1 {
                self.arrUserData = [UserModel]()
            }
            self.totalPage = totalpage
            for temp in data
            {
                self.arrUserData.append(UserModel.init(dict: temp))
            }
            self.listnerTblView.reloadData()
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    

}
