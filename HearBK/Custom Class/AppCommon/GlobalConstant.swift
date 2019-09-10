//
//  GlobalConstant.swift
//  Cozy Up
//
//  Created by Amisha on 15/10/18.
//  Copyright © 2018 Amisha. All rights reserved.
//

import Foundation
import UIKit


//Facebook
//email : testingakbari@gmail.com
//Pass : akbari717

let APP_VERSION = 1.0
let BUILD_VERSION = 1
let DEVICE_ID = UIDevice.current.identifierForVendor?.uuidString

let ITUNES_URL = ""

let GENRESARRAY = ["Alternative Rock","Ambient","Blues","Classical","Country","Dance","EDM","Dancehall","Deep House","Disco","Drum Bass","Dubstep","Electronic","Folk","House","Hip-Hop","House","Indie","Jazz","K-Pop","Latin","Metal","Piano","Pop","Rap","R&B","Soul","Reggae","Reggaeton","Rock","Techno","Trance","Trap","Triphop","World"]


//let LISTNER_TAG = ["Producer","DJ","Podcaster","Journalist","Blogger","Host","Songwriter","SingerSongwriter","Singer","MC","Rapper","Beatmaker","Fan","Concert Goer","College Student","Superfan","Industry Executive","Radio Professional","Vocal Coach","Artist","Musician","Band Member","Engineer","Influencer","Publicist","Casting Agent","Promoter","Marketer","Composer","Music Supervisor","A&R","Music Coordinator","Manager"]

struct STRIPE {
    static var PUBLISH_KEY = "pk_test_91eUV44WQZfEq7nrOyRQlNMz"
    static var SECRET_KEY = "sk_test_URLT7y8Bbe5zkgXsus7cL5z1"
}

struct SCREEN
{
    static var WIDTH = UIScreen.main.bounds.size.width
    static var HEIGHT = UIScreen.main.bounds.size.height
}

struct DATE_FORMAT {
    static var SERVER_DATE_FORMAT = "YYYY-MM-dd"
    static var SERVER_TIME_FORMAT = "HH:mm"
    static var SERVER_DATE_TIME_FORMAT = "yyyy-MM-dd" //HH:mm:ss"
    static var DISPLAY_DATE_FORMAT = "dd/MM/yyyy"
    static var DISPLAY_DATE_FORMAT1 = "MM/dd/yyyy"
    static var DISPLAY_TIME_FORMAT = "hh:mm a"
    static var DISPLAY_DATE_TIME_FORMAT = "YYYY-MM-dd HH:mm:ss"
}

struct CONSTANT{
    static var DP_IMAGE_WIDTH     =  1000
    static var DP_IMAGE_HEIGHT    =  1000
    
    static let MAX_EMAIL_CHAR = 254
    static let MAX_PREFER_NAME_CHAR = 40
    static let MIN_PWD_CHAR = 8
    static let MAX_PWD_CHAR = 16
    static let MAX_FIRST_NAME_CHAR = 40
    static let MAX_MIDDLE_NAME_CHAR = 40
    static let MAX_LAST_NAME_CHAR = 40
    
    static let DOB_CHAR = 8
    static let DOB_SPACE_CHAR = 4
    static let DOB_DATE_CHAR = 2
    static let DOB_MONTH_CHAR = 2
    static let DOB_YEAR_CHAR = 4
    
    static let MOBILE_NUMBER_CHAR = 8
    static let MOBILE_NUMBER_SPACE_CHAR = 2
    static let MOBILE_NUMBER_CODE = ""
    
    static let CARD_NUMBER_CHAR = 16
    static let CARD_NUMBER_DASH_CHAR = 3
    static let CARD_EXP_DATE_CHAR = 5
    static let CARD_CVV_CHAR = 3
    
    static let SMS_CODE_CHAR = 4
    static let SMS_CODE_SPACE_CHAR = 3
    
    static let IMAGE_QUALITY   =  1
    
    static let CURRENCY   =  "$"
    static let DIST_MEASURE   =  "km"
    static let TIME_ZONE = "Australia/Sydney"
    
    static let DEF_TAKE : Int = 24
    
    
}

struct MEDIA {
    static var IMAGE = "IMAGE"
    static var VIDEO = "VIDEO"
}

struct IMAGE {
    static var USER_PLACEHOLDER = "avatar_placeholder"
    static var VIDEO_PLACEHOLDER = "video_placeholder"
}

