//
//  Macro.swift
//  FormWithTableDemo
//
//  Created by Krishna Datt Shukla on 6/3/16.
//  Copyright © 2016 Appzoro. All rights reserved.
//

import UIKit
import Foundation

// =======================
// StoryBoards macros
// =======================

let storyboardMain = UIStoryboard.init(name: "Main", bundle: nil)
let storyboardDashBoard = UIStoryboard.init(name: "Dashboard", bundle: nil)
let storyboardStudents = UIStoryboard.init(name: "Students", bundle: nil)
let storyboardGroups = UIStoryboard.init(name: "Groups", bundle: nil)
let storyboardSchedule = UIStoryboard.init(name: "Schedule", bundle: nil)
let storyboardTrips = UIStoryboard.init(name: "Trips", bundle: nil)


// =======================
// device checking macros
// =======================


let IS_RETINA = (UIScreen.main.scale >= 2.0)
let IS_HEIGHT_GTE_780 = (UIScreen.main.bounds.size.height >= 780.0)

let SCREEN_MAX_LENGTH = (max(SCREEN_WIDTH, SCREEN_HEIGHT))
let SCREEN_MIN_LENGTH = (min(SCREEN_WIDTH, SCREEN_HEIGHT))

let SCREEN_WIDTH = UIScreen.main.bounds.size.width
let SCREEN_HEIGHT = UIScreen.main.bounds.size.height

let SAFE_AREA_BOTTOM = AppDelegate.sharedInstance.window?.safeAreaInsets.bottom
let SAFE_AREA_TOP = AppDelegate.sharedInstance.window?.safeAreaInsets.top

let APP_NAME = "Waddle"

let INTERNAL_SERVER_ERROR = "Oops! It seems to be problem with the server. Please try again"
let NO_INTERNET_CONNECTION = "No Internet Connection"

let APP_DELEGATE = UIApplication.shared.delegate as! AppDelegate

let USER_DETAILS = "USER_DETAILS"
let AUTHTOKEN = "AUTHTOKEN"
let API_MESSAGE_KEY = "message"

//COLORS
let COLOR_PRIMARY_DENIM     = UIColor(displayP3Red: 50.0/255.0, green: 93.0/255.0, blue: 121.0/255.0, alpha: 1.0)
let COLOR_PRIMARY_WHITE     = UIColor(displayP3Red: 255.0/255.0, green: 255.0/255.0, blue: 255.0/255.0, alpha: 1.0)
let COLOR_PRIMARY_ORANGE    = UIColor(displayP3Red: 242.0/255.0, green: 102.0/255.0, blue: 39.0/255.0, alpha: 1.0)
let COLOR_LIGHT_ORANGE      = UIColor(displayP3Red: 249.0/255.0, green: 162.0/255.0, blue: 108.0/255.0, alpha: 1.0)
let COLOR_PRIMARY_SKY       = UIColor(displayP3Red: 166.0/255.0, green: 212.0/255.0, blue: 208.0/255.0, alpha: 1.0)
let COLOR_PRIMARY_BEIGE     = UIColor(displayP3Red: 213.0/255.0, green: 191.0/255.0, blue: 176.0/255.0, alpha: 1.0)
let COLOR_PRIMARY_GRAY      = UIColor(displayP3Red: 121.0/255.0, green: 121.0/255.0, blue: 121.0/255.0, alpha: 1.0)
let COLOR_LIGHT_GRAY        = UIColor(displayP3Red: 121.0/255.0, green: 121.0/255.0, blue: 121.0/255.0, alpha: 0.4)
let COLOR_DARK_GRAY         = UIColor(displayP3Red: 239.0/255.0, green: 238.0/255.0, blue: 238.0/255.0, alpha: 1.0)
let COLOR_DARK_BLUE_GRAY    = UIColor(displayP3Red: 22.0/255.0, green: 31.0/255.0, blue: 61.0/255.0, alpha: 1.0)
let COLOR_LIGHT_BLUE_GRAY    = UIColor(displayP3Red: 22.0/255.0, green: 31.0/255.0, blue: 61.0/255.0, alpha: 0.8)

let COLOR_33_43_54_100       = UIColor(displayP3Red: 33.0/255.0, green: 43.0/255.0, blue: 54.0/255.0, alpha: 1.0)
let COLOR_33_43_54_30        = UIColor(displayP3Red: 33.0/255.0, green: 43.0/255.0, blue: 54.0/255.0, alpha: 0.3)

class Macro: NSObject {
    
}


