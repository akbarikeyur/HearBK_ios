//
//  AppModel.swift
//  Cozy Up
//
//  Created by Amisha on 15/10/18.
//  Copyright © 2018 Amisha. All rights reserved.
//
import UIKit


class AppModel: NSObject {
    static let shared = AppModel()
    var currentUser : UserModel!
    var ImageQueue : [String : UIImage] = [String : UIImage]()
    var navData : [String] = [String]()
    var navData1 : [String : Any] = [String : Any]()
    var COUNTRY : [CountryModel] = [CountryModel]()
    var STATE : [StateModel] = [StateModel]()
    var CITY : [CityModel] = [CityModel]()
    
    var CATEGORY_LIST : [[String : Any]] = [[String : Any]]()
    var QUESTION_LIST : [[[String : Any]]] = [[[String : Any]]]()
    var IMAGE_LIST : [String : Any] = [String : Any]()
    var CARD_LIST : [CardModel] = [CardModel]()
    var card : CardModel!
    
    var MyFavoriteUserArr : [UserModel] = [UserModel]()
    
    var LISTNER_TAG : [String] = [String]()
    
    var deviceIdData : UserModel!
    
    func validateUser(dict : [String : Any]) -> Bool{
        if let uID = dict["uID"] as? String, let email = dict["email"] as? String
        {
            if(uID != "" && email != ""){
                return true
            }
        }
        return false
    }
    
    func getSentUserArrOfDictionary(arr:[UserModel]) -> [[String:Any]]{
        
        let len:Int = arr.count
        var retArr:[[String:Any]] =  [[String:Any]] ()
        for i in 0..<len{
            retArr.append(arr[i].dictionary())
        }
        return retArr
    }
    
    func getReviewArrOfDictionary(arr:[ReviewModel]) -> [[String:Any]]{
        
        let len:Int = arr.count
        var retArr:[[String:Any]] =  [[String:Any]] ()
        for i in 0..<len{
            retArr.append(arr[i].dictionary())
        }
        return retArr
    }
    
    func getExperienceArrOfDictionary(arr:[ExperienceModel]) -> [[String:Any]]{
        
        let len:Int = arr.count
        var retArr:[[String:Any]] =  [[String:Any]] ()
        for i in 0..<len{
            retArr.append(arr[i].dictionary())
        }
        return retArr
    }
    
    func resetAllModel()
    {
        currentUser = UserModel.init()
        ImageQueue = [String : UIImage]()
        navData = [String]()
        navData1 = [String : Any]()
        
        CATEGORY_LIST = [[String : Any]]()
        QUESTION_LIST = [[[String : Any]]]()
        IMAGE_LIST = [String : Any]()
    }
}



class UserModel : AppModel
{
    var uId : String!
    var email : String!
    var password : String!
    var display_name : String!
    var updated_at : String!
    var created_at : String!
    
    var lname : String!
    var avatar : String!
    var dob : String!
    var price : Float!
    var gender : String!
    var country : String!
    var state : String!
    var city : String!
    var fields_needed : [String]!
    var bio : String!
    var song : String!
    var artist : String!
    var review_count : Int!
    var favorite_id : Int!
    var customer_id : String!
    var wallet_balance : Float!
    var my_earning : Float!
    var isBecomeListener : Int!
    
    var phone : String!
    var account_type : Int!
    var deviceId : String!
    var deviceType :String!
    
    var favorite_artists : String!
    
    var tag : String!
    var verify : Int!
    var headline : String!
    var rating : Double!
    
    var insight : ProfileInsight!
    
    var experience : [ExperienceModel]!
    var rating_as_listener : Double!
    
    var paypal_email : String!
    var paypal_legal_name : String!
    
    override init(){
         uId = ""
         email = ""
         password = ""
         display_name = ""
         updated_at = ""
         created_at = ""
        
         lname = ""
         avatar = ""
         dob = ""
         gender = ""
         country = ""
         state = ""
        city = ""
         avatar = ""
         price = 0
        fields_needed = [String]()
        bio = ""
        song = ""
        artist = ""
        review_count = 0
        favorite_id = -1
        customer_id = ""
        wallet_balance = 0.0
        my_earning = 0.0
        isBecomeListener = 0
        
        phone = ""
        account_type = 0
        deviceId = ""
        deviceType = ""
        
        tag = ""
        verify = 0
        headline = ""
        rating = 0.0
        
        insight = ProfileInsight.init()
        experience = [ExperienceModel]()
        
        rating_as_listener = 0.0
        paypal_email = ""
        paypal_legal_name = ""
        
    }
    
