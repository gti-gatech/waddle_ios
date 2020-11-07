//
//  AllExtensions.swift
//  MiltonWalking
//
//  Created by Jitendra Singh on 06/07/20.
//  Copyright © 2020 Appzoro. All rights reserved.
//

import UIKit
import SideMenu
extension Collection {

    /// Returns the element at the specified index if it is within bounds, otherwise nil.
    subscript (safe index: Index) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}
extension SideMenuNavigationController {
    static func makeSettings() -> SideMenuSettings{
        var settings = SideMenuSettings()
        settings.allowPushOfSameClassTwice = false
        settings.presentationStyle = .viewSlideOut
        settings.statusBarEndAlpha = 0
        let presentationStyle = SideMenuPresentationStyle.viewSlideOut
        presentationStyle.presentingEndAlpha = 0.7
        settings.presentationStyle = presentationStyle
        return settings
    }
}
extension UIViewController {
    func prepareSideMenu(segue: UIStoryboardSegue) {
        guard let sideMenuNavigationController = segue.destination as? SideMenuNavigationController else { return }
        sideMenuNavigationController.settings = SideMenuNavigationController.makeSettings()
        SideMenuManager.default.addPanGestureToPresent(toView: self.navigationController!.navigationBar)
        SideMenuManager.default.addScreenEdgePanGesturesToPresent(toView: self.view)
    }
    func setupGestureForSideMene() {
        let storyboard = UIStoryboard(name: "Dashboard", bundle: nil)
        SideMenuManager.default.leftMenuNavigationController = storyboard.instantiateViewController(withIdentifier: "LeftMenuNavigationController") as? SideMenuNavigationController
        SideMenuManager.default.leftMenuNavigationController?.settings = SideMenuNavigationController.makeSettings()
        SideMenuManager.default.addPanGestureToPresent(toView: self.navigationController!.navigationBar)
        SideMenuManager.default.addScreenEdgePanGesturesToPresent(toView: self.view)
    }
}
extension Notification.Name {
    static let createSchedulePopUpPreset = Notification.Name(
       rawValue: "createSchedulePopUpPreset")
}
extension Date {
   func getFormattedDate(format: String) -> String {
        let dateformat = DateFormatter()
        dateformat.dateFormat = format
        return dateformat.string(from: self)
    }
    func fullDistance(from date: Date, resultIn component: Calendar.Component, calendar: Calendar = .current) -> Int? {
        calendar.dateComponents([component], from: self, to: date).value(for: component)
    }

    func distance(from date: Date, only component: Calendar.Component, calendar: Calendar = .current) -> Int {
        let days1 = calendar.component(component, from: self)
        let days2 = calendar.component(component, from: date)
        return days1 - days2
    }

    func hasSame(_ component: Calendar.Component, as date: Date) -> Bool {
        distance(from: date, only: component) == 0
    }
    var isWeekend: Bool {
      return NSCalendar(calendarIdentifier: NSCalendar.Identifier.gregorian)!.isDateInWeekend(self)
    }
    
}
extension String {
    func getDate( formatter:String) -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = formatter
        return dateFormatter.date(from: self)
    }
}

extension Int {
    func getMonthNameFromNumber() -> String {
        switch self {
        case 1:
            return "January"
        case 2:
            return "Febraury"
        case 3:
            return "March"
        case 4:
            return "April"
        case 5:
            return "May"
        case 6:
            return "June"
        case 7:
            return "July"
        case 8:
            return "August"
        case 9:
            return "September"
        case 10:
            return "October"
        case 11:
            return "November"
        case 12:
            return "December"
        default:
            return ""
        }
    }
    
    
}
extension Int {
    var boolValue: Bool { return self != 0 }
}
extension String {
    func convertDateString(fromFormat sourceFormat : String, toFormat desFormat : String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = sourceFormat
        guard let date = dateFormatter.date(from: self) else { return "" }
        dateFormatter.dateFormat = desFormat
        return dateFormatter.string(from: date)
    }
}
extension UIApplication {
    class func topViewController(controller: UIViewController? = UIApplication.shared.keyWindow?.rootViewController) -> UIViewController? {
        if let navigationController = controller as? UINavigationController {
            return topViewController(controller: navigationController.visibleViewController)
        }
        if let tabController = controller as? UITabBarController {
            if let selected = tabController.selectedViewController {
                return topViewController(controller: selected)
            }
        }
        if let presented = controller?.presentedViewController {
            return topViewController(controller: presented)
        }
        return controller
    }
}
