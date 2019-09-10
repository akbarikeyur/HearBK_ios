    
//  Cozy Up
//
//  Created by Amisha on 15/10/18.
//  Copyright © 2018 Amisha. All rights reserved.
//

import Foundation
import SystemConfiguration
import Alamofire
import AlamofireJsonToObjects

let CLIENT_ID = "1"
let CLIENT_SECRET = "cBt0yIIZEH2GQlTUli457Pmw8Uo4VVW1R9irrROc"

//Development
struct API {
    static let BASE_URL = "https://api.hearbk.com/api/"
    
    static let USER_LOGIN           =       "https://api.hearbk.com/api/oauth/token"
    static let REGISTER_USER        =       BASE_URL + "user/register"
    static let BECOME_LISTNER       =       BASE_URL + "becomeListener"
    static let LISTNER_TAG_LIST     =       BASE_URL + "listenerTagList"
    
    static let GET_LOGIN_USERDATA   =       BASE_URL + "user"
    static let FORGOT_PASSWORD      =       BASE_URL + "user/password/request"
    static let RESET_PASSWORD       =       BASE_URL + "user/password/reset"
    static let UPDATE_USER          =       BASE_URL + "user/update"
    static let MY_PROFILE_PAYPAL    =       BASE_URL + "myProfilePaypal"
    static let LOG_OUT              =       BASE_URL + "logout"
    static let CHECK_LOGIN          =       BASE_URL + "checkLogin"
    
    static let GUEST_FEATURED_LISTENERS  =       BASE_URL + "guestFeaturedListeners"
    static let GUEST_SEARCH_LISTNER      =       BASE_URL + "guestSearchListner"
    static let MY_PROFILE_ABOUT     =       BASE_URL + "myProfileAbout"
    static let MY_PROFILE_REVIEW    =       BASE_URL + "myProfileReviews"
    static let MY_PROFILE_TRACK     =       BASE_URL + "myProfileTracks"
    static let MY_PROFILE_INSIGHT      =       BASE_URL + "myProfileInsights"
    static let MY_PROFILE_EXPERIENCE    =       BASE_URL + "myProfileExperience"
    
    static let GUEST_USERDATA          =       BASE_URL + "guestUser"
    static let GUEST_PROFILE_ABOUT     =       BASE_URL + "guestProfileAbout"
    static let GUEST_PROFILE_REVIEW    =       BASE_URL + "guestProfileReviews"
    static let GUEST_PROFILE_TRACK     =       BASE_URL + "guestProfileTracks"
    static let GUEST_PROFILE_INSIGHT   =       BASE_URL + "guestProfileInsights"
    
    static let SEARCH_LISTNER       =       BASE_URL + "searchListner"
    static let ADVANCE_SEARCH_LISTNER  =    BASE_URL + "searchAdvacncedListner"
    static let RATE_LISTENER        =       BASE_URL + "rateListener"
    
    static let ADD_FAVORITE         =       BASE_URL + "addToFavorite"
    static let REMOVE_FAVORITE      =       BASE_URL + "removeToFavorite"
    static let GET_FAVORITE         =       BASE_URL + "myFavorites"
    
    static let GIVE_FEEDBACK        =       BASE_URL + "giveFeedback"
    
    static let ADD_CARD             =       BASE_URL + "addCard"
    static let GET_CARD             =       BASE_URL + "cardLists"
    static let DELETE_CARD          =       BASE_URL + "deleteCard"
    static let ADD_FUND             =       BASE_URL + "addFunds"
    static let ADD_FUND_SAVE_CARD   =       BASE_URL + "addFundsBySavedCard"
    static let UPGRADE_ACCOUNT      =       BASE_URL + "upgradeAccount"
    
    static let PLACE_ORDER          =       BASE_URL + "placeOrder"
    
    static let GET_FEEDBACK_REQUEST =       BASE_URL + "feedbackRequests"
    
    static let FEATURED_LISTENERS   =       BASE_URL + "featuredListeners"
    static let GET_EARNING_HISTORY  =       BASE_URL + "myEarnings"
    
    static let GET_TRACK_DETAIL     =       BASE_URL + "getTrackDetail"
    
}


public class APIManager {
    
    static let shared = APIManager()
    
    class func isConnectedToNetwork() -> Bool {
        var zeroAddress = sockaddr_in()
        zeroAddress.sin_len = UInt8(MemoryLayout.size(ofValue: zeroAddress))
        zeroAddress.sin_family = sa_family_t(AF_INET)
        let defaultRouteReachability = withUnsafePointer(to: &zeroAddress) {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {zeroSockAddress in
                SCNetworkReachabilityCreateWithAddress(nil, zeroSockAddress)
            }
        }
        var flags = SCNetworkReachabilityFlags()
        if !SCNetworkReachabilityGetFlags(defaultRouteReachability!, &flags) {
            return false
        }
        let isReachable = (flags.rawValue & UInt32(kSCNetworkFlagsReachable)) != 0
        let needsConnection = (flags.rawValue & UInt32(kSCNetworkFlagsConnectionRequired)) != 0
        return (isReachable && !needsConnection)
    }
    
    func getJsonHeader() -> [String:String]{
        return ["Content-Type":"application/json", "Accept" : "application/json"]
    }
    
    func getMultipartHeader() -> [String:String]{
        return ["Content-Type":"multipart/form-data", "Accept" : "application/json"]
    }
    
    func getJsonHeaderWithToken() -> [String:String]{
        return ["Content-Type":"application/json", "Authorization": "Bearer " + getAccessToekn(), "Accept" : "application/json"]
    }
    
    func getMultipartHeaderWithToken() -> [String:String]{
        return ["Content-Type":"multipart/form-data", "Authorization": "Bearer " + getAccessToekn(), "Accept" : "application/json"]
    }
    
    func networkErrorMsg()
    {
        removeLoader()
        showAlert("HearBK", message: "You are not connected to the internet") {
            
        }
    }
    
    func toJson(_ dict:[String:Any]) -> String {
        let jsonData = try? JSONSerialization.data(withJSONObject: dict, options: [])
        let jsonString = String(data: jsonData!, encoding: .utf8)
        return jsonString!
    }
    
//    func isServiceError(_ code: Int?) -> Bool{
//        if(code == 401    )
//        {
//            AppDelegate().sharedDelegate().logoutApp()
//            return true
//        }
//        return false
//    }
    
    //MARK:- Login Module
    func serviceCallToLogin(_ isSocial:Bool, _ completion: @escaping () -> Void) {
        
        if !APIManager.isConnectedToNetwork()
        {
            networkErrorMsg()
            return
        }
        
        showLoader()
        var headerParams :[String : String] = getJsonHeader()
        var params : [String : Any] = [String : Any]()
        
        params["client_id"] = CLIENT_ID
        params["client_secret"] = CLIENT_SECRET
        if isSocial {
            params["grant_type"] = "social"
            params["provider"] = "facebook"
        }
        else
        {
            params["grant_type"] = "password"
            params["username"] = AppModel.shared.currentUser.email
            params["password"] = AppModel.shared.currentUser.password
        }
        
        if AppDelegate().sharedDelegate().deviceToken != ""
        {
            params["deviceId"] = AppDelegate().sharedDelegate().deviceToken
            params["deviceType"] = "i"
        }
        
        if PLATFORM.isSimulator
        {
            params["deviceId"] = "0B79A7DA4BF6DA97875B47AB77F196536076641EA0250CC47DF1EA1CC35718C1"
            params["deviceType"] = "i"
        }
        
        print(params)
        
        Alamofire.request(API.USER_LOGIN, method: .post, parameters: params, encoding: JSONEncoding.default, headers: headerParams).responseJSON { (response) in
            
            removeLoader()
            
            switch response.result {
            case .success:
                print(response.result.value!)
                if let result : [String : Any] = response.result.value as? [String : Any]
                {
                    
                    if let status = result["status"] as? Int, status == 0
                    {
                        showAlertWithOption("HearBK", message: "You are currently logged in on another device. Would you like to logout there and continue on this device?", btns: ["YES", "NO"], completionConfirm: {
                            params["email"] = AppModel.shared.currentUser.email
                            self.serviceCallToCheckLogin(params, {
                                completion()
                            })
                        }, completionCancel: {
                            return
                        })
                    }
                    else if let token_type : String = result["token_type"] as? String, token_type == "Bearer"
                    {
                        if let access_token : String = result["access_token"] as? String
                        {
                            setAccessToekn(access_token)
                        }
                        if let refresh_token : String = result["refresh_token"] as? String
                        {
                            setRefreshToekn(refresh_token)
                        }
                        setIsUserLogin(isUserLogin: true)
                        AppDelegate().sharedDelegate().GetListnerTag()
                        self.serviceCallToGetLoginUserData({ (status) in
                            
                        })
                        completion()
                        return
                    }
                    else if let errors : [String : Any] = result["errors"] as? [String : Any]
                    {
                        let firstkey = Array(errors.keys)[0]
                        if let messageArr : [String] = errors[firstkey] as? [String]
                        {
                            displayToast(messageArr[0])
                        }
                        return
                    }
                    else if let message : String = result["message"] as? String
                    {
                        displayToast(message)
                        return
                    }
                }
                
                if let error = response.result.error
                {
                    displayToast(error.localizedDescription)
                    return
                }
                break
            case .failure(let error):
                print(error)
                displayToast(error.localizedDescription)
                break
            }
        }
    }
    
