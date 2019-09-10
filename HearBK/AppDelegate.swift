//
//  AppDelegate.swift
//  HearBK
//
//  Created by PC on 28/01/19.
//  Copyright © 2019 PC. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift
import NVActivityIndicatorView
import FBSDKLoginKit
import UserNotifications //iOS 10 for local and remote notifications
import SDWebImage
import Firebase

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    let fbLoginManager = FBSDKLoginManager()
    var activityLoader : NVActivityIndicatorView!
    var navCount : Int = 0
    var customTabbarVc : CustomTabBarController!
    var deviceToken : String = ""
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
       
        /**
         * IQKeyboardManager
         *
         * used to manage keyboard show hide event.
         *
         * @enable : Used to enble IQKeyboardManager in App.
         * @shouldShowToolbarPlaceholder : Display textfield placeholder string in UIToolbar.
         */
        IQKeyboardManager.shared.enable = true
        IQKeyboardManager.shared.shouldShowToolbarPlaceholder = true
        
        FBSDKApplicationDelegate.sharedInstance().application(application, didFinishLaunchingWithOptions: launchOptions)
        
        UIApplication.shared.statusBarStyle = .lightContent
        
        //Notification
        registerPushNotification(application)
        UIApplication.shared.applicationIconBadgeNumber = 0
        
        FirebaseApp.configure()
        
        if getLoginUserData() != nil
        {
            AppModel.shared.currentUser = UserModel.init(dict: getLoginUserData()!)
            AppModel.shared.CARD_LIST = getCreditCardList()
            self.navigateToDashBoard()
        }
        
        return true
    }
    
    /**
     * UIStoryboard
     *
     * Used to access main storyboard instance
     *
     * @param
     */
    func storyboard() -> UIStoryboard
    {
        return UIStoryboard(name: "Main", bundle: nil)
    }
    
    /**
     * AppDelegate Sharing
     *
     * Used to share AppDelegate method to access globally
     *
     * @param
     */
    func sharedDelegate() -> AppDelegate
    {
        return UIApplication.shared.delegate as! AppDelegate
    }
    
    /**
     * Show loader till sending/getting data to/from server
     *
     * Set color and size here
     *
     * @param
     */
    func showLoader()
    {
        removeLoader()
        window?.isUserInteractionEnabled = false
        activityLoader = NVActivityIndicatorView(frame: CGRect(x: ((window?.frame.size.width)!-50)/2, y: ((window?.frame.size.height)!-50)/2, width: 50, height: 50))
        activityLoader.type = .ballSpinFadeLoader
        activityLoader.color = GreenColor
        window?.addSubview(activityLoader)
        activityLoader.startAnimating()
    }
    
    /**
     * Hide loader after getting response from server
     *
     * @param
     */
    func removeLoader()
    {
        window?.isUserInteractionEnabled = true
        if activityLoader == nil
        {
            return
        }
        activityLoader.stopAnimating()
        activityLoader.removeFromSuperview()
        activityLoader = nil
    }
    
    //MARK:- Navigation
    func navigateToLogin() {
        let navigationVC = STORYBOARD.MAIN.instantiateViewController(withIdentifier: "ViewControllerNavigation") as! UINavigationController
        UIApplication.shared.keyWindow?.rootViewController = navigationVC
    }
    
    func navigateToDashBoard() {
        customTabbarVc = STORYBOARD.HOME.instantiateViewController(withIdentifier: "CustomTabBarController") as? CustomTabBarController
        
        if let rootNavigatioVC : UINavigationController = self.window?.rootViewController as? UINavigationController
        {
            rootNavigatioVC.pushViewController(customTabbarVc, animated: false)
        }
    }
    
    func logoutApp() {
        APIManager.shared.serviceCallToLogOut {
            self.continueToLogout()
        }
    }
    
    func continueToLogout()
    {
        let dict = getLoginUserParameter()
        removeUserDefaultValues()
        AppModel.shared.resetAllModel()
        if dict != nil {
            setLoginUserParameter(dict!)
        }
        self.navigateToLogin()
    }
    
    func loginWithFacebook()
    {
        fbLoginManager.logOut()
        
        fbLoginManager.logIn(withReadPermissions: ["public_profile", "email"], from: window?.rootViewController) { (result, error) in
            if let error = error {
                showAlert("Error", message: error.localizedDescription, completion: {})
                return
            }
            
            guard let token = result?.token else {
                return
            }
            
            guard let accessToken = token.tokenString else {
                return
            }
            
            let request : FBSDKGraphRequest = FBSDKGraphRequest(graphPath: "me", parameters: ["fields" : "picture.width(500).height(500), email, id, name, first_name, last_name, gender"])
            
            let connection : FBSDKGraphRequestConnection = FBSDKGraphRequestConnection()
            connection.add(request, completionHandler: { (connection, result, error) in
                
                if result != nil
                {
                    AppModel.shared.currentUser = UserModel.init()
                    let dict = result as! [String : AnyObject]
                    print(dict)
                    
                    
                    APIManager.shared.serviceCallToFBLogin(accessToken, { (status) in
                        if status
                        {
                            self.navigateToDashBoard()
                        }
                        else
                        {
                            if let email : String = dict["email"] as? String
                            {
                                AppModel.shared.currentUser.email = email
                            }

                            if let temp : String = dict["first_name"] as? String
                            {
                                AppModel.shared.currentUser.display_name = temp
                            }

                            if let temp : String = dict["last_name"] as? String
                            {
                                AppModel.shared.currentUser.lname = temp
                            }

                            if let picture = dict["picture"] as? [String : Any]
                            {
                                if let data = picture["data"] as? [String : Any]
                                {
                                    if let url = data["url"]
                                    {
                                        AppModel.shared.currentUser.avatar = url as? String
                                    }
                                }
                            }
                            
                            let vc : BecomeListenerVC = STORYBOARD.MAIN.instantiateViewController(withIdentifier: "BecomeListenerVC") as! BecomeListenerVC
                            vc.isFBLogin = true
                            UIApplication.topViewController()?.navigationController?.pushViewController(vc, animated: false)
                        }
                    })
                }
                else
                {
                    print(error?.localizedDescription ?? "error")
                }
            })
            connection.start()
        }
    }
    
    //MARK:- Get Country, State, City
    func getCountryList() -> [String]
    {
        let url = Bundle.main.url(forResource: "countries", withExtension: "json")!
        do {
            var COUNTRY_ARRAY : [String] = [String]()
            AppModel.shared.COUNTRY = [CountryModel]()
            let jsonData = try Data(contentsOf: url)
            let json = try JSONSerialization.jsonObject(with: jsonData) as! [String:Any]
            
            let countries = json["countries"] as! [[String:Any]]
            
            for item in countries {
                AppModel.shared.COUNTRY.append(CountryModel.init(dict: item))
                COUNTRY_ARRAY.append(item["name"] as! String)
            }
            return COUNTRY_ARRAY
        }
        catch {
            print(error)
        }
        return [String]()
    }
    
    func getStateListFronCountry(counrtyId : Int) -> [String]
    {
        let url = Bundle.main.url(forResource: "states", withExtension: "json")!
        do {
            var STATE_ARRAY : [String] = [String]()
            AppModel.shared.STATE = [StateModel]()
            
            let jsonData = try Data(contentsOf: url)
            let json = try JSONSerialization.jsonObject(with: jsonData) as! [String:Any]
            print(json)
            
            let states = json["states"] as! [[String:Any]]
            
            for item in states {
                let state = StateModel.init(dict: item)
                if state.country_id == String(counrtyId) {
                    AppModel.shared.STATE.append(StateModel.init(dict: item))
                    STATE_ARRAY.append(item["name"] as! String)
                }
            }
            return STATE_ARRAY
        }
        catch {
            print(error)
        }
        return [String]()
    }
    
    
    //MARK: - Set Profile Image
    func setUserBackgroundImage(_ button : UIButton, _ strUrl : String)
    {
        button.sd_setBackgroundImage(with: URL(string: strUrl), for:UIControlState.normal,completed: { (image, error, SDImageCacheType, url) in
            if image != nil{
                button.setBackgroundImage(image?.imageCropped(toFit: CGSize(width: button.frame.size.width, height: button.frame.size.height)), for: .normal)
            }
            else
            {
                button.setBackgroundImage(UIImage.init(named: "user"), for: .normal)
            }
        })
    }
    
    //MARK: - Service Called
    
    func getAllRequiredDataAfterLogin()
    {
        delay(1) {
            AppDelegate().sharedDelegate().serviceCallMyFavorite()
            AppDelegate().sharedDelegate().getCardApiCall()
            AppDelegate().sharedDelegate().GetListnerTag()
        }
    }
    
    func GetListnerTag()  {
        if AppModel.shared.LISTNER_TAG.count == 0 {
            APIManager.shared.serviceCallToListnerTagList {
                
            }
        }
    }
    
    func getCardApiCall()  {
        AppModel.shared.CARD_LIST = [CardModel]()
        APIManager.shared.serviceCallToGetCard { (data) in
            AppModel.shared.CARD_LIST = [CardModel]()
            for item in data {
                AppModel.shared.CARD_LIST.append(CardModel.init(dict: item))
            }
            setCreditCardList()
        }
    }
    
    func getLoginUserDetail()
    {
        APIManager.shared.serviceCallToGetLoginUserData { (status) in
            if !status {
                removeUserDefaultValues()
                AppDelegate().sharedDelegate().navigateToLogin()
            }
            else
            {
                AppDelegate().sharedDelegate().getProfileAboutData()
                AppDelegate().sharedDelegate().getProfileInsightData()
            }
        }
    }
    
    func getProfileInsightData()
    {
        APIManager.shared.serviceCallToGetProfileInsight("") { (data) in
            let insight : ProfileInsight = ProfileInsight.init(dict: data)
            AppModel.shared.currentUser.insight = insight
            NotificationCenter.default.post(name: NSNotification.Name.init(NOTIFICATION.UPDATE_CURRENT_USER_DATA), object: nil)
        }
    }
    
    func getProfileAboutData()  {
        APIManager.shared.serviceCallToMyProfileAbout(AppModel.shared.currentUser.uId) { (data) in
            if let bio1 : String = data["bio"] as? String {
                AppModel.shared.currentUser.bio = bio1
            }
            if let experience : [[String : Any]] = data["experience"] as? [[String : Any]] {
                AppModel.shared.currentUser.experience = [ExperienceModel]()
                for item in experience {
                    AppModel.shared.currentUser.experience.append(ExperienceModel.init(dict: item))
                }
            }
            NotificationCenter.default.post(name: NSNotification.Name.init(NOTIFICATION.UPDATE_CURRENT_USER_DATA), object: nil)
        }
    }
    
    func serviceCallMyFavorite() {
        APIManager.shared.serviceCallToGetMyFavorite { (data) in
            AppModel.shared.MyFavoriteUserArr = [UserModel]()
            for item in data {
                AppModel.shared.MyFavoriteUserArr.append(UserModel.init(dict: item))
            }
            NotificationCenter.default.post(name: NSNotification.Name.init(NOTIFICATION.UPDATE_FAVORITE_USER), object: nil)
        }
    }
    
    //MARK:- Notification
    func registerPushNotification(_ application: UIApplication)
    {
        if #available(iOS 10.0, *) {
            // For iOS 10 display notification (sent via APNS)
            UNUserNotificationCenter.current().delegate = self
            
            let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
            UNUserNotificationCenter.current().requestAuthorization(
                options: authOptions,
                completionHandler: {_, _ in })
            DispatchQueue.main.async {
                UIApplication.shared.registerForRemoteNotifications()
            }
        } else {
            let settings: UIUserNotificationSettings =
                UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
            application.registerUserNotificationSettings(settings)
            application.registerForRemoteNotifications()
        }
    }
    
    func application(_ application: UIApplication, didRegister notificationSettings: UIUserNotificationSettings) {
        if notificationSettings.types != []
        {
            application.registerForRemoteNotifications()
        }
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken token: Data) {
        print(token.description)
        deviceToken = token.reduce("", {$0 + String(format: "%02X",    $1 as CVarArg)})
        print(deviceToken)
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("Unable to register for remote notifications: \(error.localizedDescription)")
    }
    
    //Get Push Notification
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any]) {
        UIApplication.shared.applicationIconBadgeNumber = 0
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any],
                     fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        print(userInfo)
        UIApplication.shared.applicationIconBadgeNumber = 0
        // This notification is not auth related, developer should handle it.
        
        completionHandler(UIBackgroundFetchResult.newData)
    }
    
    //MARK: - Facebook Function
    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
        return FBSDKApplicationDelegate.sharedInstance().application(app, open: url, options: options)
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}


