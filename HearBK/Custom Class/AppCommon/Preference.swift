//
//  Preference.swift
//  Cozy Up
//
//  Created by Amisha on 15/10/18.
//  Copyright © 2018 Amisha. All rights reserved.
//

import UIKit

class Preference: NSObject {

    static let sharedInstance = Preference()
    
    let IS_USER_LOGIN_KEY       =   "IS_USER_LOGIN"
    let USER_DATA_KEY           =   "USER_DATA"
    let USER_LATITUDE_KEY       =   "USER_LATITUDE"
    let USER_LONGITUDE_KEY      =   "USER_LONGITUDE"
    let USER_CARD               =   "USER_CARD_DETAIL"
    let IS_FACEBOOK_USER_LOGIN_KEY = "IS_FACEBOOK_USER"
    let USER_PARAMETER           =   "USER_PARAMETER"
}


func setDataToPreference(data: AnyObject, forKey key: String)
{
    UserDefaults.standard.set(data, forKey: key)
    UserDefaults.standard.synchronize()
}

func getDataFromPreference(key: String) -> AnyObject?
{
    return UserDefaults.standard.object(forKey: key) as AnyObject?
}

func removeDataFromPreference(key: String)
{
    UserDefaults.standard.removeObject(forKey: key)
    UserDefaults.standard.synchronize()
}

func removeUserDefaultValues()
{
    UserDefaults.standard.removePersistentDomain(forName: Bundle.main.bundleIdentifier!)
    UserDefaults.standard.synchronize()
}

//MARK: - Access Token
func setAccessToekn(_ token: String)
{
    setDataToPreference(data: token as AnyObject, forKey: "user_access_token")
}

func getAccessToekn() -> String
{
    if let token : String = getDataFromPreference(key: "user_access_token") as? String
    {
        return token
    }
    return ""
}

func setRefreshToekn(_ token: String)
{
    setDataToPreference(data: token as AnyObject, forKey: "user_refresh_token")
}

func getRefreshToekn() -> String
{
    if let token : String = getDataFromPreference(key: "user_refresh_token") as? String
    {
        return token
    }
    return ""
}

//MARK: - User login boolean
func setIsUserLogin(isUserLogin: Bool)
{
    setDataToPreference(data: isUserLogin as AnyObject, forKey: Preference.sharedInstance.IS_USER_LOGIN_KEY)
}

func isUserLogin() -> Bool
{
    let isUserLogin = getDataFromPreference(key: Preference.sharedInstance.IS_USER_LOGIN_KEY)
    return isUserLogin == nil ? false:(isUserLogin as! Bool)
}

func setLoginUserData(_ dictData: [String : Any])
{
    print(dictData)
    setDataToPreference(data: dictData as AnyObject, forKey: Preference.sharedInstance.USER_DATA_KEY)
    setIsUserLogin(isUserLogin: true)
}

func getLoginUserData() -> [String : Any]?
{
    if let data = getDataFromPreference(key: Preference.sharedInstance.USER_DATA_KEY)
    {
        return data as? [String : Any]
    }
    return nil
}

func setLoginUserParameter(_ dictData: [String : Any])
{
    setDataToPreference(data: dictData as AnyObject, forKey: Preference.sharedInstance.USER_PARAMETER)
}

func getLoginUserParameter() -> [String : Any]?
{
    if let data = getDataFromPreference(key: Preference.sharedInstance.USER_PARAMETER)
    {
        return data as? [String : Any]
    }
    return nil
}


func setDeviceToken(value: String)
{
    setDataToPreference(data: value as AnyObject, forKey: "push_device_token")
}

func getDeviceToken() -> String
{
    if let deviceToken = getDataFromPreference(key: "push_device_token")
    {
        return deviceToken as! String
    }
    return ""
}

func setUserLocation(_ latitude : Float, longitude : Float)
{
    setDataToPreference(data: latitude as AnyObject, forKey: Preference.sharedInstance.USER_LATITUDE_KEY)
    setDataToPreference(data: longitude as AnyObject, forKey: Preference.sharedInstance.USER_LONGITUDE_KEY)
}

func getUserLatitude() -> Float
{
    if let temp : Float = getDataFromPreference(key: Preference.sharedInstance.USER_LATITUDE_KEY) as? Float
    {
        return temp
    }
    return 0.0
}

func getUserLongitude() -> Float
{
    if let temp : Float = getDataFromPreference(key: Preference.sharedInstance.USER_LONGITUDE_KEY) as? Float
    {
        return temp
    }
    return 0.0
}

func setModuleType(value: Int)
{
    setDataToPreference(data: value as AnyObject, forKey: "user_type")
}

func isUserModule() -> Bool
{
    if let type = getDataFromPreference(key: "user_type") as? Int
    {
        if type == 1
        {
            return true
        }
        else
        {
            return false
        }
    }
    return true
}

func setMaleOrganizationList(arrValue : [[String : Any]])
{
    setDataToPreference(data: arrValue as AnyObject, forKey: "organization_male_data")
}

func getMaleOrganizationList() -> [[String : Any]]
{
    if let data : [[String : Any]] = getDataFromPreference(key: "organization_male_data") as? [[String : Any]]
    {
        return data
    }
    return [[String : Any]]()
}

func setFemaleOrganizationList(arrValue : [[String : Any]])
{
    setDataToPreference(data: arrValue as AnyObject, forKey: "organization_female_data")
}