    func serviceCallToFBLogin(_ access_token : String,  _ completion: @escaping (_ status : Bool) -> Void){
        if !APIManager.isConnectedToNetwork()
        {
            networkErrorMsg()
            return
        }
        showLoader()
        
        let headerParams :[String : String] = getJsonHeader()
        
        var params : [String : Any] = [String : Any]()
        params["grant_type"] = "social"
        params["provider"] = "facebook"
        params["client_id"] = CLIENT_ID
        params["client_secret"] = CLIENT_SECRET
        params["access_token"] = access_token
        if AppDelegate().sharedDelegate().deviceToken != ""
        {
            params["deviceId"] = AppDelegate().sharedDelegate().deviceToken
            params["deviceType"] = "i"
        }
        
        if PLATFORM.isSimulator
        {
            params["deviceId"] = "0B79A7DA4BF6DA97875B47AB77F196536076641EA0250CC47DF1EA1CC35718CC"
            params["deviceType"] = "i"
        }
        print(params)
        
        Alamofire.request(API.USER_LOGIN, method: .post, parameters: params, encoding: JSONEncoding.default, headers: headerParams).responseJSON { (response) in
            
            removeLoader()
            
            switch response.result {
            case .success:
                print(response.result.value!)
                if let result : [String : Any] = response.result.value as? [String : Any]
                {
                    if let message : String = result["message"] as? String, message == "Unauthenticated." {
                        AppDelegate().sharedDelegate().continueToLogout()
                        return
                    }
                    else if let token_type : String = result["token_type"] as? String, token_type == "Bearer"
                    {
                        if let access_token : String = result["access_token"] as? String
                        {
                            setAccessToekn(access_token)
                        }
                        if let refresh_token : String = result["refresh_token"] as? String
                        {
                            setRefreshToekn(refresh_token)
                        }
                        self.serviceCallToGetLoginUserData({ (status) in
                            completion(status)
                            return
                        })
                        
                    }
                    else if let errors : [String : Any] = result["errors"] as? [String : Any]
                    {
                        let firstkey = Array(errors.keys)[0]
                        if let messageArr : [String] = errors[firstkey] as? [String]
                        {
                            displayToast(messageArr[0])
                        }
                        return
                    }
                    else if let message : String = result["message"] as? String
                    {
                        displayToast(message)
                        return
                    }
                }
                
                if let error = response.result.error
                {
                    displayToast(error.localizedDescription)
                    return
                }
                break
            case .failure(let error):
                print(error)
                break
            }
        }
    }
    
    func serviceCallToSignUp(_ params : [String : Any],_ completion: @escaping () -> Void) {
        if !APIManager.isConnectedToNetwork()
        {
            networkErrorMsg()
            return
        }
        showLoader()
        
        let headerParams :[String : String] = APIManager.shared.getMultipartHeader()
        print(headerParams)
        print(API.REGISTER_USER)
        Alamofire.upload(multipartFormData: { (multipartFormData) in
            for (key, value) in params {
                multipartFormData.append("\(value)".data(using: String.Encoding.utf8)!, withName: key as String)
            }
            
        }, usingThreshold: UInt64.init(), to: API.REGISTER_USER, method: .post
        , headers: headerParams) { (result) in
            switch result{
            case .success(let upload, _, _):
                upload.uploadProgress(closure: { (Progress) in
                    print("Upload Progress: \(Progress.fractionCompleted)")
                })
                
                upload.responseJSON { (response) in
                    removeLoader()
                    switch response.result {
                    case .success:
                        print(response.result.value!)
                        if let result : [String : Any] = response.result.value as? [String : Any]
                        {
                            if let data : [String : Any] = result["data"] as? [String : Any]
                            {
                                AppModel.shared.currentUser = UserModel.init(dict: data)
                                if let password : String = params["password"] as? String
                                {
                                    AppModel.shared.currentUser.password = password
                                }
                                setLoginUserData(AppModel.shared.currentUser.dictionary())
                                
                                
                                if let token_type : [String : Any] = data["tokenDetails"] as? [String : Any], token_type["token_type"] as! String == "Bearer"
                                {
                                    if let access_token : String = token_type["access_token"] as? String
                                    {
                                        setAccessToekn(access_token)
                                    }
                                    if let refresh_token : String = token_type["refresh_token"] as? String
                                    {
                                        setRefreshToekn(refresh_token)
                                    }
                                    
                                }
                                AppDelegate().sharedDelegate().GetListnerTag()
                                completion()
                                return
                            }
                            else if let errors : [String : Any] = result["errors"] as? [String : Any]
                            {
                                let firstkey = Array(errors.keys)[0]
                                if let messageArr : [String] = errors[firstkey] as? [String]
                                {
                                    displayToast(messageArr[0])
                                }
                                return
                            }
                        }
                        if let error = response.result.error
                        {
                            displayToast(error.localizedDescription)
                            return
                        }
                        break
                    case .failure(let error):
                        print(error)
                        displayToast(error.localizedDescription)
                        break
                    }
                }
            case .failure(let error):
                removeLoader()
                displayToast(error.localizedDescription)
                break
            }
        }
    }
    
    func serviceCallToBecomeListner(_ imageData : Data,_ params : [String : Any],_ completion: @escaping () -> Void) {
        if !APIManager.isConnectedToNetwork()
        {
            networkErrorMsg()
            return
        }
        showLoader()
        
        let headerParams :[String : String] = APIManager.shared.getJsonHeaderWithToken()
        print(params)
        Alamofire.upload(multipartFormData: { (multipartFormData) in
            for (key, value) in params {
                multipartFormData.append("\(value)".data(using: String.Encoding.utf8)!, withName: key as String)
            }
            
            if imageData.count != 0
            {
                multipartFormData.append(imageData, withName: "profile_image", fileName: "image.png", mimeType: "image/png")
            }
        }, usingThreshold: UInt64.init(), to: API.BECOME_LISTNER, method: .post
        , headers: headerParams) { (result) in
            switch result{
            case .success(let upload, _, _):
                upload.uploadProgress(closure: { (Progress) in
                    print("Upload Progress: \(Progress.fractionCompleted)")
                })
                
                upload.responseJSON { (response) in
                    removeLoader()
                    switch response.result {
                    case .success:
                        print(response.result.value!)
                        if let result : [String : Any] = response.result.value as? [String : Any]
                        {
                            if let status : Int = result["status"] as? Int
                            {
                                if status == 1 {
                                    completion()
                                    return
                                } else {
                                    let message : String = result["message"] as! String
                                    displayToast(message)
                                    return
                                }
                            }
                            else if let errors : [String : Any] = result["errors"] as? [String : Any]
                            {
                                let firstkey = Array(errors.keys)[0]
                                if let messageArr : [String] = errors[firstkey] as? [String]
                                {
                                    displayToast(messageArr[0])
                                }
                                return
                            }
                        }
                        
                        if let error = response.result.error
                        {
                            displayToast(error.localizedDescription)
                            return
                        }
                        
                        break
                    case .failure(let error):
                        print(error)
                        displayToast(error.localizedDescription)
                        break
                    }
                }
            case .failure(let error):
                removeLoader()
                displayToast(error.localizedDescription)
                break
            }
        }
    }
    