    init(dict : [String : Any])
    {
        uId = ""
        email = ""
        password = ""
        display_name = ""
        updated_at = ""
        created_at = ""
        
         lname = ""
         avatar = ""
         dob = ""
         gender = ""
         country = ""
         state = ""
         city = ""
         price = 0
         fields_needed = [String]()
         bio = ""
         song = ""
         artist = ""
         review_count = 0
         favorite_id = -1
         customer_id = ""
         wallet_balance = 0.0
         my_earning = 0.0
        isBecomeListener = 0
        
        phone = ""
        account_type = 0
        deviceId = ""
        deviceType = ""
        
        tag = ""
        verify = 0
        headline = ""
        rating = 0.0
        
        insight = ProfileInsight.init()
        experience = [ExperienceModel]()
        
        rating_as_listener = 0.0
        
        paypal_email = ""
        paypal_legal_name = ""
        
        if let temp = dict["id"] as? String {
            uId = temp
        }
        else if let temp = dict["user_id"] as? String {
            uId = temp
        }
        else if let temp = dict["id"] as? Int {
            uId = String(temp)
        }
        if let temp = dict["email"] as? String{
            email = temp
        }
        if let temp = dict["password"] as? String{
            password = temp
        }
        if let temp = dict["display_name"] as? String{
            display_name = temp
        }
        if let temp = dict["updated_at"] as? String{
            updated_at = temp
        }
        if let temp = dict["created_at"] as? String{
            created_at = temp
        }
        
        if let temp = dict["last_name"] as? String{
            lname = temp
        }
        if let temp = dict["avatar"] as? String{
            avatar = temp
        }
        else if let temp = dict["profile_image"] as? String{
            avatar = temp
        }
        if let temp = dict["dob"] as? String{
            dob = temp
        }
        else if let temp = dict["date_of_birth"] as? String{
            dob = temp
        }
        if let temp = dict["gender"] as? String{
            gender = temp
        }
        if let temp = dict["country"] as? String{
            country = temp
        }
        if let temp = dict["state"] as? String{
            state = temp
        }
        if let temp = dict["city"] as? String{
            city = temp
        }
        if let temp = dict["price"] as? Float{
            price = temp
        }else if let temp = dict["price"] as? String, temp != "" {
            price = Float(temp)
        }
        if let temp = dict["fields_needed"] as? [String]{
            fields_needed = temp
        }
        else if let tempDict = dict["created_at"] as? [String : Any] {
            if let date = tempDict["date"] as? String{
                created_at = date
            }
        }
        if let temp = dict["bio"] as? String {
            bio = temp
        }
        if let temp = dict["song"] as? String{
            song = temp
        }
        if let temp = dict["artist"] as? String{
            artist = temp
        }
        if let temp = dict["review_count"] as? Int{
            review_count = temp
        }
        if let temp = dict["favorite"] as? [String : Any] {
            if let favorite_user_id = temp["id"] as? Int{
                favorite_id = favorite_user_id
            }
        }
        else if let temp = dict["favorite_id"] as? Int {
            favorite_id = temp
        }
        if let temp = dict["customer_id"] as? String {
            customer_id = temp
        }
        if let temp = dict["wallet_balance"] as? Float {
            wallet_balance = temp
        }
        else if let temp = dict["wallet_balance"] as? Int {
            wallet_balance = Float(temp)
        }
        
        if let temp = dict["isBecomeListener"] as? Int {
            isBecomeListener = temp
        }
        
        if let temp = dict["my_earning"] as? Float {
            my_earning = temp
        }
        else if let temp = dict["my_earning"] as? Double {
            my_earning = Float(temp)
        }
        if let temp = dict["phone"] as? String {
            phone = temp
        }
        if let temp = dict["account_type"] as? Int {
            account_type = temp
        }
        else if let temp = dict["account_type"] as? String {
            account_type = Int(temp)
        }
        if let temp = dict["deviceId"] as? String {
            deviceId = temp
        }
        if let temp = dict["deviceType"] as? String {
            deviceType = temp
        }
        if let temp = dict["verify"] as? Int {
            verify = temp
        }
        if let temp = dict["headline"] as? String {
            headline = temp
        }
        if let temp = dict["tags"] as? String {
            tag = temp.replacingOccurrences(of: "\"", with: "")
        }
        if let temp = dict["ratings"] as? String {
            rating = Double(temp)
        }
        else if let temp = dict["ratings"] as? Int {
            rating = Double(temp)
        }
        else if let temp = dict["ratings"] as? Double {
            rating = temp
        }
        
        if let temp = dict["rating_as_listener"] as? Double {
            rating_as_listener = temp
        }
        
        if let temp = dict["insight"] as? [String : Any] {
            insight = ProfileInsight.init(dict: temp)
        }
        
        if let tempArr = dict["experience"] as? [[String : Any]] {
            for temp in tempArr
            {
                experience.append(ExperienceModel.init(dict: temp))
            }
        }
        
        if let temp = dict["paypal_email"] as? String {
            paypal_email = temp
        }
        if let temp = dict["paypal_legal_name"] as? String {
            paypal_legal_name = temp
        }
    }
    
