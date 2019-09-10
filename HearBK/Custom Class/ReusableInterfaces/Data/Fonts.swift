//
//  Fonts.swift
//  Cozy Up
//
//  Created by Amisha on 22/05/18.
//  Copyright © 2018 Amisha. All rights reserved.
//

import Foundation

import UIKit

let SFUI_BLACK = "SFUIDisplay-Black"
let SFUI_BOLD = "SFUIDisplay-Bold"
let SFUI_HEAVY = "SFUIDisplay-Heavy"
let SFUI_LIGHT = "SFUIDisplay-Light"
let SFUI_MEDIUM = "SFUIDisplay-Medium"
let SFUI_SEMIBOLD = "SFUIDisplay-Semibold"
let SFUI_THIN = "SFUIDisplay-Thin"
let SFUI_ULTRALIGHT = "SFUIDisplay-Ultralight"
let SFUI_REGULAR = "SFUIDisplay-Regular"

enum FontType : String {
    case Clear = ""
    case SFUIDisplayBlack = "sbl"
    case SFUIDisplayBold = "sb"
    case SFUIDisplayHeavy = "sh"
    case SFUIDisplayLight = "sl"
    case SFUIDisplayMedium = "sm"
    case SFUIDisplaySemibold = "ssb"
    case SFUIDisplayThin = "st"
    case SFUIDisplayUltraLight = "sul"
    case SFUIDisplayRegular = "sr"
}


extension FontType {
    var value: String {
        get {
            switch self {
            case .Clear:
                return SFUI_MEDIUM
            
            case .SFUIDisplayBlack:
                return SFUI_BLACK
            case .SFUIDisplayBold:
                return SFUI_BOLD
            case .SFUIDisplayHeavy:
                return SFUI_HEAVY
            case .SFUIDisplayLight:
                return SFUI_LIGHT
            case .SFUIDisplayMedium:
                return SFUI_MEDIUM
            case .SFUIDisplaySemibold:
                return SFUI_SEMIBOLD
            case .SFUIDisplayThin:
                return SFUI_THIN
            case .SFUIDisplayUltraLight:
                return SFUI_ULTRALIGHT
            case .SFUIDisplayRegular:
                return SFUI_REGULAR
            }
        }
    }
}