    func serviceCallToListnerTagList(_ completion: @escaping () -> Void) {
        let headerParams :[String : String] = APIManager.shared.getJsonHeaderWithToken()
        print(headerParams)
        Alamofire.request(API.LISTNER_TAG_LIST, method: .get, parameters: [String : Any](), encoding: JSONEncoding.default, headers: headerParams).responseJSON { (response) in
            
            switch response.result {
            case .success:
                if let result : [String : Any] = response.result.value as? [String : Any]
                {
                    AppModel.shared.LISTNER_TAG = []
                    if let message : String = result["message"] as? String, message == "Unauthenticated." {
                        AppDelegate().sharedDelegate().continueToLogout()
                        return
                    }
                    else if let data : [String] = result["tag_list"] as? [String] {
                        AppModel.shared.LISTNER_TAG = data
                        NotificationCenter.default.post(name: NSNotification.Name.init(NOTIFICATION.TAG_RELOAD), object: nil)
                        completion()
                        return
                    }
                    else {
                        completion()
                        return
                    }
                }
                if let error = response.result.error
                {
                    displayToast(error.localizedDescription)
                    return
                }
                break
            case .failure(let error) :
                print(error)
                break
            }
        }
    }
    
    
    func serviceCallToGetLoginUserData(_ completion: @escaping (_ status : Bool) -> Void) {
        if !isUserLogin()  {
            return
        }
        
        let headerParams : [String : String] = APIManager.shared.getJsonHeaderWithToken()
        var param :[String : Any] = [String : Any]()
        param["user_id"] = ""
        Alamofire.request(API.GET_LOGIN_USERDATA, method: .post, parameters: param, encoding: JSONEncoding.default, headers: headerParams).responseJSON { (response) in
            
            removeLoader()
            
            switch response.result {
            case .success:
                print(response.result.value!)
                if let result : [String : Any] = response.result.value as? [String : Any]
                {
                    if let message : String = result["message"] as? String, message == "Unauthenticated." {
                        AppDelegate().sharedDelegate().continueToLogout()
                        return
                    }
                    else if let data : [String : Any] = result["data"] as? [String : Any] {
                        
                        let user : UserModel = UserModel.init(dict: data)
                        if user.fields_needed.count == 0
                        {
                            AppModel.shared.currentUser = UserModel.init(dict: data)
                            print(AppModel.shared.currentUser.dictionary())
                            setLoginUserData(AppModel.shared.currentUser.dictionary())
                            NotificationCenter.default.post(name: NSNotification.Name.init(NOTIFICATION.UPDATE_CURRENT_USER_DATA), object: nil)
                            completion(true)
                        }
                        else
                        {
                            completion(false)
                        }
                        return
                    }
                    else {
                        completion(false)
                        return
                    }
                }
                if let error = response.result.error
                {
                    displayToast(error.localizedDescription)
                    return
                }
                break
            case .failure(let error):
                print(error)
                break
            }
        }
    }
    
    func serviceCallToGetOtherUserData(_ uID : String, _ completion: @escaping (_ user : UserModel) -> Void) {
        if !APIManager.isConnectedToNetwork()
        {
            networkErrorMsg()
            return
        }
        let headerParams : [String : String] = (isUserLogin() ? APIManager.shared.getJsonHeaderWithToken() : APIManager.shared.getJsonHeader())
        print(headerParams)
        var param :[String : Any] = [String : Any]()
        param["user_id"] = uID
        if uID != ""
        {
            showLoader()
        }
        Alamofire.request((isUserLogin() ? API.GET_LOGIN_USERDATA : API.GUEST_USERDATA), method: .post, parameters: param, encoding: JSONEncoding.default, headers: headerParams).responseJSON { (response) in
            removeLoader()
            switch response.result {
            case .success:
                print(response.result.value!)
                if let result : [String : Any] = response.result.value as? [String : Any]
                {
                    if let message : String = result["message"] as? String, message == "Unauthenticated." {
                        AppDelegate().sharedDelegate().continueToLogout()
                        return
                    }
                    else if let data : [String : Any] = result["data"] as? [String : Any] {
                        completion(UserModel.init(dict: data))
                        return
                    }
                    else {
                        completion(UserModel.init())
                        return
                    }
                }
                if let error = response.result.error
                {
                    displayToast(error.localizedDescription)
                    return
                }
                break
            case .failure(let error):
                print(error)
                break
            }
        }
    }
    
    func serviceCallToForgotPassword(_ params : [String : Any], _ completion: @escaping () -> Void) {
        if !APIManager.isConnectedToNetwork()
        {
            networkErrorMsg()
            return
        }
        showLoader()
        
        let headerParams :[String : String] = APIManager.shared.getJsonHeader()
        
        Alamofire.request(API.FORGOT_PASSWORD, method: .post, parameters: params, encoding: JSONEncoding.default, headers: headerParams).responseJSON { (response) in
            
            removeLoader()
            
            switch response.result {
            case .success:
                print(response.result.value!)
                if let result : [String : Any] = response.result.value as? [String : Any]
                {
                    if let message : String = result["message"] as? String, message == "Unauthenticated." {
                        AppDelegate().sharedDelegate().continueToLogout()
                        return
                    }
                    else if let errors : [String : Any] = result["errors"] as? [String : Any]
                    {
                        let firstkey = Array(errors.keys)[0]
                        if let messageArr : [String] = errors[firstkey] as? [String]
                        {
                            displayToast(messageArr[0])
                        }
                        return
                    }
                    else if let message : String = result["message"] as? String
                    {
                        if message == "We have e-mailed you code!"
                        {
                            completion()
                        }
                        else
                        {
                            displayToast(message)
                        }
                        return
                    }
                }
                
                if let error = response.result.error
                {
                    displayToast(error.localizedDescription)
                    return
                }
                break
            case .failure(let error):
                print(error)
                break
            }
        }
    }
    
    func serviceCallToResetPassword(_ params : [String : Any], _ completion: @escaping () -> Void){
        if !APIManager.isConnectedToNetwork()
        {
            networkErrorMsg()
            return
        }
        showLoader()
        
        let headerParams :[String : String] = APIManager.shared.getJsonHeader()
        
        Alamofire.request(API.RESET_PASSWORD, method: .post, parameters: params, encoding: JSONEncoding.default, headers: headerParams).responseJSON { (response) in
            
            removeLoader()
            
            switch response.result {
            case .success:
                print(response.result.value!)
                if let result : [String : Any] = response.result.value as? [String : Any]
                {
                    print(result)
                    completion()
                    return
                }
                
                if let error = response.result.error
                {
                    displayToast(error.localizedDescription)
                    return
                }
                break
            case .failure(let error):
                print(error)
                break
            }
        }
    }
    
    func serviceCallToLogOut(_ completion: @escaping () -> Void) {
        if !APIManager.isConnectedToNetwork()
        {
            networkErrorMsg()
            return
        }
        let headerParams :[String : String] = APIManager.shared.getMultipartHeaderWithToken()
        print(headerParams)
        Alamofire.request(API.LOG_OUT, method: .post, parameters: [String : Any](), encoding: JSONEncoding.default, headers: headerParams).responseJSON { (response) in
            
            switch response.result {
            case .success:
                print(response.result.value!)
                if let result : [String : Any] = response.result.value as? [String : Any]
                {
                    if let message : String = result["message"] as? String, message == "Unauthenticated." {
                        AppDelegate().sharedDelegate().continueToLogout()
                        return
                    }
                    else if let status : Int = result["status"] as? Int, status == 1
                    {
                        if let message : String = result["message"] as? String
                        {
                            print(message)
                        }
                        completion()
                        return
                    }
                    else if let errors : [String : Any] = result["errors"] as? [String : Any]
                    {
                        let firstkey = Array(errors.keys)[0]
                        if let messageArr : [String] = errors[firstkey] as? [String]
                        {
                            displayToast(messageArr[0])
                        }
                        return
                    }
                }
                if let error = response.result.error
                {
                    print(error)
                    //displayToast(error.localizedDescription)
                    return
                }
                break
            case .failure(let error):
                print(error)
                break
            }
        }
    }
    
    func serviceCallToCheckLogin(_ param : [String : Any],_ completion: @escaping () -> Void) {
        if !APIManager.isConnectedToNetwork()
        {
            networkErrorMsg()
            return
        }
        let headerParams :[String : String] = APIManager.shared.getJsonHeaderWithToken()
        print(headerParams)
        Alamofire.request(API.CHECK_LOGIN, method: .post, parameters: param, encoding: JSONEncoding.default, headers: headerParams).responseJSON { (response) in
            
            switch response.result {
            case .success:
                print(response.result.value!)
                if let result : [String : Any] = response.result.value as? [String : Any]
                {
                    if let message : String = result["message"] as? String, message == "Unauthenticated." {
                        AppDelegate().sharedDelegate().continueToLogout()
                        return
                    }
                    else if let tokendata : [String : Any] = result["tokenDetails"] as? [String : Any] {
                        if let token_type : String = tokendata["token_type"] as? String, token_type == "Bearer"
                        {
                            if let access_token : String = tokendata["access_token"] as? String
                            {
                                setAccessToekn(access_token)
                            }
                            if let refresh_token : String = tokendata["refresh_token"] as? String
                            {
                                setRefreshToekn(refresh_token)
                            }
                        }
                    }
                    
                    if let data : [String : Any] = result["data"] as? [String : Any] {
                        AppModel.shared.currentUser = UserModel.init(dict: data)
                        AppDelegate().sharedDelegate().GetListnerTag()
                        completion()
                        return
                    }
                }
                if let error = response.result.error
                {
                    displayToast(error.localizedDescription)
                    return
                }
                break
            case .failure(let error):
                print(error)
                break
            }
        }
    }
    