    func dictionary() -> [String:Any]  {
        return ["id":uId, "email" : email, "password" : password, "display_name":display_name,"updated_at" : updated_at,"created_at" : created_at,"last_name":lname, "avatar" : avatar, "dob":dob,"gender":gender, "country" : country, "state":state, "city":city, "price":price, "fields_needed":fields_needed, "bio":bio, "song" : song, "artist" : artist, "review_count" : review_count, "favorite_id" : favorite_id, "customer_id" : customer_id,  "wallet_balance":wallet_balance, "isBecomeListener":isBecomeListener, "my_earning":my_earning, "phone":phone, "account_type":account_type, "deviceId":deviceId, "deviceType":deviceType, "verify":verify , "headline":headline, "tag":tag, "rating":rating, "insight" : insight.dictionary(), "experience" : getExperienceArrOfDictionary(arr: experience), "paypal_email":paypal_email, "paypal_legal_name":paypal_legal_name]
    }
    
    func toJson(_ dict:[String:Any]) -> String{
        let jsonData = try? JSONSerialization.data(withJSONObject: dict, options: [])
        let jsonString = String(data: jsonData!, encoding: .utf8)
        return jsonString!
    }
}

class ExperienceModel: AppModel {
    var company : String!
    var position : String!
    var fromDate : String!
    var toDate : String!
    
    override init(){
        company = ""
        position = ""
        fromDate = ""
        toDate = ""
    }
    
    init(dict : [String : Any])
    {
        company = ""
        position = ""
        fromDate = ""
        toDate = ""
        
        if let temp = dict["company"] as? String {
            company = temp
        }
        if let temp = dict["position"] as? String {
            position = temp
        }
        if let temp = dict["fromDate"] as? String {
            fromDate = temp
        }
        if let temp = dict["toDate"] as? String {
            toDate = temp
        }
    }
    
    func dictionary() -> [String:Any]  {
        return ["company":company, "position":position, "fromDate":fromDate, "toDate":toDate]
    }
}

class ProfileInsight: AppModel {
    var favorite_artists : String!
    var favorite_genres : String!
    var headline : String!
    var music_affiliations : String!
    
    override init(){
        favorite_artists = ""
        favorite_genres = ""
        headline = ""
        music_affiliations = ""
    }
    
    init(dict : [String : Any])
    {
        favorite_artists = ""
        favorite_genres = ""
        headline = ""
        music_affiliations = ""
        
//        if let temp = dict["favorite_artists"] as? String {
//            favorite_artists = convertToArray(text: temp)
//        }
        if let temp = dict["favorite_artists"] as? String {
            favorite_artists = temp.replacingOccurrences(of: "\"", with: "")
        }
        if let temp = dict["favorite_genres"] as? String {
            favorite_genres = temp.replacingOccurrences(of: "\"", with: "")
        }
        if let temp = dict["headline"] as? String {
            headline = temp
        }
        if let temp = dict["music_affiliations"] as? String {
            music_affiliations = temp
        }
    }
    
    func dictionary() -> [String:Any]  {
        return ["favorite_artists":favorite_artists, "favorite_genres":favorite_genres, "headline":headline, "music_affiliations":music_affiliations]
    }
}

func convertToArray(text: String) -> [String] {
    
    
    return [String]()
}