@available(iOS 10, *)
extension AppDelegate : UNUserNotificationCenterDelegate {
    
    // Receive displayed notifications for iOS 10 devices.
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        _ = notification.request.content.userInfo
        completionHandler([.alert, .badge, .sound])
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                didReceive response: UNNotificationResponse,
                                withCompletionHandler completionHandler: @escaping () -> Void) {
        let userInfo = response.notification.request.content.userInfo
        if UIApplication.shared.applicationState == .inactive
        {
            _ = Timer.scheduledTimer(timeInterval: 2.0, target: self, selector: #selector(delayForNotification(tempTimer:)), userInfo: userInfo, repeats: false)
        }
        else
        {
            notificationHandler(userInfo as! [String : Any])
        }
        
        completionHandler()
    }
    
    @objc func delayForNotification(tempTimer:Timer)
    {
        notificationHandler(tempTimer.userInfo as! [String : Any])
    }
    
    //Redirect to screen
    func notificationHandler(_ dict : [String : Any])
    {
        if !isUserLogin()
        {
            return
        }
        print(dict)
        
        let aps = dict["aps"] as! [String : Any]
        let dict_type = aps["noti_for"] as! [String : Any]
        
        if dict_type["noti_type"] as! String == "order_placed"  {
            //Listener will get notification when he/she get request
            if let order_id : Int = dict_type["order_id"] as? Int
            {
                setFeedbackRequestValue(value: true)
                setOrderId(value: order_id)
                NotificationCenter.default.post(name: NSNotification.Name.init(NOTIFICATION.REDIRECT_TO_GIVE_FEEDBACK), object: nil)
            }
        }
        else if dict_type["noti_type"] as! String == "feedback_received" {
            //Musician will get notification when he/she get feedback on his/her track
            if let order_id : Int = dict_type["order_id"] as? Int
            {
                setFeedbackReceivedValue(value: true)
                setOrderId(value: order_id)
                NotificationCenter.default.post(name: NSNotification.Name.init(NOTIFICATION.REDICT_TAB_BAR), object: ["tabIndex" : 1])
            }
        }
        else if dict_type["noti_type"] as! String == "rating_received" {
            //Listner will get notification when he/she get feedback from Musician
            if let order_id : Int = dict_type["order_id"] as? Int
            {
                setRatingReceivedValue(value: true)
                setOrderId(value: order_id)
                NotificationCenter.default.post(name: NSNotification.Name.init(NOTIFICATION.REDICT_TAB_BAR), object: ["tabIndex" : 1])
            }
        }
        else {
            NotificationCenter.default.post(name: NSNotification.Name.init(NOTIFICATION.REDICT_TAB_BAR), object: ["tabIndex" : 0])
        }
        
    }
}
/**
 * Get Top View Control
 *
 * Find the top view controller from queue and return it.
 * It's used in global function whenever need active View controller
 *
 * @param
 */
extension UIApplication {
    class func topViewController(base: UIViewController? = (UIApplication.shared.delegate as! AppDelegate).window?.rootViewController) -> UIViewController? {
        if let nav = base as? UINavigationController {
            return topViewController(base: nav.visibleViewController)
        }
        if let tab = base as? UITabBarController {
            if let selected = tab.selectedViewController {
                return topViewController(base: selected)
            }
        }
        if let presented = base?.presentedViewController {
            return topViewController(base: presented)
        }
        return base
    }
}