    //MARK:- Profile Data
    
    func serviceCallToMyProfileExperience(_ params : [String : Any],_ completion: @escaping () -> Void) {
        if !APIManager.isConnectedToNetwork()
        {
            networkErrorMsg()
            return
        }
        let headerParams :[String : String] = APIManager.shared.getJsonHeaderWithToken()
        print(headerParams)

        Alamofire.request(API.MY_PROFILE_EXPERIENCE, method: .post, parameters: params, encoding: JSONEncoding.default, headers: headerParams).responseJSON { (response) in

            switch response.result {
            case .success:
                print(response.result.value!)
                if let result : [String : Any] = response.result.value as? [String : Any]
                {
                    if let message : String = result["message"] as? String, message == "Unauthenticated." {
                        AppDelegate().sharedDelegate().continueToLogout()
                        return
                    }
                    else if let status : Int = result["status"] as? Int , status == 1 {
                        if let message : String = result["message"] as? String  {
                            // displayToast(message)
                        }
                        completion()
                        return
                    }
                }
                if let error = response.result.error
                {
                    displayToast(error.localizedDescription)
                    return
                }
                break
            case .failure(let error):
                print(error)
                break
            }
        }
    }
    
    func serviceCallToUpdateUserDetail(_ imageData : Data?, _ params : [String : Any],_ completion: @escaping () -> Void) {
        if !APIManager.isConnectedToNetwork()
        {
            networkErrorMsg()
            return
        }
        showLoader()
        
        let headerParams : [String : String] = APIManager.shared.getMultipartHeaderWithToken()
        print(headerParams)
        print(params)
        
        Alamofire.upload(multipartFormData: { (multipartFormData) in
            for (key, value) in params {
                multipartFormData.append("\(value)".data(using: String.Encoding.utf8)!, withName: key as String)
            }
            if imageData != nil && imageData!.count > 0
            {
                multipartFormData.append(imageData!, withName: "image", fileName: "image.png", mimeType: "image/png")
            }
        }, usingThreshold: UInt64.init(), to: API.UPDATE_USER, method: .post
        , headers: headerParams) { (result) in
            switch result{
            case .success(let upload, _, _):
                upload.uploadProgress(closure: { (Progress) in
                    print("Upload Progress: \(Progress.fractionCompleted)")
                })
                
                upload.responseJSON { (response) in
                    removeLoader()
                    switch response.result {
                    case .success:
                        print(response.result.value!)
                        if let result : [String : Any] = response.result.value as? [String : Any]
                        {
                            if let message : String = result["message"] as? String, message == "Unauthenticated." {
                                AppDelegate().sharedDelegate().continueToLogout()
                                return
                            }
                            else if let status : Int = result["status"] as? Int , status == 1
                            {
                                completion()
                                return
                            }
                            else if let errors : [String : Any] = result["errors"] as? [String : Any]
                            {
                                let firstkey = Array(errors.keys)[0]
                                if let messageArr : [String] = errors[firstkey] as? [String]
                                {
                                    displayToast(messageArr[0])
                                }
                                return
                            }
                            else if let message : String = result["message"] as? String
                            {
                                displayToast(message)
                                return
                            }
                        }
                        
                        if let error = response.result.error
                        {
                            displayToast(error.localizedDescription)
                            return
                        }
                        
                        break
                    case .failure(let error):
                        print(error)
                        displayToast(error.localizedDescription)
                        break
                    }
                }
            case .failure(let error):
                removeLoader()
                displayToast(error.localizedDescription)
                break
            }
        }
        
    }
    
    func serviceCallToUpdateUserPaypalDetail(_ params : [String : Any],_ completion: @escaping () -> Void) {
        if !APIManager.isConnectedToNetwork()
        {
            networkErrorMsg()
            return
        }
        showLoader()
        
        let headerParams : [String : String] = APIManager.shared.getMultipartHeaderWithToken()
        print(headerParams)
        print(params)
        
        Alamofire.upload(multipartFormData: { (multipartFormData) in
            for (key, value) in params {
                multipartFormData.append("\(value)".data(using: String.Encoding.utf8)!, withName: key as String)
            }
        }, usingThreshold: UInt64.init(), to: API.MY_PROFILE_PAYPAL, method: .post
        , headers: headerParams) { (result) in
            switch result{
            case .success(let upload, _, _):
                upload.uploadProgress(closure: { (Progress) in
                    print("Upload Progress: \(Progress.fractionCompleted)")
                })
                
                upload.responseJSON { (response) in
                    removeLoader()
                    switch response.result {
                    case .success:
                        print(response.result.value!)
                        if let result : [String : Any] = response.result.value as? [String : Any]
                        {
                            if let message : String = result["message"] as? String, message == "Unauthenticated." {
                                AppDelegate().sharedDelegate().continueToLogout()
                                return
                            }
                            else if let status : Int = result["status"] as? Int , status == 1
                            {
                                completion()
                                return
                            }
                            else if let errors : [String : Any] = result["errors"] as? [String : Any]
                            {
                                let firstkey = Array(errors.keys)[0]
                                if let messageArr : [String] = errors[firstkey] as? [String]
                                {
                                    displayToast(messageArr[0])
                                }
                                return
                            }
                            else if let message : String = result["message"] as? String
                            {
                                displayToast(message)
                                return
                            }
                        }
                        
                        if let error = response.result.error
                        {
                            displayToast(error.localizedDescription)
                            return
                        }
                        
                        break
                    case .failure(let error):
                        print(error)
                        displayToast(error.localizedDescription)
                        break
                    }
                }
            case .failure(let error):
                removeLoader()
                displayToast(error.localizedDescription)
                break
            }
        }
        
    }
    
    //MARK:- Search Listener
    func serviceCallToSearchListner(_ params : [String : Any],_ completion: @escaping (_ data : [[String : Any]],_ totapPage : Int) -> Void) {
        if !APIManager.isConnectedToNetwork()
        {
            networkErrorMsg()
            return
        }
        showLoader()
        
        let headerParams : [String : String] = (isUserLogin() ? APIManager.shared.getMultipartHeaderWithToken() : APIManager.shared.getMultipartHeader())
        
        Alamofire.upload(multipartFormData: { (multipartFormData) in
            for (key, value) in params {
                multipartFormData.append("\(value)".data(using: String.Encoding.utf8)!, withName: key as String)
            }
        }, usingThreshold: UInt64.init(), to: (isUserLogin() ? API.SEARCH_LISTNER : API.GUEST_SEARCH_LISTNER), method: .post
        , headers: headerParams) { (result) in
            switch result{
            case .success(let upload, _, _):
                
                
                upload.responseJSON { (response) in
                    removeLoader()
                    switch response.result {
                    case .success:
                        print(response.result.value!)
                        if let result : [String : Any] = response.result.value as? [String : Any]
                        {
                            if let message : String = result["message"] as? String, message == "Unauthenticated." {
                                AppDelegate().sharedDelegate().continueToLogout()
                                return
                            }
                            else if let arrData : [[String : Any]] = result["listeners_list"] as? [[String : Any]]
                            {
                                if let totalpage : Int = result["totalPages"] as? Int {
                                    
                                    completion(arrData, totalpage)
                                    return
                                }
                                
                            }
                            else if let errors : [String : Any] = result["errors"] as? [String : Any]
                            {
                                let firstkey = Array(errors.keys)[0]
                                if let messageArr : [String] = errors[firstkey] as? [String]
                                {
                                    displayToast(messageArr[0])
                                }
                                return
                            }
                            else if let message : String = result["message"] as? String
                            {
                                displayToast(message)
                                return
                            }
                        }
                        
                        if let error = response.result.error
                        {
                            displayToast(error.localizedDescription)
                            return
                        }
                        break
                    case .failure(let error):
                        print(error)
                        displayToast(error.localizedDescription)
                        break
                    }
                }
            case .failure(let error):
                removeLoader()
                displayToast(error.localizedDescription)
                break
            }
        }
    }
    
    
    func serviceCallToAdvanceSearchListner(_ params : [String : Any],_ completion: @escaping (_ data : [[String : Any]],_ totalpage : Int) -> Void) {
        
        if !APIManager.isConnectedToNetwork()
        {
            networkErrorMsg()
            return
        }
        showLoader()

        let headerParams : [String : String] = APIManager.shared.getJsonHeaderWithToken()
        
        Alamofire.request(API.ADVANCE_SEARCH_LISTNER, method: .post, parameters: params, encoding: JSONEncoding.default, headers: headerParams).responseJSON { (response) in

            removeLoader()

            switch response.result {
            case .success:
                print(response.result.value!)
                if let result : [String : Any] = response.result.value as? [String : Any]
                {
                    if let message : String = result["message"] as? String, message == "Unauthenticated." {
                        AppDelegate().sharedDelegate().continueToLogout()
                        return
                    }
                    else if let arrData : [[String : Any]] = result["listeners_list"] as? [[String : Any]]
                    {
                        if let totalpage : Int = result["totalPages"] as? Int {
                            
                            completion(arrData, totalpage)
                            return
                        }
                    }
                    else if let errors : [String : Any] = result["errors"] as? [String : Any]
                    {
                        let firstkey = Array(errors.keys)[0]
                        if let messageArr : [String] = errors[firstkey] as? [String]
                        {
                            displayToast(messageArr[0])
                        }
                        return
                    }
                    else if let message : String = result["message"] as? String
                    {
                        displayToast(message)
                        return
                    }
                }

                if let error = response.result.error
                {
                    displayToast(error.localizedDescription)
                    return
                }
                break
            case .failure(let error):
                print(error)
                break
            }
        }
    }
    