class CountryModel: AppModel {
    var id : String!
    var sortname : String!
    var name : String!
    var phoneCode : String!
    
    override init(){
        id = ""
        sortname = ""
        name = ""
        phoneCode = ""
    }
    init(dict : [String : Any])
    {
        id = ""
        sortname = ""
        name = ""
        phoneCode = ""
        
        if let temp = dict["id"] as? String {
            id = temp
        }
        else if let temp = dict["id"] as? Int {
            id = String(temp)
        }
        
        if let temp = dict["sortname"] as? String{
            sortname = temp
        }
        if let temp = dict["name"] as? String{
            name = temp
        }
        if let temp = dict["phoneCode"] as? String{
            phoneCode = temp
        }
    }
    
    func dictionary() -> [String:Any]  {
        return ["id":id,"sortname":sortname,"name":name,"phoneCode":phoneCode]
    }
}

class StateModel: AppModel {
    var id : String!
    var name : String!
    var country_id : String!
    
    override init(){
        id = ""
        name = ""
        country_id = ""
    }
    init(dict : [String : Any])
    {
        id = ""
        name = ""
        country_id = ""
        
        if let temp = dict["id"] as? String{
            id = temp
        }
        if let temp = dict["name"] as? String{
            name = temp
        }
        if let temp = dict["country_id"] as? String{
            country_id = temp
        }
    }
    
    func dictionary() -> [String:Any]  {
        return ["id":id,"name":name,"country_id":country_id]
    }
}

class TrackModel: AppModel {
    var track_id : Int!
    var music_type : String!
    var track_title : String!
    var track_file : String!
    var track_link : String!
    var rating : String!
    var created_at : String!
    var feedback : [ReviewModel]!
    
    override init(){
        track_id = 0
        music_type = ""
        track_title = ""
        track_file = ""
        track_link = ""
        rating = ""
        created_at = ""
        feedback = [ReviewModel]()
        
    }
    init(dict : [String : Any])
    {
        track_id = 0
        music_type = ""
        track_title = ""
        track_file = ""
        track_link = ""
        rating = ""
        created_at = ""
        feedback = [ReviewModel]()
        
        if let temp = dict["track_id"] as? Int{
            track_id = temp
        }
        else if let temp = dict["order_id"] as? Int {
            track_id = temp
        }
        if let temp = dict["music_type"] as? String {
            music_type = temp
        }
        if let temp = dict["track_title"] as? String {
            track_title = temp
        }
        if let temp = dict["track_file"] as? String {
            track_file = temp
        }
        if let temp = dict["track_link"] as? String {
            track_link = temp
        }
        if let temp = dict["rating"] as? String {
            rating = temp
        }
        else if let temp = dict["rating"] as? Double {
            rating = String(temp)
        }
        if let temp = dict["created_at"] as? String {
            created_at = temp
        }
        if let temp = dict["feedbackList"] as? [[String : Any]] {
            for feed in temp
            {
                feedback.append(ReviewModel.init(dict: feed))
            }
        }
    }
    func dictionary() -> [String:Any]  {
        return ["track_id":track_id, "music_type":music_type, "track_title":track_title, "track_file":track_file, "track_link":track_link, "rating":rating, "created_at":created_at, "feedbackList":getReviewArrOfDictionary(arr: feedback)]
    }
}

class CardModel: AppModel {
    
    var id : String!
    var object : String!
    
    var address_city : String!
    var address_country : String!
    var address_line1 : String!
    var address_line1_check : String!
    var address_line2 : String!
    var address_state : String!
    var address_zip : String!
    var address_zip_check : String!
    
    var brand : String!
    var country : String!
    var customer : String!
    var cvc_check : String!
    var dynamic_last4 : String!
    var exp_month : String!
    var exp_year : String!
    var fingerprint : String!
    var funding : String!
    var last4 : String!
    var name : String!
    
    var metadata : [String]!
    var tokenization_method : String!
    
