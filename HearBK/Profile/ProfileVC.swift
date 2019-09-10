//
//  ProfileVC.swift
//  HearBK
//
//  Created by PC on 31/01/19.
//  Copyright © 2019 PC. All rights reserved.
//

import UIKit

class ProfileVC: UIViewController, UITableViewDelegate ,UITableViewDataSource {

    @IBOutlet weak var verifyBtn: UIButton!
    @IBOutlet var editBtn: UIButton!
    @IBOutlet var favoriteBtn: UIButton!
    @IBOutlet var backBtn: UIButton!
    @IBOutlet var profileImgBtn: Button!
    @IBOutlet var nameLbl: Label!
    @IBOutlet var priceLbl: Label!
    @IBOutlet var addressLbl: Label!
    @IBOutlet var rateView: FloatRatingView!
    @IBOutlet var rateLbl: Label!
    
    @IBOutlet weak var tagView: TagListView!
    @IBOutlet weak var constraintHeightTagView: NSLayoutConstraint!
    
    @IBOutlet var connectBtnView: UIView!
    @IBOutlet var connectBtn: Button!
    @IBOutlet var constraintHeightConnectView: NSLayoutConstraint!
    
    @IBOutlet var proAboutLineView: UIView!
    @IBOutlet var proInsightLineView: UIView!
    @IBOutlet var proReviewLinewView: UIView!
    @IBOutlet var proTrackLineView: UIView!
    
    @IBOutlet var aboutBtn: Button!
    @IBOutlet var insughtBtn: Button!
    @IBOutlet var reviewBtn: Button!
    @IBOutlet var trackBtn: Button!
    
    @IBOutlet var containerView: UIView!
    @IBOutlet var containerViewHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet var aboutBackView: View!
    @IBOutlet var bioLbl: Label!
 
    @IBOutlet weak var bioView: UIView!
    @IBOutlet weak var constraintHeightBioView: NSLayoutConstraint!
    
    @IBOutlet var experienceView: UIView!
    @IBOutlet var experienceTblView: UITableView!
    
    @IBOutlet var InsightBackView: UIView!
    @IBOutlet weak var headlineView: UIView!
    @IBOutlet weak var headlineLbl: Label!
    @IBOutlet weak var constraintHeightHeadline: NSLayoutConstraint!//64
    
    @IBOutlet weak var favoriteArtistTag: TagListView!
    @IBOutlet weak var favoriteArtistView: UIView!
    @IBOutlet weak var constraintHeightFavoriteArtistView: NSLayoutConstraint!
    
    @IBOutlet weak var favoriteGenresTag: TagListView!
    @IBOutlet weak var favoriteGenresView: UIView!
    @IBOutlet weak var constraintHeightFavoriteGenresView: NSLayoutConstraint!
    
    @IBOutlet weak var musicAffiliationTag: TagListView!
    @IBOutlet weak var musicAffiliationView: UIView!
    @IBOutlet weak var constraintHeightMusicAffiliation: NSLayoutConstraint!
    
    
    @IBOutlet var reviewBackView: UIView!
    @IBOutlet var reviewTblView: UITableView!
    
    @IBOutlet var trackBackView: UIView!
    @IBOutlet var trackTblView: UITableView!
    
    @IBOutlet var shareBtn: UIButton!
    
    @IBOutlet var mapBtn: UIButton!
    @IBOutlet var noDataFoundLbl: Label!
    
    var selectedTab : Int = 1
    var type : Int = 0
    var selectedUser : UserModel = UserModel()
    
    var selectedConnectUser : [UserModel] = [UserModel]()
    
    var postArr : [String] = [String]()
    var FavouriteArtistArr : [String] = [String]()
    var FavouriteGenresArr : [String] = [String]()
    var MusicAffArr : [String] = [String]()
    
    var selectedTag : [String] = [String]()
    
    var isMyProfile : Bool = true
    var isFavorite : Bool = false
    var favourite_User_Id  : Int = 0
    
    var experienceArr : [ExperienceModel] = [ExperienceModel]()
    