    //MARK:- Profile
    func serviceCallToMyProfileAbout(_ uID : String, _ completion: @escaping (_ data : [String : Any]) -> Void) {
        
        let headerParams : [String : String] = (isUserLogin() ? APIManager.shared.getJsonHeaderWithToken() : APIManager.shared.getJsonHeader())
        var param : [String : Any] = [String : Any]()
        param["user_id"] = uID
        if uID != ""
        {
            if !APIManager.isConnectedToNetwork()
            {
                networkErrorMsg()
                return
            }
            showLoader()
        }
        Alamofire.request((isUserLogin() ? API.MY_PROFILE_ABOUT : API.GUEST_PROFILE_ABOUT), method: .post, parameters: param, encoding: JSONEncoding.default, headers: headerParams).responseJSON { (response) in
            removeLoader()
            switch response.result {
            case .success:
                print(response.result.value!)
                if let result : [String : Any] = response.result.value as? [String : Any]
                {
                    if let message : String = result["message"] as? String, message == "Unauthenticated." {
                        AppDelegate().sharedDelegate().continueToLogout()
                        return
                    }
                    else if let status : Int = result["status"] as? Int, status == 1
                    {
                        completion(result)
                        return
                    }
                    else if let errors : [String : Any] = result["errors"] as? [String : Any]
                    {
                        let firstkey = Array(errors.keys)[0]
                        if let messageArr : [String] = errors[firstkey] as? [String]
                        {
                            displayToast(messageArr[0])
                        }
                        return
                    }
                    else if let message : String = result["message"] as? String
                    {
                        displayToast(message)
                        return
                    }
                }
                
                if let error = response.result.error
                {
                    displayToast(error.localizedDescription)
                    return
                }
                break
            case .failure(let error):
                print(error)
                break
            }
        }
    }
    
    
    func serviceCallToMyProfileReviews(_ params : [String : Any],_ completion: @escaping (_ data : [[String : Any]],_ totalpage : Int) -> Void) {
        if !APIManager.isConnectedToNetwork()
        {
            networkErrorMsg()
            return
        }
        let headerParams : [String : String] = (isUserLogin() ? APIManager.shared.getJsonHeaderWithToken() : APIManager.shared.getJsonHeader())
        showLoader()
        Alamofire.request((isUserLogin() ? API.MY_PROFILE_REVIEW : API.GUEST_PROFILE_REVIEW), method: .post, parameters: params, encoding: JSONEncoding.default, headers: headerParams).responseJSON { (response) in
            removeLoader()
            switch response.result {
            case .success:
                print(response.result.value!)
                if let result : [String : Any] = response.result.value as? [String : Any]
                {
                    if let message : String = result["message"] as? String, message == "Unauthenticated." {
                        AppDelegate().sharedDelegate().continueToLogout()
                        return
                    }
                    else if let arrData : [[String : Any]] = result["reviewsList"] as? [[String : Any]]
                    {
                        if let totalpage : Int = result["totalPages"] as? Int {
                            completion(arrData, totalpage)
                            return
                        }
                    }
                    else if let errors : [String : Any] = result["errors"] as? [String : Any]
                    {
                        let firstkey = Array(errors.keys)[0]
                        if let messageArr : [String] = errors[firstkey] as? [String]
                        {
                            displayToast(messageArr[0])
                        }
                        return
                    }
                    else if let status : Int = result["status"] as? Int, status == 0
                    {
                        completion([[String : Any]](), 0)
                        return
                    }
                    else if let message : String = result["message"] as? String
                    {
                        displayToast(message)
                        return
                    }
                }
                
                if let error = response.result.error
                {
                    displayToast(error.localizedDescription)
                    return
                }
                break
            case .failure(let error):
                print(error)
                break
            }
        }
    }
    
    func serviceCallToMyProfileTracks(_ params : [String : Any],_ completion: @escaping (_ data : [[String : Any]],_ totalCount : Int) -> Void) {
        if !APIManager.isConnectedToNetwork()
        {
            networkErrorMsg()
            return
        }
        let headerParams : [String : String] = (isUserLogin() ? APIManager.shared.getJsonHeaderWithToken() : APIManager.shared.getJsonHeader())
        showLoader()
        Alamofire.request((isUserLogin() ? API.MY_PROFILE_TRACK : API.GUEST_PROFILE_TRACK), method: .post, parameters: params, encoding: JSONEncoding.default, headers: headerParams).responseJSON { (response) in
            removeLoader()
            switch response.result {
            case .success:
                print(response.result.value!)
                if let result : [String : Any] = response.result.value as? [String : Any]
                {
                    if let message : String = result["message"] as? String, message == "Unauthenticated." {
                        AppDelegate().sharedDelegate().continueToLogout()
                        return
                    }
                    else if let arrData : [[String : Any]] = result["track_list"] as? [[String : Any]]
                    {
                        if let totalcount : Int = result["totalCount"] as? Int {
                            completion(arrData, totalcount)
                            return
                        }
                    }
                    else if let errors : [String : Any] = result["errors"] as? [String : Any]
                    {
                        let firstkey = Array(errors.keys)[0]
                        if let messageArr : [String] = errors[firstkey] as? [String]
                        {
                            displayToast(messageArr[0])
                        }
                        return
                    }
                    else if let status = result["status"] as? Int, status == 0
                    {
                        completion([[String : Any]](), 0)
                        return
                    }
                    else if let message : String = result["message"] as? String
                    {
                        displayToast(message)
                        return
                    }
                }
                
                if let error = response.result.error
                {
                    displayToast(error.localizedDescription)
                    return
                }
                break
            case .failure(let error):
                print(error)
                break
            }
        }
    }
    