    override init(){
         id = ""
         object = ""
        
         address_city = ""
         address_country = ""
         address_line1 = ""
         address_line1_check = ""
         address_line2 = ""
         address_state = ""
         address_zip = ""
         address_zip_check = ""
        
         brand = ""
         country = ""
         customer = ""
         cvc_check = ""
         dynamic_last4 = ""
         exp_month = ""
         exp_year = ""
         fingerprint = ""
         funding = ""
         last4 = ""
         name = ""
         metadata = [String]()
         tokenization_method = ""
    }
    init(dict : [String : Any])
    {
        id = ""
        object = ""
        
        address_city = ""
        address_country = ""
        address_line1 = ""
        address_line1_check = ""
        address_line2 = ""
        address_state = ""
        address_zip = ""
        address_zip_check = ""
        
        brand = ""
        country = ""
        customer = ""
        cvc_check = ""
        dynamic_last4 = ""
        exp_month = ""
        exp_year = ""
        fingerprint = ""
        funding = ""
        last4 = ""
        name = ""
        metadata = [String]()
        tokenization_method = ""
        
        if let temp = dict["id"] as? String{
            id = temp
        }
        if let temp = dict["object"] as? String{
            object = temp
        }
        
        if let temp = dict["address_city"] as? String{
            address_city = temp
        }
        if let temp = dict["address_country"] as? String{
            address_country = temp
        }
        if let temp = dict["address_line1"] as? String{
            address_line1 = temp
        }
        if let temp = dict["address_line1_check"] as? String{
            address_line1_check = temp
        }
        if let temp = dict["address_line2"] as? String{
            address_line2 = temp
        }
        if let temp = dict["address_zip"] as? String{
            address_zip = temp
        }
        if let temp = dict["address_state"] as? String{
            address_state = temp
        }
        if let temp = dict["address_zip_check"] as? String{
            address_zip_check = temp
        }
        if let temp = dict["dynamic_last4"] as? String{
            dynamic_last4 = temp
        }
        
        if let temp = dict["brand"] as? String{
            brand = temp
        }
        if let temp = dict["country"] as? String{
            country = temp
        }
        if let temp = dict["customer"] as? String{
            customer = temp
        }
        if let temp = dict["cvc_check"] as? String{
            cvc_check = temp
        }
        if let temp = dict["exp_month"] as? String{
            exp_month = temp
        }else if let temp = dict["exp_month"] as? Int{
            exp_month = String(temp)
        }
        
        if let temp = dict["exp_year"] as? String{
            exp_year = temp
        }else if let temp = dict["exp_year"] as? Int{
            exp_year = String(temp)
        }
        
        if let temp = dict["fingerprint"] as? String{
            fingerprint = temp
        }
        if let temp = dict["funding"] as? String{
            funding = temp
        }
        if let temp = dict["last4"] as? String{
            last4 = temp
        }
        if let temp = dict["name"] as? String{
            name = temp
        }
        
        if let temp = dict["metadata"] as? [String]{
            metadata = temp
        }
        if let temp = dict["tokenization_method"] as? String{
            tokenization_method = temp
        }
    }
    
    func dictionary() -> [String:Any]  {
        return ["id":id, "object":object,"address_city":address_city,"address_country":address_country,"address_line1":address_line1,"address_line1_check":address_line1_check,"address_line2":address_line2,"address_state":address_state,"address_zip":address_zip,"address_zip_check":address_zip_check,"dynamic_last4":dynamic_last4, "brand":brand,"country":country, "customer":customer, "cvc_check":cvc_check, "exp_month":exp_month,"exp_year":exp_year,"fingerprint":fingerprint,"funding":funding,"last4":last4,"name":name,"metadata":metadata,"tokenization_method":tokenization_method]
    }
}

class ArtistModel: AppModel {
    var id : String!
    var name : String!
    
    override init(){
        id = ""
        name = ""
    }
    init(dict : [String : Any])
    {
        id = ""
        name = ""
        
        if let temp = dict["id"] as? String{
            id = temp
        }
        if let temp = dict["name"] as? String{
            name = temp
        }
    }
    
    func dictionary() -> [String:Any]  {
        return ["id":id,"name":name]
    }
}

class ReviewModel: AppModel {
    var id : String!
    var name : String!
    var isMusicianFeedback : Int!
    var image : String!
    var rating : Double!
    var comment : String!
    var response : Int!
    var service : Double!
    var recommend : Double!
    var track_link : String!
    var track_file : String!
    var track_title : String!
    var music_type : String!
    var track_id : Int!
    