    var trackArr : [TrackModel] = [TrackModel]()
    var trackPage : Int = 1
    var isLoadTrackData : Bool = true
    
    var reviewArr : [ReviewModel] = [ReviewModel]()
    var reviewPage : Int = 1
    var isLoadReviewData : Bool = true
    
    var ReadMoretag : Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(updateUserData), name: NSNotification.Name.init(NOTIFICATION.UPDATE_CURRENT_USER_DATA), object: nil)
        shareBtn.isHidden = true
        
        experienceTblView.register(UINib(nibName: "ExperienceTVC", bundle: nil), forCellReuseIdentifier: "ExperienceTVC")
        reviewTblView.register(UINib(nibName: "ReviewTVC", bundle: nil), forCellReuseIdentifier: "ReviewTVC")
        trackTblView.register(UINib(nibName: "TrackTVC", bundle: nil), forCellReuseIdentifier: "TrackTVC")
        
        refereshView()
        
        connectBtn.setTitle("", for: .normal)
        connectBtnView.isHidden = true
        constraintHeightConnectView.constant = 0
        
        if selectedUser.uId != ""
        {
            if isUserLogin() && selectedUser.uId == AppModel.shared.currentUser.uId
            {
                isMyProfile = true
            }
            else
            {
                isMyProfile = false
            }
        }
        
        if isMyProfile
        {
            selectedUser = AppModel.shared.currentUser
            setUserData()
            clickToAbout(self)
        }
        else
        {
            APIManager.shared.serviceCallToGetOtherUserData(selectedUser.uId) { (user) in
                self.selectedUser = user
                self.setUserData()
                self.clickToAbout(self)
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let tabBar : CustomTabBarController = self.tabBarController as! CustomTabBarController
        if tabBarController != nil && !isMyProfile
        {
            tabBar.setTabBarHidden(tabBarHidden: true)
            self.extendedLayoutIncludesOpaqueBars = true
            edgesForExtendedLayout = UIRectEdge.bottom
        }
        else {
            tabBar.setTabBarHidden(tabBarHidden: false)
        }
    }
    
    //MARK:- Update user Data
    @objc func updateUserData()
    {
        if isUserLogin() && selectedUser.uId == AppModel.shared.currentUser.uId
        {
            selectedUser = AppModel.shared.currentUser
            setUserData()
            if selectedTab == 1
            {
                clickToAbout(self)
            }
            else if selectedTab == 2
            {
                clickToAbout(self)
            }
            else if selectedTab == 3
            {
                clickToReview(self)
            }
            else if selectedTab == 4
            {
                clickToTrack(self)
            }
        }
    }
    
    //MARK:- Set user Data
    func setUserData()  {
        
        profileImgBtn.isUserInteractionEnabled = true
        AppDelegate().sharedDelegate().setUserBackgroundImage(profileImgBtn, selectedUser.avatar)
        nameLbl.text = selectedUser.display_name
        
        if selectedUser.verify == 0 {
            verifyBtn.isHidden = true
        } else {
            verifyBtn.isHidden = false
        }
        
        priceLbl.text = "$" + String(selectedUser.price)
        addressLbl.text = getAddressString(selectedUser.city, selectedUser.state, selectedUser.country)
        if (addressLbl.text?.length())! > 0
        {
            mapBtn.isHidden = false
        }
        else
        {
            mapBtn.isHidden = true
        }
        rateLbl.text = setFlotingRating(selectedUser.rating_as_listener)
        rateView.rating = selectedUser.rating_as_listener
        
        if isMyProfile && isUserLogin() {
            editBtn.isHidden = false
            favoriteBtn.isHidden = true
            backBtn.isHidden = true
            shareBtn.isHidden = false
        } else {
            editBtn.isHidden = true
            favoriteBtn.isHidden = false
            backBtn.isHidden = false
            favoriteBtn.isSelected = isFavorite
            
            if type == 1 {
                connectBtnView.isHidden = false
                constraintHeightConnectView.constant = 60
                let index = selectedConnectUser.firstIndex { (temp) -> Bool in
                    temp.uId == selectedUser.uId
                }
                if index == nil
                {
                    connectBtn.setTitle("Connect", for: .normal)
                }
                else
                {
                    connectBtn.setTitle("Disconnect", for: .normal)
                }
            }
            if !isUserLogin() {
                favoriteBtn.isHidden = true
                shareBtn.isHidden = true
            } else {
                shareBtn.isHidden = false
            }
            if selectedUser.uId != "" {
                
                for temp in AppModel.shared.MyFavoriteUserArr
                {
                    print(temp.uId)
                }
                
                let index = AppModel.shared.MyFavoriteUserArr.index(where: { (temp) -> Bool in
                    temp.uId == selectedUser.uId
                })
                if index != nil {
                    self.favoriteBtn.isSelected = true
                } else {
                    self.favoriteBtn.isSelected = false
                }
            }
            serviceCallToGetProfileAbout()
        }
        
        tagView.removeAllTags()
        tagView.textFont = UIFont(name: SFUI_LIGHT, size: 12)!
        if selectedUser.tag != ""
        {
            let tagArr : [String] = selectedUser.tag.components(separatedBy: ",")
            if tagArr.count > 0
            {
                tagView.addTag(tagArr[0])
                if tagArr.count > 1
                {
                    tagView.addTag(tagArr[1])
                    
                    if tagArr.count > 2
                    {
                        if tagArr.count == 3
                        {
                            tagView.addTag(tagArr[2])
                        }
                        else
                        {
                            tagView.addTag(("+" + String(tagArr.count-2))).onTap = { tempTagView in
                                self.tagView.removeAllTags()
                                self.tagView.addTags(tagArr)
                                self.constraintHeightTagView.constant = self.tagView.bounds.size.height
                            }
                        }
                    }
                }
            }
        }
        
        constraintHeightTagView.constant = tagView.bounds.size.height
        
        if getFeedbackReceivedValue()
        {
            clickToTrack(self)
        }
        else if getRatingReceivedValue()
        {
            clickToReview(self)
        }
    }
    
    //MARK: - TableView Delegate
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == experienceTblView {
            return experienceArr.count
        }
        else if tableView == reviewTblView {
            return reviewArr.count
        }
        else {
            return trackArr.count
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if tableView == experienceTblView {
            return UITableViewAutomaticDimension
        }
        else if tableView == reviewTblView {
            return UITableViewAutomaticDimension
        }
        else {
            return UITableViewAutomaticDimension
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == experienceTblView {
            let cell = experienceTblView.dequeueReusableCell(withIdentifier: "ExperienceTVC", for: indexPath) as! ExperienceTVC
            
            let dict = experienceArr[indexPath.row]
            
            cell.companyNameLbl.text = dict.company
            cell.positionLbl.text = dict.position
            
            let time = dict.fromDate! + " - " + dict.toDate!
            cell.dateLbl.text = time
            
            cell.cancelBtn.isHidden = true
            setAboutViewHeight()
            return cell
        }
        else if tableView == reviewTblView {
            let cell = reviewTblView.dequeueReusableCell(withIdentifier: "ReviewTVC", for: indexPath) as! ReviewTVC
            
            let dict : ReviewModel = reviewArr[indexPath.row]
            AppDelegate().sharedDelegate().setUserBackgroundImage(cell.profilePicBtn, dict.image)
            
            cell.nameLbl.text = dict.name
            cell.descriptionLbl.text = dict.comment
            cell.rateView.rating = dict.rating
            
            cell.ratingBackViewHeightConstraint.constant = 0
            cell.rateBackView.isHidden = true
            setRatingViewHeight()
            return cell
        }
        else {
            let cell = trackTblView.dequeueReusableCell(withIdentifier: "TrackTVC", for: indexPath) as! TrackTVC
            
            let dict : TrackModel = trackArr[indexPath.row]
            cell.nameLbl.text = dict.track_title
            cell.dateLbl.text = getDateStringFromDate(date: getDateFromDateString(strDate: dict.created_at, format: "dd-MM-yyyy")!, format: "MM-dd-yyyy")
            if dict.rating != ""
            {
                cell.rateBtn.setTitle(setFlotingRating(Double(dict.rating)!), for: .normal)
                cell.rateBtn.isHidden = false
            }
            else
            {
                cell.rateBtn.isHidden = true
            }
            setTrackViewHeight()
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView == reviewTblView {
            let vc : TrackDetailVC = STORYBOARD.HOME.instantiateViewController(withIdentifier: "TrackDetailVC") as! TrackDetailVC
            vc.reviewData = reviewArr[indexPath.row]
            vc.isFromReview = true
            self.navigationController?.pushViewController(vc, animated: true)
        }
        else if  tableView == trackTblView {
            let vc : TrackDetailVC = STORYBOARD.HOME.instantiateViewController(withIdentifier: "TrackDetailVC") as! TrackDetailVC
            vc.track = trackArr[indexPath.row]
            vc.music_type = trackArr[indexPath.row].music_type
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if tableView == trackTblView {
            if trackArr.count - 1 == indexPath.row && isLoadTrackData {
                serviceCallToGetProfileTrackData()
            }
        }
        else if tableView == reviewTblView {
            if trackArr.count - 1 == indexPath.row && isLoadReviewData {
                serviceCallToGetProfileReviewData()
            }
        }
        
    }
    
    //MARK: - Tab click event
    @IBAction func clickToAbout(_ sender: Any) {
        refereshView()
        selectedTab = 1
        proAboutLineView.backgroundColor = GreenColor
        InsightBackView.isHidden = true
        reviewBackView.isHidden = true
        trackBackView.isHidden = true
        aboutBackView.isHidden = false
        aboutBtn.setTitleColor(WhiteColor, for: .normal)
        displaySubViewtoParentView(containerView, subview: aboutBackView)
        displaySubViewWithScaleOutAnim(aboutBackView)
        setAboutData()
    }
    
    @IBAction func clickToInsight(_ sender: Any) {
        refereshView()
        selectedTab = 2
        proInsightLineView.backgroundColor = GreenColor
        InsightBackView.isHidden = false
        aboutBackView.isHidden = true
        reviewBackView.isHidden = true
        trackBackView.isHidden = true
        insughtBtn.setTitleColor(WhiteColor, for: .normal)
        displaySubViewtoParentView(containerView, subview: InsightBackView)
        displaySubViewWithScaleOutAnim(InsightBackView)
        
        if selectedUser.insight.headline == "" {
            serviceCallToGetProfileInsightData()
        }
        else
        {
            setInsightData(0.1)
        }
    }
    
    @IBAction func clickToReview(_ sender: Any) {
        refereshView()
        selectedTab = 3
        proReviewLinewView.backgroundColor = GreenColor
        reviewBtn.setTitleColor(WhiteColor, for: .normal)
        InsightBackView.isHidden = true
        aboutBackView.isHidden = true
        reviewBackView.isHidden = false
        trackBackView.isHidden = true
        
        if reviewArr.count == 0
        {
            refreshRatingData()
        }
        else
        {
            setReviewData()
        }
    }
    
    @IBAction func clickToTrack(_ sender: Any) {
        refereshView()
        selectedTab = 4
        proTrackLineView.backgroundColor = GreenColor
        trackBtn.setTitleColor(WhiteColor, for: .normal)
        InsightBackView.isHidden = true
        aboutBackView.isHidden = true
        reviewBackView.isHidden = true
        trackBackView.isHidden = false
        
        if trackArr.count == 0
        {
            refreshTrackData()
        }
        else
        {
            self.setTrackData()
        }
    }
    
    func refereshView()  {
        proAboutLineView.backgroundColor = ClearColor
        proInsightLineView.backgroundColor = ClearColor
        proReviewLinewView.backgroundColor = ClearColor
        proTrackLineView.backgroundColor = ClearColor
        
        aboutBtn.setTitleColor(LightGrayColor, for: .normal)
        insughtBtn.setTitleColor(LightGrayColor, for: .normal)
        reviewBtn.setTitleColor(LightGrayColor, for: .normal)
        trackBtn.setTitleColor(LightGrayColor, for: .normal)
        
        noDataFoundLbl.isHidden = true
    }
    
    //MARK:- Handle Push Notification
    func redirectToTrackDetailFromNotification()
    {
        if !getFeedbackReceivedValue()
        {
            return
        }
        let order_id : Int = getOrderId()
        if order_id != -1
        {
            let index = trackArr.lastIndex { (temp) -> Bool in
                temp.track_id == order_id
            }
            if index != nil
            {
                let vc : TrackDetailVC = STORYBOARD.HOME.instantiateViewController(withIdentifier: "TrackDetailVC") as! TrackDetailVC
                vc.track = trackArr[index!]
                vc.music_type = trackArr[index!].music_type
                self.navigationController?.pushViewController(vc, animated: true)
            }
            setOrderId(value: -1)
            setFeedbackReceivedValue(value: false)
        }
    }
    
    func redirectToReceivedFeedbackFromNotification()
    {
        if !getRatingReceivedValue()
        {
            return
        }
        let order_id : Int = getOrderId()
        if order_id != -1
        {
            let index = reviewArr.lastIndex { (temp) -> Bool in
                temp.track_id == order_id
            }
            if index != nil
            {
                let vc : TrackDetailVC = STORYBOARD.HOME.instantiateViewController(withIdentifier: "TrackDetailVC") as! TrackDetailVC
                vc.reviewData = reviewArr[index!]
                vc.isFromReview = true
                self.navigationController?.pushViewController(vc, animated: true)
            }
            setOrderId(value: -1)
            setRatingReceivedValue(value: false)
        }
    }
    
    //MARK:- Button click event
    @IBAction func clickToProfilePhoto(_ sender: Any) {
        if selectedUser.avatar != ""
        {
            displayFullImage([selectedUser.avatar], 0)
        }
    }
    
    @IBAction func clickToEditProfile(_ sender: Any) {
        let vc : EditProfileVC = STORYBOARD.PROFILE.instantiateViewController(withIdentifier: "EditProfileVC") as! EditProfileVC
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func clickToShare(_ sender: Any) {
        let vc : PromoteProfileVC = STORYBOARD.SETTING.instantiateViewController(withIdentifier: "PromoteProfileVC") as! PromoteProfileVC
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func clickToAboutConnect(_ sender: Any) {
        NotificationCenter.default.post(name: NSNotification.Name.init(NOTIFICATION.REDIRECT_SERCHFOR_LISNER), object: selectedUser)
        clickToBack(self)
    }
    
    @IBAction func clickToBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func clickToFavoriteBtn(_ sender: UIButton) {
        if sender.isSelected {
            APIManager.shared.serviceCallToRemoveFavorite(selectedUser.uId) {
                self.favoriteBtn.isSelected = false
                let index = AppModel.shared.MyFavoriteUserArr.index(where: { (temp) -> Bool in
                    temp.uId == self.selectedUser.uId
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
                self.favourite_User_Id = favId
                self.favoriteBtn.isSelected = true
                let index = AppModel.shared.MyFavoriteUserArr.index(where: { (temp) -> Bool in
                    temp.uId == self.selectedUser.uId
                })
                if index == nil
                {
                    AppModel.shared.MyFavoriteUserArr.append(self.selectedUser)
                }
            }
        }
    }
    
    //MARK:- Service call
    func serviceCallToGetProfileAbout()
    {
        APIManager.shared.serviceCallToMyProfileAbout(selectedUser.uId) { (data) in
            if let bio1 : String = data["bio"] as? String {
                self.selectedUser.bio = bio1
                self.bioLbl.text = bio1
            }
            if let experience : [[String : Any]] = data["experience"] as? [[String : Any]] {
                self.selectedUser.experience = [ExperienceModel]()
                self.experienceArr = [ExperienceModel]()
                for item in experience {
                    self.selectedUser.experience.append(ExperienceModel.init(dict: item))
                    self.experienceArr.append(ExperienceModel.init(dict: item))
                }
                self.experienceTblView.reloadData()
                self.setAboutData()
            }
        }
    }
    
    func serviceCallToGetProfileInsightData()
    {
        APIManager.shared.serviceCallToGetProfileInsight(selectedUser.uId) { (data) in
            let insight : ProfileInsight = ProfileInsight.init(dict: data)
            self.selectedUser.insight = insight
            self.setInsightData(0.5)
        }
    }
    
    @objc func refreshRatingData()
    {
        reviewPage = 1
        isLoadReviewData = true
        serviceCallToGetProfileReviewData()
    }
    
    func serviceCallToGetProfileReviewData()  {
        var param : [String : Any] = [String  :Any]()
        param["page_no"] = reviewPage
        param["user_id"] = selectedUser.uId
        APIManager.shared.serviceCallToMyProfileReviews(param) { (data, totalpage) in
            if self.reviewPage == 1
            {
                self.reviewArr = [ReviewModel]()
            }
            for temp in data
            {
                self.reviewArr.append(ReviewModel.init(dict: temp))
            }
            if self.reviewPage == totalpage {
                self.isLoadReviewData = false
            }
            else
            {
                self.reviewPage += 1
            }
            if self.reviewArr.count == 0
            {
                self.noDataFoundLbl.text = "You have not any review yet."
                self.noDataFoundLbl.isHidden = false
            }
            else
            {
                self.noDataFoundLbl.isHidden = true
            }
            self.setReviewData()
        }
    }
    
    @objc func refreshTrackData()
    {
        trackPage = 1
        isLoadTrackData = true
        serviceCallToGetProfileTrackData()
    }
    
    func serviceCallToGetProfileTrackData()  {
        var param : [String : Any] = [String  :Any]()
        param["page_no"] = trackPage
        param["user_id"] = selectedUser.uId
        APIManager.shared.serviceCallToMyProfileTracks(param) { (data, totalcount) in
            if self.trackPage == 1
            {
                self.trackArr = [TrackModel]()
            }
            for temp in data
            {
                self.trackArr.append(TrackModel.init(dict: temp))
            }
            if self.trackArr.count == totalcount {
                self.isLoadTrackData = false
            }
            else
            {
                self.trackPage += 1
            }
            if self.trackArr.count == 0
            {
                self.noDataFoundLbl.text = "You have not uploaded any track yet."
                self.noDataFoundLbl.isHidden = false
            }
            else
            {
                self.noDataFoundLbl.isHidden = true
            }
            self.setTrackData()
        }
    }
    
    //MARK:- Set Tab Data and height
    @objc func setAboutData()
    {
        aboutBackView.isHidden = true
        bioLbl.text = selectedUser.bio
        bioLbl.numberOfLines = 0
        
        experienceArr = selectedUser.experience
        experienceTblView.reloadData()
        
        delay(0.5) {
            self.setAboutViewHeight()
        }
    }

    func setAboutViewHeight()
    {
        if selectedUser.bio == ""
        {
            constraintHeightBioView.constant = 0
            bioView.isHidden = true
        }
        else
        {
            bioView.isHidden = false
            constraintHeightBioView.constant = bioLbl.retrieveTextHeight() + 55
        }
        
        if experienceArr.count > 0
        {
            experienceView.isHidden = false
            containerViewHeightConstraint.constant = self.experienceTblView.contentSize.height + constraintHeightBioView.constant + 30
        }
        else
        {
            experienceView.isHidden = true
            containerViewHeightConstraint.constant = constraintHeightBioView.constant
        }
        
        if isUserLogin() && selectedUser.uId == AppModel.shared.currentUser.uId
        {
            if selectedUser.isBecomeListener == 0
            {
                noDataFoundLbl.text = "Please become a listener"
                noDataFoundLbl.isHidden = false
            }
            else
            {
                if selectedUser.bio == "" && experienceArr.count > 0
                {
                    noDataFoundLbl.text = "Please add your bio and experience"
                    noDataFoundLbl.isHidden = false
                }
            }
        }
        aboutBackView.isHidden = false
    }
    
    func setInsightData(_ duration : Double)
    {
        InsightBackView.isHidden = true
        headlineLbl.text = selectedUser.insight.headline
        
        if selectedUser.insight.favorite_artists != ""
        {
            FavouriteArtistArr = selectedUser.insight.favorite_artists.components(separatedBy: ",")
        }
        else
        {
            FavouriteArtistArr = [String]()
        }
        favoriteArtistTag.textFont = UIFont(name: SFUI_REGULAR, size: 14)!
        favoriteArtistTag.removeAllTags()
        favoriteArtistTag.addTags(FavouriteArtistArr)
        
        if selectedUser.insight.favorite_genres != ""
        {
            FavouriteGenresArr = selectedUser.insight.favorite_genres.components(separatedBy: ",")
        }
        else
        {
            FavouriteGenresArr = [String]()
        }
        favoriteGenresTag.textFont = UIFont(name: SFUI_REGULAR, size: 14)!
        favoriteGenresTag.removeAllTags()
        favoriteGenresTag.addTags(FavouriteGenresArr)
        
        
        if selectedUser.insight.music_affiliations != ""
        {
            MusicAffArr = selectedUser.insight.music_affiliations.components(separatedBy: ",")
        }
        else
        {
            MusicAffArr = [String]()
        }
        musicAffiliationTag.textFont = UIFont(name: SFUI_REGULAR, size: 14)!
        musicAffiliationTag.removeAllTags()
        musicAffiliationTag.addTags(MusicAffArr)
        
        delay(duration) {
            self.setInsightHeight()
        }
    }
    
    
    func setInsightHeight()
    {
        
        if selectedUser.headline == ""
        {
            constraintHeightHeadline.constant = 0
            headlineView.isHidden = true
        }
        else
        {
            constraintHeightHeadline.constant = headlineLbl.retrieveTextHeight() + 37
            headlineView.isHidden = false
        }
        
        constraintHeightFavoriteArtistView.constant = ((FavouriteArtistArr.count == 0) ? 0 : (favoriteArtistTag.intrinsicContentSize.height + 50))
        constraintHeightFavoriteGenresView.constant = ((FavouriteGenresArr.count == 0) ? 0 : (favoriteGenresTag.intrinsicContentSize.height + 50))
        constraintHeightMusicAffiliation.constant = ((MusicAffArr.count == 0) ? 0 : (musicAffiliationTag.intrinsicContentSize.height + 50))
        containerViewHeightConstraint.constant = constraintHeightFavoriteArtistView.constant + constraintHeightFavoriteGenresView.constant + constraintHeightMusicAffiliation.constant + constraintHeightHeadline.constant + 15
        
        if isUserLogin() && selectedUser.uId == AppModel.shared.currentUser.uId
        {
            if selectedUser.isBecomeListener == 0
            {
                noDataFoundLbl.text = "Please become a listener"
                noDataFoundLbl.isHidden = false
            }
            else
            {
                if selectedUser.headline == ""
                {
                    noDataFoundLbl.text = "Please add your headline"
                    noDataFoundLbl.isHidden = false
                }
            }
        }
        InsightBackView.isHidden = false
    }
    
    func setReviewData()
    {
        reviewBackView.isHidden = true
        reviewTblView.reloadData()
        displaySubViewtoParentView(self.containerView, subview: self.reviewBackView)
        displaySubViewWithScaleOutAnim(reviewBackView)
        delay(0.5) {
            self.setRatingViewHeight()
        }
        self.redirectToReceivedFeedbackFromNotification()
    }
    
    func setRatingViewHeight()
    {
        containerViewHeightConstraint.constant = reviewTblView.contentSize.height + 10
        reviewBackView.isHidden = true
    }
    
    func setTrackData()
    {
        trackBackView.isHidden = true
        trackTblView.reloadData()
        displaySubViewtoParentView(self.containerView, subview: self.trackBackView)
        displaySubViewWithScaleOutAnim(trackBackView)
        delay(0.5) {
            self.setTrackViewHeight()
        }
        redirectToTrackDetailFromNotification()
    }
    
    func setTrackViewHeight()
    {
        containerViewHeightConstraint.constant = trackTblView.contentSize.height + 10
        trackBackView.isHidden = true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