    func serviceCallToGetProfileInsight(_ uID : String, _ completion: @escaping (_ data : [String : Any]) -> Void) {
        if uID != ""
        {
            if !APIManager.isConnectedToNetwork()
            {
                networkErrorMsg()
                return
            }
            showLoader()
        }
        let headerParams : [String : String] = (isUserLogin() ? APIManager.shared.getJsonHeaderWithToken() : APIManager.shared.getJsonHeader())
        print(headerParams)
        var param :[String : Any] = [String : Any]()
        param["user_id"] = uID
        
        Alamofire.request((isUserLogin() ? API.MY_PROFILE_INSIGHT : API.GUEST_PROFILE_INSIGHT), method: .post, parameters: param, encoding: JSONEncoding.default, headers: headerParams).responseJSON { (response) in
            removeLoader()
            switch response.result {
            case .success:
                print(response.result.value!)
                if let result : [String : Any] = response.result.value as? [String : Any]
                {
                    if let message : String = result["message"] as? String, message == "Unauthenticated." {
                        AppDelegate().sharedDelegate().continueToLogout()
                        return
                    }
                    else if let data : [String : Any] = result["profileInsights"] as? [String : Any] {
                        completion(data)
                        return
                    }
                    else {
                        completion([String : Any]())
                        return
                    }
                }
                if let error = response.result.error
                {
                    displayToast(error.localizedDescription)
                    return
                }
                break
            case .failure(let error):
                print(error)
                break
            }
        }
    }
    
    
    //MARK:- Favorite
    func serviceCallToAddToFavorite(_ favorite_user_id : String,_ completion: @escaping (_ favorite_id : Int) -> Void) {
        if !APIManager.isConnectedToNetwork()
        {
            networkErrorMsg()
            return
        }
        let headerParams : [String : String] = APIManager.shared.getJsonHeaderWithToken()
        var params : [String : Any] = [String : Any]()
        params["favorite_user_id"] = favorite_user_id
        Alamofire.request(API.ADD_FAVORITE, method: .post, parameters: params, encoding: JSONEncoding.default, headers: headerParams).responseJSON { (response) in
            
            switch response.result {
            case .success:
                print(response.result.value!)
                if let result : [String : Any] = response.result.value as? [String : Any]
                {
                    if let status : Bool = result["status"] as? Bool, status == true
                    {
                        if let message : String = result["message"] as? String
                        {
                            displayToast(message)
                        }
                        
                        var favorite_id = -1
                        if let data : [String : Any] = result["data"] as? [String : Any]
                        {
                            if let favId : Int = data["favorite_id"] as? Int
                            {
                                favorite_id = favId
                            }
                        }
                        completion(favorite_id)
                        return
                    }
                    else if let errors : [String : Any] = result["errors"] as? [String : Any]
                    {
                        let firstkey = Array(errors.keys)[0]
                        if let messageArr : [String] = errors[firstkey] as? [String]
                        {
                            displayToast(messageArr[0])
                        }
                        return
                    }
                    else if let message : String = result["message"] as? String
                    {
                        displayToast(message)
                        return
                    }
                }
                
                if let error = response.result.error
                {
                    displayToast(error.localizedDescription)
                    return
                }
                break
            case .failure(let error):
                print(error)
                break
            }
        }
    }
    
    func serviceCallToRemoveFavorite(_ user_id : String,_ completion: @escaping () -> Void) {

        if !APIManager.isConnectedToNetwork()
        {
            networkErrorMsg()
            return
        }
        let headerParams : [String : String] = APIManager.shared.getJsonHeaderWithToken()
        var params : [String : Any] = [String : Any]()
        params["user_id"] = user_id
        Alamofire.request(API.REMOVE_FAVORITE, method: .post, parameters: params, encoding: JSONEncoding.default, headers: headerParams).responseJSON { (response) in

            switch response.result {
            case .success:
                print(response.result.value!)
                if let result : [String : Any] = response.result.value as? [String : Any]
                {
                    if let message : String = result["message"] as? String, message == "Unauthenticated." {
                        AppDelegate().sharedDelegate().continueToLogout()
                        return
                    }
                    else if let status : Bool = result["status"] as? Bool, status == true
                    {
                        if let message : String = result["message"] as? String
                        {
                            displayToast(message)
                        }
                        completion()
                        return
                    }
                    else if let errors : [String : Any] = result["errors"] as? [String : Any]
                    {
                        let firstkey = Array(errors.keys)[0]
                        if let messageArr : [String] = errors[firstkey] as? [String]
                        {
                            displayToast(messageArr[0])
                        }
                        return
                    }
                }
                
                if let error = response.result.error
                {
                    displayToast(error.localizedDescription)
                    return
                }
                break
            case .failure(let error):
                print(error)
                break
            }
        }
    }
    
    
    func serviceCallToGetMyFavorite(_ completion: @escaping (_ data : [[String : Any]]) -> Void) {
        
        showLoader()
        
        let headerParams : [String : String] = APIManager.shared.getJsonHeaderWithToken()
        
        Alamofire.request(API.GET_FAVORITE, method: .get, parameters: [String : Any](), encoding: JSONEncoding.default, headers: headerParams).responseJSON { (response) in
            
            removeLoader()
            
            switch response.result {
            case .success:
                print(response.result.value!)
                if let result : [String : Any] = response.result.value as? [String : Any]
                {
                    if let message : String = result["message"] as? String, message == "Unauthenticated." {
                        AppDelegate().sharedDelegate().continueToLogout()
                        return
                    }
                    else if let data : [[String : Any]] = result["data"] as? [[String : Any]]
                    {
                        completion(data)
                        return
                    }
                    else if let errors : [String : Any] = result["errors"] as? [String : Any]
                    {
                        let firstkey = Array(errors.keys)[0]
                        if let messageArr : [String] = errors[firstkey] as? [String]
                        {
                            displayToast(messageArr[0])
                        }
                        return
                    }
                    else if let message : String = result["message"] as? String
                    {
                        displayToast(message)
                        return
                    }
                }
                
                if let error = response.result.error
                {
                    displayToast(error.localizedDescription)
                    return
                }
                break
            case .failure(let error):
                print(error)
                break
            }
        }
    }
    
    //MARK: - Payment Method service
    func serviceCallToAddCard(_ params : [String : Any],_ completion: @escaping (_ status : Bool) -> Void) {
        if !APIManager.isConnectedToNetwork()
        {
            networkErrorMsg()
            return
        }
        showLoader()
        
        let headerParams : [String : String] = APIManager.shared.getJsonHeaderWithToken()
        
        Alamofire.request(API.ADD_CARD, method: .post, parameters: params, encoding: JSONEncoding.default, headers: headerParams).responseJSON { (response) in
            
            removeLoader()
            
            switch response.result {
            case .success:
                print(response.result.value!)
                if let result : [String : Any] = response.result.value as? [String : Any]
                {
                    if let message : String = result["message"] as? String, message == "Unauthenticated." {
                        AppDelegate().sharedDelegate().continueToLogout()
                        return
                    }
                    else if let status : Int = result["status"] as? Int, status == 1
                    {
                        if let data : [String : Any] = result["data"] as? [String : Any]
                        {
                            AppModel.shared.CARD_LIST.append(CardModel.init(dict: data))
                            setCreditCardList()
                        }
                        completion(true)
                        return
                    }
                    else if let errors : [String : Any] = result["errors"] as? [String : Any]
                    {
                        let firstkey = Array(errors.keys)[0]
                        if let messageArr : [String] = errors[firstkey] as? [String]
                        {
                            completion(false)
                            displayToast(messageArr[0])
                        }
                        return
                    }
                    else if let message : String = result["message"] as? String
                    {
                        completion(false)
                        displayToast(message)
                        return
                    }
                }
                
                if let error = response.result.error
                {
                    completion(false)
                    displayToast(error.localizedDescription)
                    return
                }
                break
            case .failure(let error):
                print(error)
                break
            }
        }
    }
    
    func serviceCallToGetCard(_ completion: @escaping (_ data : [[String : Any]]) -> Void) {
        //showLoader()
        
        let headerParams : [String : String] = APIManager.shared.getJsonHeaderWithToken()
        
        Alamofire.request(API.GET_CARD, method: .get, parameters: [String : Any](), encoding: JSONEncoding.default, headers: headerParams).responseJSON { (response) in
            
            //removeLoader()
            
            switch response.result {
            case .success:
                print(response.result.value!)
                if let result : [String : Any] = response.result.value as? [String : Any]
                {
                    if let message : String = result["message"] as? String, message == "Unauthenticated." {
                        AppDelegate().sharedDelegate().continueToLogout()
                        return
                    }
                    else if let data : [[String : Any]] = result["data"] as? [[String : Any]]
                    {
                        completion(data)
                        return
                    }
                    else if let errors : [String : Any] = result["errors"] as? [String : Any]
                    {
                        let firstkey = Array(errors.keys)[0]
                        if let messageArr : [String] = errors[firstkey] as? [String]
                        {
                            displayToast(messageArr[0])
                        }
                        return
                    }
                    else if let message : String = result["message"] as? String
                    {
                        displayToast(message)
                        return
                    }
                }
                
                if let error = response.result.error
                {
                    displayToast(error.localizedDescription)
                    return
                }
                break
            case .failure(let error):
                print(error)
                break
            }
        }
    }
    
    func serviceCallToDeleteCard(_ card_id : String,_ completion: @escaping () -> Void) {
        if !APIManager.isConnectedToNetwork()
        {
            networkErrorMsg()
            return
        }
        showLoader()
        
        let headerParams : [String : String] = APIManager.shared.getJsonHeaderWithToken()
        let params : [String : Any] = ["card_id" : card_id]
        
        Alamofire.request(API.DELETE_CARD, method: .post, parameters: params, encoding: JSONEncoding.default, headers: headerParams).responseJSON { (response) in
            
            removeLoader()
            
            switch response.result {
            case .success:
                print(response.result.value!)
                if let result : [String : Any] = response.result.value as? [String : Any]
                {
                    if let message : String = result["message"] as? String, message == "Unauthenticated." {
                        AppDelegate().sharedDelegate().continueToLogout()
                        return
                    }
                    else if let status : Int = result["status"] as? Int, status == 1
                    {
                        completion()
                        return
                    }
                    else if let errors : [String : Any] = result["errors"] as? [String : Any]
                    {
                        let firstkey = Array(errors.keys)[0]
                        if let messageArr : [String] = errors[firstkey] as? [String]
                        {
                            displayToast(messageArr[0])
                        }
                        return
                    }
                    else if let message : String = result["message"] as? String
                    {
                        displayToast(message)
                        return
                    }
                }
                
                if let error = response.result.error
                {
                    displayToast(error.localizedDescription)
                    return
                }
                break
            case .failure(let error):
                print(error)
                break
            }
        }
    }
    