    override init(){
        id = ""
        name = ""
        isMusicianFeedback = 0
        image = ""
        rating = 0.0
        comment = ""
        response = 0
        service = 0
        recommend = 0
        track_link = ""
        track_file = ""
        track_title = ""
        music_type = ""
        track_id = 0
    }
    init(dict : [String : Any])
    {
        id = ""
        name = ""
        isMusicianFeedback = 0
        image = ""
        rating = 0.0
        comment = ""
        response = 0
        service = 0
        recommend = 0
        track_link = ""
        track_file = ""
        track_title = ""
        music_type = ""
        track_id = 0
        
        if let temp = dict["creater_id"] as? String {
            id = temp
        }
        else if let temp = dict["creater_id"] as? Int {
            id = String(temp)
        }
        else if let temp = dict["listner_id"] as? Int {
            id = String(temp)
        }
        if let temp = dict["isMusicianFeedback"] as? Int {
            isMusicianFeedback = temp
        }
        if let temp = dict["creater_name"] as? String {
            name = temp
        }
        else if let temp = dict["listner_name"] as? String {
            name = temp
        }
        
        if let temp = dict["profile_image"] as? String {
            image = temp
        }
        if let temp = dict["ratings"] as? String {
            rating = Double(temp)
        }
        else if let temp = dict["ratings"] as? Int {
            rating = Double(temp)
        }
        else if let temp = dict["ratings"] as? Double {
            rating = temp
        }
        if let temp = dict["ratting"] as? String {
            rating = Double(temp)
        }
        else if let temp = dict["ratting"] as? Double {
            rating = temp
        }
        
        if let temp = dict["comment"] as? String {
            comment = temp
        }
        else if let temp = dict["message"] as? String {
            comment = temp
        }
        
        if let temp = dict["response"] as? Int {
            response = temp
        }
        
        if let temp = dict["service"] as? String {
            service = Double(temp)
        }
        else if let temp = dict["service"] as? Int {
            service = Double(temp)
        }
        else if let temp = dict["service"] as? Double {
            service = temp
        }
        
        if let temp = dict["recommend"] as? String {
            recommend = Double(temp)
        }
        else if let temp = dict["recommend"] as? Int {
            recommend = Double(temp)
        }
        else if let temp = dict["recommend"] as? Double {
            recommend = temp
        }
        if let temp = dict["track_link"] as? String {
            track_link = temp
        }
        if let temp = dict["track_file"] as? String {
            track_file = temp
        }
        if let temp = dict["track_title"] as? String {
            track_title = temp
        }
        if let temp = dict["music_type"] as? String {
            music_type = temp
        }
        if let temp = dict["track_id"] as? Int{
            track_id = temp
        }
        else if let temp = dict["order_id"] as? Int {
            track_id = temp
        }
    }
    
    func dictionary() -> [String:Any]  {
        return ["user_id":id, "display_name":name, "isMusicianFeedback": isMusicianFeedback,"profile_image":image, "ratings":rating,"comment":comment,"response":response,"service":service,"recommend":recommend, "track_link":track_link, "track_file":track_file, "track_title":track_title, "music_type":music_type, "track_id":track_id]
        
    }
}


class CompanyModel: AppModel {
    var name : String!
    var position : String!
    var website : String!
    
    override init(){
        name = ""
        position = ""
        website = ""
    }
    init(dict : [String : Any])
    {
        name = ""
        position = ""
        website = ""
        
        if let temp = dict["name"] as? String{
            name = temp
        }
        if let temp = dict["position"] as? String{
            position = temp
        }
        if let temp = dict["website"] as? String{
            website = temp
        }
    }
    
    func dictionary() -> [String:Any]  {
        return ["website":website,"name":name, "position":position]
    }
}



class FeedBackModel: AppModel {
    var order_id : Int!
    var feedback_id : Int!
    var creater_id : Int!
    var first_name : String!
    var last_name : String!
    var avatar : String!
    var track_title : String!
    var track_link : String!
    var track_description : String!
    var price : Int!
    var created_at : String!
    var time : String!
    var date : String!
    var rating : Double!
    var message : String!
    