func getFemaleOrganizationList() -> [[String : Any]]
{
    if let data : [[String : Any]] = getDataFromPreference(key: "organization_female_data") as? [[String : Any]]
    {
        return data
    }
    return [[String : Any]]()
}


func setSchoolList(arrValue : [[String : Any]])
{
    setDataToPreference(data: arrValue as AnyObject, forKey: "school_data")
}

func getSchoolList() -> [[String : Any]]
{
    if let data : [[String : Any]] = getDataFromPreference(key: "school_data") as? [[String : Any]]
    {
        return data
    }
    return [[String : Any]]()
}

func addCardDetail(value : Bool)
{
    setDataToPreference(data: value as AnyObject, forKey: "is_card_detail")
}

func isCardDetailAdded() -> Bool
{
    if let value : Bool = getDataFromPreference(key: "is_card_detail") as? Bool
    {
        return value
    }
    return false
}

func setCardDetail(_ dictData: [String : Any])
{
    setDataToPreference(data: dictData as AnyObject , forKey: Preference.sharedInstance.USER_CARD)
    addCardDetail(value: true)
}

func getUserCardData() -> [String : Any]?
{
    if let data = getDataFromPreference(key: Preference.sharedInstance.USER_CARD)
    {
        return data as? [String : Any]
    }
    return nil
}

func setIsFacebookUserLogin(isUserLogin: Bool)
{
    setDataToPreference(data: isUserLogin as AnyObject, forKey: Preference.sharedInstance.IS_FACEBOOK_USER_LOGIN_KEY)
}

func isFacebookUserLogin() -> Bool
{
    let isUserLogin = getDataFromPreference(key: Preference.sharedInstance.IS_FACEBOOK_USER_LOGIN_KEY)
    return isUserLogin == nil ? false:(isUserLogin as! Bool)
}

func setDefaultCardID(_ cardId: String)
{
    setDataToPreference(data: cardId as AnyObject , forKey: "default_card_id")
    addCardDetail(value: true)
}

func getDefaultCardID() -> String
{
    if let card : String = getDataFromPreference(key: "default_card_id") as? String
    {
        return card
    }
    return ""
}

func setCreditCardList()
{
    var dictData : [[String : Any]] = [[String : Any]]()
    for temp in AppModel.shared.CARD_LIST
    {
        dictData.append(temp.dictionary())
    }
    setDataToPreference(data: dictData as AnyObject, forKey: "my_card_list")
    
    if getDefaultCardID() == "" && AppModel.shared.CARD_LIST.count > 0
    {
        setDefaultCardID(AppModel.shared.CARD_LIST[0].id)
    }
    
}

func getCreditCardList() -> [CardModel]
{
    if let data : [[String : Any]] = getDataFromPreference(key: "my_card_list") as? [[String : Any]]
    {
        var CARD_LIST : [CardModel] = [CardModel]()
        for temp in data
        {
            CARD_LIST.append(CardModel.init(dict: temp))
        }
        return CARD_LIST
    }
    return [CardModel]()
}

func setIsRedirectToGetOrder(_ isRedirect: Bool)
{
    setDataToPreference(data: isRedirect as AnyObject, forKey: "get_feedback_redirect")
}

func isRedirectTogetOrder() -> Bool
{
    let isRedirect = getDataFromPreference(key: "get_feedback_redirect")
    return isRedirect == nil ? false:(isRedirect as! Bool)
}


func setIsRedirectToReceivedFeedback(_ isRedirect: Bool)
{
    setDataToPreference(data: isRedirect as AnyObject, forKey: "received_feedback_redirect")
}

func isRedirectToReceivedFeedback() -> Bool
{
    let isRedirect = getDataFromPreference(key: "received_feedback_redirect")
    return isRedirect == nil ? false:(isRedirect as! Bool)
}


func setFeedbackReceivedValue(value : Bool)
{
    setDataToPreference(data: value as AnyObject, forKey: NOTIFICATION.TYPE.FEEDBACK_RECEIVED)
}


func getFeedbackReceivedValue() -> Bool
{
    if let value : Bool = getDataFromPreference(key: NOTIFICATION.TYPE.FEEDBACK_RECEIVED) as? Bool
    {
        return value
    }
    return false
}


func setFeedbackRequestValue(value : Bool)
{
    setDataToPreference(data: value as AnyObject, forKey: NOTIFICATION.TYPE.ORDER_PLACED)
}


func getFeedbackRequestValue() -> Bool
{
    if let value : Bool = getDataFromPreference(key: NOTIFICATION.TYPE.ORDER_PLACED) as? Bool
    {
        return value
    }
    return false
}

func setRatingReceivedValue(value : Bool)
{
    setDataToPreference(data: value as AnyObject, forKey: NOTIFICATION.TYPE.RATING_RECEIVED)
}


func getRatingReceivedValue() -> Bool
{
    if let value : Bool = getDataFromPreference(key: NOTIFICATION.TYPE.RATING_RECEIVED) as? Bool
    {
        return value
    }
    return false
}


func setOrderId(value : Int)
{
    setDataToPreference(data: value as AnyObject, forKey: NOTIFICATION.VALUE.ORDER_ID)
}


func getOrderId() -> Int
{
    if let value : Int = getDataFromPreference(key: NOTIFICATION.VALUE.ORDER_ID) as? Int
    {
        return value
    }
    return -1
}