struct STORYBOARD {
    static var MAIN = UIStoryboard(name: "Main", bundle: nil)
    static var HOME = UIStoryboard(name: "Home", bundle: nil)
    static var PROFILE = UIStoryboard(name: "Profile", bundle: nil)
    static var SETTING = UIStoryboard(name: "Settings", bundle: nil)
}

struct NOTIFICATION {
    
    struct TYPE {
        static var FEEDBACK_RECEIVED = "feedback_received"
        static var RATING_RECEIVED = "rating_received"
        static var ORDER_PLACED = "order_placed"
    }
    
    struct VALUE {
        static var ORDER_ID = "order_id"
    }
    
    static var UPDATE_CURRENT_USER_DATA     =   "UPDATE_CURRENT_USER_DATA"
    static var REDICT_TAB_BAR               =   "REDICT_TAB_BAR"
    static var RESET_ADVANCE_SEARCH         =   "RESET_ADVANCE_SEARCH"
    static var UPDATE_USER_DATA             =   "UPDATE_USER_DATA"
    static var UPDATE_CARD_DATA             =   "UPDATE_CARD_DATA"
    static var UPDATE_FEEDBACK_REQUEST_DATA =   "UPDATE_FEEDBACK_REQUEST_DATA"
    static var TAG_RELOAD                   =   "TAG_RELOAD"
    static var SELECTED_LISTENER            =   "SELECTED_LISTENER"
    static let REDIRECT_SERCHFOR_LISNER     =   "REDIRECT_SERCHFOR_LISNER"
    static var UPDATE_PROGRESS_VALUE        =   "UPDATE_PROGRESS_VALUE"
    static var UPDATE_FAVORITE_USER         =   "UPDATE_FAVORITE_USER"
    
    //notification
    static var REDIRECT_TO_GIVE_FEEDBACK    =   "REDIRECT_TO_GIVE_FEEDBACK"
    
}

struct COREDATA {
    struct MESSAGE
    {
        static var TABLE_NAME = "Message"
        static var key = "key"
        static var msgID = "msgID"
        static var otherUserId = "otherUserId"
        static var date = "date"
        static var text = "text"
        static var status = "status"
    }
    struct USER
    {
        static var TABLE_NAME = "User"
        static var id = "uID"
        static var name = "name"
        static var email = "email"
        static var picture = "picture"
        static var last_seen = "last_seen"
    }
}

struct GENDER {
    static var GREEK_GOD = "GREEK_GOD"
    static var GREEK_GODDESS = "GREEK_GODDESS"
}


struct Platform {
    
    static var isSimulator: Bool {
        return TARGET_OS_SIMULATOR != 0
    }
}

struct CATEGORY {
    
    struct ANSWER_TYPE {
        static var LIST = "LIST"
        static var STRING = "STRING"
        static var FILE = "FILE"
    }
    
    struct DJ {
        static var NAME = "DJ"
        static var ID = 4
        static var QUESTIONS = ["Where do you DJ?", "Upload a flyer from a recent DJ gig", "What's the company website?"]
        static var DJ_ANSWER = ["Night Clubs", "Festivals, Concerts", "Restaurants, Lounges", "Private Events"]
    }
    
    struct PRODUCER {
        static var NAME = "Producer"
        static var ID = 2
        static var QUESTIONS = ["How long have you been producing?", "What is your primary DAW?", "Please list your production credits"]
        static var YEAR_LIST = ["0-2 years","2-5 years","6-10 years","11-20 years","21 or more"]
        static var DAW_ANSWER = ["FlStuodio", "Logic", "Reason", "Ableton", "Cubase", "Protools", "Digital Performer", "Other"]
    }
    
    struct FAN {
        static var NAME = "Fan"
        static var ID = 1
        static var QUESTIONS = ["Please list your favorite Artists"]
    }
    
    struct ARTIST {
        static var NAME = "Artist"
        static var ID = 5
        static var QUESTIONS = ["Why did you become an artist?", "What motivates you?"]
    }
    
    struct INDUSTRY {
        static var NAME = "Executive"
        static var ID = 3
        //static var QUESTIONS = ["Who do you work for?", "What's your title?", "What's the company website?"]
        static var QUESTIONS = ["Company Name", "Position", "Company website"]
    }
    
}