    func serviceCallToAddFunds(_ params : [String : Any],_ completion: @escaping () -> Void) {
        if !APIManager.isConnectedToNetwork()
        {
            networkErrorMsg()
            return
        }
        showLoader()
        
        let headerParams : [String : String] = APIManager.shared.getJsonHeaderWithToken()
        
        Alamofire.request(API.ADD_FUND, method: .post, parameters: params, encoding: JSONEncoding.default, headers: headerParams).responseJSON { (response) in
            
            removeLoader()
            
            switch response.result {
            case .success:
                print(response.result.value!)
                if let result : [String : Any] = response.result.value as? [String : Any]
                {
                    if let message : String = result["message"] as? String, message == "Unauthenticated." {
                        AppDelegate().sharedDelegate().continueToLogout()
                        return
                    }
                    else if let status : String = result["status"] as? String
                    {
                        completion()
                        return
                    }
                    else if let errors : [String : Any] = result["errors"] as? [String : Any]
                    {
                        let firstkey = Array(errors.keys)[0]
                        if let messageArr : [String] = errors[firstkey] as? [String]
                        {
                            displayToast(messageArr[0])
                        }
                        return
                    }
                    else if let message : String = result["message"] as? String
                    {
                        displayToast(message)
                        return
                    }
                }
                
                if let error = response.result.error
                {
                    displayToast(error.localizedDescription)
                    return
                }
                break
            case .failure(let error):
                print(error)
                break
            }
        }
    }
    
    func serviceCallToAddFundsWithSaveCard(_ params : [String : Any],_ completion: @escaping () -> Void) {
        if !APIManager.isConnectedToNetwork()
        {
            networkErrorMsg()
            return
        }
        showLoader()
        
        let headerParams : [String : String] = APIManager.shared.getJsonHeaderWithToken()
        
        Alamofire.request(API.ADD_FUND_SAVE_CARD, method: .post, parameters: params, encoding: JSONEncoding.default, headers: headerParams).responseJSON { (response) in
            
            removeLoader()
            
            switch response.result {
            case .success:
                print(response.result.value!)
                if let result : [String : Any] = response.result.value as? [String : Any]
                {
                    if let message : String = result["message"] as? String, message == "Unauthenticated." {
                        AppDelegate().sharedDelegate().continueToLogout()
                        return
                    }
                    else if let status : Int = result["status"] as? Int, status == 1
                    {
                        completion()
                        return
                    }
                    else if let errors : [String : Any] = result["errors"] as? [String : Any]
                    {
                        let firstkey = Array(errors.keys)[0]
                        if let messageArr : [String] = errors[firstkey] as? [String]
                        {
                            displayToast(messageArr[0])
                        }
                        return
                    }
                    else if let message : String = result["message"] as? String
                    {
                        displayToast(message)
                        return
                    }
                }
                
                if let error = response.result.error
                {
                    displayToast(error.localizedDescription)
                    return
                }
                break
            case .failure(let error):
                print(error)
                break
            }
        }
    }
    
    //MARK:- Place Order
    func serviceCallToPlaceOrder(_ AudioData : Data?,_ params : [String : Any],_ completion: @escaping () -> Void) {
        if !APIManager.isConnectedToNetwork()
        {
            networkErrorMsg()
            return
        }
//        showLoader()
        
        let headerParams : [String : String] = APIManager.shared.getMultipartHeaderWithToken()
        print(headerParams)
        print(params)
        
        Alamofire.upload(multipartFormData: { (multipartFormData) in
            for (key, value) in params {
                multipartFormData.append("\(value)".data(using: String.Encoding.utf8)!, withName: key as String)
            }
            if AudioData != nil && AudioData!.count > 0
            {
                multipartFormData.append(AudioData!, withName: "track_file", fileName: "audio.mp3", mimeType: "audio/mp3")
            }
        }, usingThreshold: UInt64.init(), to: API.PLACE_ORDER, method: .post
        , headers: headerParams) { (result) in
            switch result{
            case .success(let upload, _, _):
                upload.uploadProgress(closure: { (Progress) in
                    print("Upload Progress: \(Progress.fractionCompleted)")
                    let value : Double = Progress.fractionCompleted
                    NotificationCenter.default.post(name: NSNotification.Name.init(NOTIFICATION.UPDATE_PROGRESS_VALUE), object: ["value" : value])
                })
                
                upload.responseJSON { (response) in
//                    removeLoader()
                    switch response.result {
                    case .success:
                        print(response.result.value!)
                        if let result : [String : Any] = response.result.value as? [String : Any]
                        {
                            if let message : String = result["message"] as? String, message == "Unauthenticated." {
                                AppDelegate().sharedDelegate().continueToLogout()
                                return
                            }
                            else if let status : Int = result["status"] as? Int, status == 1
                            {
                                completion()
                                return
                            }
                            else if let errors : [String : Any] = result["errors"] as? [String : Any]
                            {
                                let firstkey = Array(errors.keys)[0]
                                if let messageArr : [String] = errors[firstkey] as? [String]
                                {
                                    displayToast(messageArr[0])
                                }
                                return
                            }
                            else if let message : String = result["message"] as? String
                            {
                                displayToast(message)
                                return
                            }
                        }
                        
                        if let error = response.result.error
                        {
                            displayToast(error.localizedDescription)
                            return
                        }
                        
                        break
                    case .failure(let error):
                        print(error)
                        displayToast(error.localizedDescription)
                        break
                    }
                }
            case .failure(let error):
                removeLoader()
                displayToast(error.localizedDescription)
                break
            }
        }
        
    }
    
    //MARK:- Feedback
    func serviceCallToGiveFeedback(_ params : [String : Any],_ completion: @escaping () -> Void) {
        if !APIManager.isConnectedToNetwork()
        {
            networkErrorMsg()
            return
        }
        showLoader()
        
        let headerParams : [String : String] = APIManager.shared.getJsonHeaderWithToken()
        
        Alamofire.request(API.GIVE_FEEDBACK, method: .post, parameters: params, encoding: JSONEncoding.default, headers: headerParams).responseJSON { (response) in
            
            removeLoader()
            
            switch response.result {
            case .success:
                print(response.result.value!)
                if let result : [String : Any] = response.result.value as? [String : Any]
                {
                    if let message : String = result["message"] as? String, message == "Unauthenticated." {
                        AppDelegate().sharedDelegate().continueToLogout()
                        return
                    }
                    else if let status : Bool = result["status"] as? Bool, status == true
                    {
                        completion()
                        return
                    }
                    else if let errors : [String : Any] = result["errors"] as? [String : Any]
                    {
                        let firstkey = Array(errors.keys)[0]
                        if let messageArr : [String] = errors[firstkey] as? [String]
                        {
                            displayToast(messageArr[0])
                        }
                        return
                    }
                    else if let message : String = result["message"] as? String
                    {
                        displayToast(message)
                        return
                    }
                }
                
                if let error = response.result.error
                {
                    displayToast(error.localizedDescription)
                    return
                }
                break
            case .failure(let error):
                print(error)
                break
            }
        }
    }
    
    func serviceCallToGetFeedBackRequest(_ completion: @escaping (_ data : [[String : Any]]) -> Void) {
        if !APIManager.isConnectedToNetwork()
        {
            networkErrorMsg()
            return
        }
        showLoader()
        let headerParams :[String : String] = APIManager.shared.getMultipartHeaderWithToken()
        print(headerParams)
        Alamofire.request(API.GET_FEEDBACK_REQUEST, method: .post, parameters: [String : Any](), encoding: JSONEncoding.default, headers: headerParams).responseJSON { (response) in
            removeLoader()
            switch response.result {
            case .success:
                print(response.result.value!)
                if let result : [String : Any] = response.result.value as? [String : Any]
                {
                    if let message : String = result["message"] as? String, message == "Unauthenticated." {
                        AppDelegate().sharedDelegate().continueToLogout()
                        return
                    }
                    else if let data : [[String : Any]] = result["data"] as? [[String : Any]]
                    {
                        completion(data)
                        return
                    }
                    else {
                        return
                    }
                }
                if let error = response.result.error
                {
                    displayToast(error.localizedDescription)
                    return
                }
                break
            case .failure(let error):
                print(error)
                break
            }
        }
    }
    
