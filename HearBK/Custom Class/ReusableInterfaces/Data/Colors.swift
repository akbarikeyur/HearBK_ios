//
//  Colors.swift
//  Cozy Up
//
//  Created by Amisha on 15/10/18.
//  Copyright © 2018 Amisha. All rights reserved.
//

import UIKit

var ClearColor : UIColor = UIColor.clear //0
var WhiteColor : UIColor = UIColor.white //1
var DarkGrayColor : UIColor = colorFromHex(hex: "4C4C4C") //2
var LightGrayColor : UIColor = colorFromHex(hex: "9A9A9A") //3
var ExtraLightGrayColor : UIColor = colorFromHex(hex: "B2B0B0") //4
var GreenColor : UIColor = colorFromHex(hex: "47bb7e") //5
var BlackColor : UIColor = UIColor.black   //6
var FBBlueColor : UIColor = colorFromHex(hex: "45619D") //7
var BlueColor : UIColor = colorFromHex(hex: "3773E0") //8
var YellowColor : UIColor = colorFromHex(hex: "EFCE4A") //9

var ScreenBackGroundColor : UIColor = colorFromHex(hex: "1A2534") //15
var ButtonBackGroundColor : UIColor = colorFromHex(hex: "CECECE") //16


enum ColorType : Int32 {
    case Clear = 0
    case White = 1
    case DarkGray = 2
    case LightGray = 3
    case ExtraLightGray = 4
    case Green = 5
    case Black = 6
    case FBcolor = 7
    case Blue = 8
    case Yellow = 9
    
    case BackColor = 15
    case ButtonBackColor = 16

}

extension ColorType {
    var value: UIColor {
        get {
            switch self {
            case .Clear: //0
                return ClearColor
            case .White: //1
                return WhiteColor
            case .DarkGray: //2
                return DarkGrayColor
            case .LightGray: //3
                return LightGrayColor
            case .ExtraLightGray: //4
                return ExtraLightGrayColor
            case .Green : //5
                return GreenColor
            case .Black : //6
                return BlackColor
            case .FBcolor : //7
                return FBBlueColor
            case .Blue : //8
                return BlueColor
            case .Yellow : //9
                return YellowColor
                
            case .BackColor : //15
                return ScreenBackGroundColor
            case .ButtonBackColor : //16
                return ButtonBackGroundColor

            }
        }
    }
}

enum GradientColorType : Int32 {
    case Clear = 0
    case App = 1
}

extension GradientColorType {
    var layer : GradientLayer {
        get {
            let gradient = GradientLayer()
            switch self {
            case .Clear: //0
                gradient.frame = CGRect.zero
            case .App: //1
                gradient.colors = [
//                    PinkColor.cgColor,
//                    PurpleColor.cgColor
                ]
                gradient.locations = [0, 1]
                gradient.startPoint = CGPoint.zero
                gradient.endPoint = CGPoint(x: 1, y: 0)
            }
            
            return gradient
        }
    }
}