    var status : Int!
    var listner : UserModel!
    var music_type : String!
    var track_file : String!
    var display_name : String!
    
    
    override init(){
         order_id = 0
         feedback_id = 0
         creater_id = 0
         first_name = ""
         last_name  = ""
         avatar = ""
         track_title = ""
         track_link = ""
         track_description = ""
         price = 0
         created_at = ""
         time = ""
         date = ""
         rating = 0.0
        message = ""
        
        status = 0
        listner = UserModel.init()
        music_type = ""
        track_file = ""
        display_name = ""
        
    }
    init(dict : [String : Any])
    {
        order_id = 0
        feedback_id = 0
        creater_id = 0
        first_name = ""
        last_name  = ""
        avatar = ""
        track_title = ""
        track_link = ""
        track_description = ""
        price = 0
        created_at = ""
        time = ""
        date = ""
        rating = 0.0
        message = ""
        
        status = 0
        listner = UserModel.init()
        music_type = ""
        track_file = ""
        display_name = ""
        
        if let temp = dict["order_id"] as? Int{
            order_id = temp
        }
        if let temp = dict["feedback_id"] as? Int{
            feedback_id = temp
        }
        if let temp = dict["creater_id"] as? Int{
            creater_id = temp
        }
        if let temp = dict["first_name"] as? String{
            first_name = temp
        }
        if let temp = dict["last_name"] as? String{
            last_name = temp
        }
        if let temp = dict["avatar"] as? String{
            avatar = temp
        }
        if let temp = dict["track_title"] as? String{
            track_title = temp
        }
        if let temp = dict["track_link"] as? String{
            track_link = temp
        }
        if let temp = dict["track_description"] as? String{
            track_description = temp
        }
        if let temp = dict["price"] as? Int{
            price = temp
        }
        if let temp = dict["created_at"] as? String{
            created_at = temp
        }
        if let temp = dict["time"] as? String{
            time = temp
        }
        if let temp = dict["date"] as? String{
            date = temp
        }
        if let temp = dict["ratting"] as? Double{
            rating = temp
        }
        if let temp = dict["message"] as? String{
            message = temp
        }
        
        if let temp = dict["message"] as? Int {
            status = temp
        }
        if let temp = dict["listner"] as? [String : Any] {
            listner = UserModel.init(dict : temp)
        }
        
        if let temp = dict["music_type"] as? String{
            music_type = temp
        }
        if let temp = dict["track_file"] as? String{
            track_file = temp
        }
        if let temp = dict["display_name"] as? String{
            display_name = temp
        }
    }
    
    func dictionary() -> [String:Any]  {
        return ["order_id":order_id,"feedback_id":feedback_id,"creater_id":creater_id,"first_name":first_name,"last_name":last_name,"avatar":avatar,"track_title":track_title,"track_link":track_link, "track_description":track_description, "price":price, "created_at":created_at, "time":time, "date":date, "ratting":rating, "message":message,"status":status, "listner": listner.dictionary(), "music_type":music_type ,"track_file":track_file,"display_name":display_name]
    }
}


class CityModel: AppModel {
    var id : String!
    var name : String!
    var state_id : String!
    
    override init(){
        id = ""
        name = ""
        state_id = ""
    }
    init(dict : [String : Any])
    {
        id = ""
        name = ""
        state_id = ""
        
        if let temp = dict["id"] as? String{
            id = temp
        }
        if let temp = dict["name"] as? String{
            name = temp
        }
        if let temp = dict["state_id"] as? String{
            state_id = temp
        }
    }
    
    func dictionary() -> [String:Any]  {
        return ["id":id,"name":name,"state_id":state_id]
    }
}

class EarningModel: AppModel {
    var date : String!
    var earning_amount : Float!
    var feedback : String!
    var rating : Double!
    var track_id : Int!
    var trcak_name : String!
    
    override init(){
        date = ""
        earning_amount = 0.0
        feedback = ""
        rating = 0.0
        track_id = 0
        trcak_name = ""
    }
    init(dict : [String : Any])
    {
        date = ""
        earning_amount = 0.0
        feedback = ""
        rating = 0.0
        track_id = 0
        trcak_name = ""
        
        if let temp = dict["date"] as? String{
            date = temp
        }
        if let temp = dict["earning_amount"] as? Float{
            earning_amount = temp
        }
        if let temp = dict["feedback"] as? String{
            feedback = temp
        }
        if let temp = dict["rating"] as? Double{
            rating = temp
        }
        if let temp = dict["track_id"] as? Int{
            track_id = temp
        }
        if let temp = dict["trcak_name"] as? String{
            trcak_name = temp
        }
    }
    
    func dictionary() -> [String:Any]  {
        return ["date":date,"earning_amount":earning_amount,"feedback":feedback,"rating":rating,"track_id":track_id,"trcak_name":trcak_name]
    }
}