    func serviceCallToRateListener(_ param : [String : Any],_ completion: @escaping () -> Void) {
        if !APIManager.isConnectedToNetwork()
        {
            networkErrorMsg()
            return
        }
        let headerParams : [String : String] = APIManager.shared.getMultipartHeaderWithToken()
        
        Alamofire.upload(multipartFormData: { (multipartFormData) in
            for (key, value) in param {
                multipartFormData.append("\(value)".data(using: String.Encoding.utf8)!, withName: key as String)
            }
        }, usingThreshold: UInt64.init(), to: API.RATE_LISTENER, method: .post
        , headers: headerParams) { (result) in
            switch result{
            case .success(let upload, _, _):
                
                
                upload.responseJSON { (response) in
                    removeLoader()
                    switch response.result {
                    case .success:
                        print(response.result.value!)
                        if let result : [String : Any] = response.result.value as? [String : Any]
                        {
                            if let message : String = result["message"] as? String, message == "Unauthenticated." {
                                AppDelegate().sharedDelegate().continueToLogout()
                                return
                            }
                            else if let status : Int = result["status"] as? Int {
                                if status == 1 {
                                    let message : String = (result["message"] as? String)!
                                    displayToast(message)
                                    completion()
                                    return
                                }
                            }
                            else {
                                let message : String = (result["message"] as? String)!
                                displayToast(message)
                            }
                        }
                        
                        if let error = response.result.error
                        {
                            displayToast(error.localizedDescription)
                            return
                        }
                        break
                    case .failure(let error):
                        print(error)
                        displayToast(error.localizedDescription)
                        break
                    }
                }
            case .failure(let error):
                removeLoader()
                displayToast(error.localizedDescription)
                break
            }
        }
    }
    
    //MARK:- Upgrade Account
    func serviceCallToUpgradeAccount(_ completion: @escaping () -> Void) {
        
        let headerParams :[String : String] = APIManager.shared.getJsonHeaderWithToken()
        print(headerParams)
        Alamofire.request(API.UPGRADE_ACCOUNT, method: .post, parameters: [String : Any](), encoding: JSONEncoding.default, headers: headerParams).responseJSON { (response) in
            
            switch response.result {
            case .success:
                print(response.result.value!)
                if let result : [String : Any] = response.result.value as? [String : Any]
                {
                    if let message : String = result["message"] as? String, message == "Unauthenticated." {
                        AppDelegate().sharedDelegate().continueToLogout()
                        return
                    }
                    else if let data : [String : Any] = result["data"] as? [String : Any] {
                        AppModel.shared.currentUser.account_type = 1
                        completion()
                        return
                    }
                }
                if let error = response.result.error
                {
                    displayToast(error.localizedDescription)
                    return
                }
                break
            case .failure(let error):
                print(error)
                break
            }
        }
    }
    
    //MARK: - Feature Listeners
    func serviceCallToGetFeatureListeners(_ param : [String : Any], _ completion: @escaping (_ data : [[String : Any]],_ totalpage : Int) -> Void) {
        
        if !APIManager.isConnectedToNetwork()
        {
            networkErrorMsg()
            return
        }
        
        let headerParams :[String : String] = isUserLogin() ? APIManager.shared.getJsonHeaderWithToken() : APIManager.shared.getJsonHeader()
        print(headerParams)
        showLoader()
        
        Alamofire.request((isUserLogin() ? API.FEATURED_LISTENERS : API.GUEST_FEATURED_LISTENERS), method: .post, parameters: param, encoding: JSONEncoding.default, headers: headerParams).responseJSON { (response) in
            removeLoader()
            switch response.result {
            case .success:
                print(response.result.value!)
                if let result : [String : Any] = response.result.value as? [String : Any]
                {
                    if let message : String = result["message"] as? String, message == "Unauthenticated." {
                        AppDelegate().sharedDelegate().continueToLogout()
                        return
                    }
                    else if let status : Int = result["status"] as? Int, status == 1
                    {
                        if let data : [[String : Any]] = result["listeners_list"] as? [[String : Any]] {
                            if let totalPages : Int = result["totalPages"] as? Int {
                                completion(data, totalPages)
                                return
                            }
                        }
                    }
                }
                if let error = response.result.error
                {
                    displayToast(error.localizedDescription)
                    return
                }
                break
            case .failure(let error):
                print(error)
                break
            }
        }
    }
    
    
    func serviceCallToGetGuestFeatureListeners(_ completion: @escaping (_ data : [[String : Any]],_ totalpage : Int) -> Void) {
        
        let headerParams :[String : String] = APIManager.shared.getJsonHeaderWithToken()
        print(headerParams)
        Alamofire.request(API.GUEST_FEATURED_LISTENERS, method: .post, parameters: nil, encoding: JSONEncoding.default, headers: headerParams).responseJSON { (response) in
            
            switch response.result {
            case .success:
                print(response.result.value!)
                if let result : [String : Any] = response.result.value as? [String : Any]
                {
                    if let message : String = result["message"] as? String, message == "Unauthenticated." {
                        AppDelegate().sharedDelegate().continueToLogout()
                        return
                    }
                    else if let status : Int = result["status"] as? Int, status == 1
                    {
                        if let data : [[String : Any]] = result["listeners_list"] as? [[String : Any]] {
                            if let totalPages : Int = result["totalPages"] as? Int {
                                completion(data, totalPages)
                                return
                            }
                        }
                    }
                    
                }
                if let error = response.result.error
                {
                    displayToast(error.localizedDescription)
                    return
                }
                break
            case .failure(let error):
                print(error)
                break
            }
        }
    }
    
    //MARK: - Earning History
    func serviceCallToGetMyEarningHistory(_ param : [String : Any], _ completion: @escaping (_ data : [[String : Any]], _ totalPage : Int) -> Void) {
        if !APIManager.isConnectedToNetwork()
        {
            networkErrorMsg()
            return
        }
        let headerParams :[String : String] = APIManager.shared.getJsonHeaderWithToken()
        showLoader()
        Alamofire.request(API.GET_EARNING_HISTORY, method: .post, parameters: param, encoding: JSONEncoding.default, headers: headerParams).responseJSON { (response) in
            removeLoader()
            switch response.result {
            case .success:
                print(response.result.value!)
                if let result : [String : Any] = response.result.value as? [String : Any]
                {
                    if let message : String = result["message"] as? String, message == "Unauthenticated." {
                        AppDelegate().sharedDelegate().continueToLogout()
                        return
                    }
                    else if let data : [[String : Any]] = result["myEarnings"] as? [[String : Any]]
                    {
                        if let totalpage : Int = result["totalPages"] as? Int {
                            completion(data, totalpage)
                            return
                        }
                    }
                    else {
                        return
                    }
                }
                if let error = response.result.error
                {
                    displayToast(error.localizedDescription)
                    return
                }
                break
            case .failure(let error):
                print(error)
                break
            }
        }
    }
    
    func serviceCallToGetTrackDetail(_ param : [String : Any], _ completion: @escaping (_ data : [String : Any]) -> Void) {
        if !APIManager.isConnectedToNetwork()
        {
            networkErrorMsg()
            return
        }
        let headerParams :[String : String] = APIManager.shared.getJsonHeaderWithToken()
        showLoader()
        Alamofire.request(API.GET_TRACK_DETAIL, method: .post, parameters: param, encoding: JSONEncoding.default, headers: headerParams).responseJSON { (response) in
            removeLoader()
            switch response.result {
            case .success:
                print(response.result.value!)
                if let result : [String : Any] = response.result.value as? [String : Any]
                {
                    if let message : String = result["message"] as? String, message == "Unauthenticated." {
                        AppDelegate().sharedDelegate().continueToLogout()
                        return
                    }
                    else if let data : [String : Any] = result["track_list"] as? [String : Any]
                    {
                        completion(data)
                        return
                    }
                    else {
                        return
                    }
                }
                if let error = response.result.error
                {
                    displayToast(error.localizedDescription)
                    return
                }
                break
            case .failure(let error):
                print(error)
                break
            }
        }
    }
    
}

func jsonString(_ dict : [String : Any]) -> String? {
    let jsonData = try? JSONSerialization.data(withJSONObject: dict, options: [])
    guard jsonData != nil else {return nil}
    let jsonString = String(data: jsonData!, encoding: .utf8)
    guard jsonString != nil else {return nil}
    return jsonString! as String
}
