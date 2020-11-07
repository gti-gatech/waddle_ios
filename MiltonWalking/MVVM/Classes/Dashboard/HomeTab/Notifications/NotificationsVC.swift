//
//  NotificationsVC.swift
//  MiltonWalking
//
//  Created by Krishna Datt Shukla on 13/07/20.
//  Copyright © 2020 Appzoro. All rights reserved.
//

import UIKit
import SwiftDate

enum NotificationType: String {
    case superviseRequest   = "SUPERVISOR REQUEST"
    case tripEnded          = "TRIP ENDED"
    case tripStarted        = "TRIP STARTED"
    case arrivingAtLocation = "ARRVING AT YOUR LOCATION"
    case newMessage         = "NEW MESSAGE"
}

class NotificationsVC: UIViewController {
    
    @IBOutlet weak var tableViewNotifications: UITableView!
    
    //    var arrayNotifications = [NotificationData]()
    var arrNotificationToday = [NotificationData]()
    var arrNotificationYes = [NotificationData]()
    var arrNotificationPre = [NotificationData]()
    var dateFormatterServer: DateFormatter = {
        let df = DateFormatter()
        df.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        df.timeZone = TimeZone(abbreviation: "GMT-4")
        //        df.locale = Locale.
        return df
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavigation()
        setupView()
        getNotifications()
    }
    
    func setupNavigation() {
        self.title = "Notifications"
        CommonFunctions.setLeftBarButtonItemWith(image: #imageLiteral(resourceName: "back"), action: #selector(backButtonAction), view: self)
    }
    
    @IBAction func backButtonAction() {
        navigationController?.popViewController(animated: true)
    }
    
    func setupView() {
        tableViewNotifications.estimatedRowHeight = 100
        tableViewNotifications.rowHeight = UITableView.automaticDimension
    }
    
    func getCurrnetDate() -> Date {
        let currentDate = self.dateFormatterServer.date(from: Date().getFormattedDate(format: "yyyy-MM-dd'T'HH:mm:ss")) ?? Date()
        
        return currentDate
    }
    //    func serverTimeStamp(strDate:String) -> String {
    //        let date = Date()
    //        let formatter = DateFormatter()
    //        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
    //        let defaultTimeZoneStr = formatter.string(from: date)
    //        formatter.timeZone = TimeZone(abbreviation: "GMT-4")
    //        let utcTimeZoneStr = formatter.string(from: date)
    //        let timestamp = date.timeIntervalSince1970
    //        let cleanValue = timestamp.cleanValue
    //        return cleanValue
    //    }
    func getTextFrom(dueDate:Date, strDueDate:String? = "") -> String {
        //        let india = Region(calendar: Calendars.gregorian, zone: Zones.americaNewYork, locale: Locales.hindiIndia)
        //        let date1 = DateInRegion(self.dateFormatterServer.string(from: Date()), region: india)!
        var dateCurr = Date()
        //        if TimeZone.current.identifier.contains("Asia/"){
        //            dateCurr = Calendar.current.date(byAdding: .hour, value: -4, to: dateCurr) ?? Date()
        //
        //        }
        print(getCurrnetDate())
        //        let componentsCurrent = Calendar.current.dateComponents(in: TimeZone(abbreviation: "GMT-4")!, from: Date())
        //        let componentsNot = Calendar.current.dateComponents(in: TimeZone(identifier: "America/New_York")!, from: dueDate)
        let difference = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute,  .second], from: dateCurr, to: dueDate)
        print(difference,"difference \n", dueDate, "dueDate\n", Date(), "Date()")
        
        let diffInY = abs(difference.year ?? 0)
        let diffInM = abs(difference.month ?? 0)
        let diffInD = abs(difference.day ?? 0)
        let diffInH = abs(difference.hour ?? 0)
        let diffInMin = abs(difference.minute ?? 0)
        let diffInS = abs(difference.second ?? 0)
        if (diffInY) > 1{
            return "\(diffInY) years ago"
        }else if diffInY == 1{
            return "\(diffInY) year ago"
        }else if diffInM > 1{
            return "\(diffInM) months ago"
        }else if diffInM == 1{
            return "\(diffInM) month ago"
        }else if diffInD > 1{
            return "\(diffInD) days ago"
        }else if diffInD == 1{
            return "\(diffInD) day ago"
        }else if diffInH > 1{
            return "\(diffInH) hours ago"
        }else if diffInH == 1{
            return "\(diffInH) hour ago"
        }else if diffInMin > 1{
            return "\(diffInMin) minutes ago"
        }else if diffInMin == 1{
            return "\(diffInMin) minute ago"
        }else if diffInS > 1{
            return "\(diffInS) seconds ago"
        }else{
            return "Just now"
        }
    }
    
}

extension NotificationsVC: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        switch section {
        case 0:
            return arrNotificationToday.isEmpty ? 0 : 44
        case 1:
            return arrNotificationYes.isEmpty ? 0 : 44
        default:
            return arrNotificationPre.isEmpty ? 0 : 44
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let viewHeader = UIView(frame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: 0))
        viewHeader.backgroundColor = COLOR_DARK_GRAY
        
        let label = UILabel(frame: CGRect(x: 20, y: 10, width: SCREEN_WIDTH - 100, height: 26))
        label.text = "" //"Yesterday"
        label.textColor = COLOR_PRIMARY_GRAY
        viewHeader.addSubview(label)
        
        let labelTop = UILabel(frame: CGRect(x: 0, y: 4, width: SCREEN_WIDTH, height: 0.5))
        labelTop.backgroundColor = COLOR_LIGHT_GRAY
        viewHeader.addSubview(labelTop)
        
        let labelBottom = UILabel(frame: CGRect(x: 0, y: 40, width: SCREEN_WIDTH, height: 0.5))
        labelBottom.backgroundColor = COLOR_LIGHT_GRAY
        switch section {
        case 0:
            label.text = "Today"
        case 1:
            label.text = "Yesterday"
        default:
            label.text = "Previous"
        }
        viewHeader.addSubview(labelBottom)
        
        return viewHeader
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return arrNotificationToday.count
        case 1:
            return arrNotificationYes.count
        default:
            return arrNotificationPre.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NotificationCell") as! NotificationCell
        var notification:NotificationData!
        switch indexPath.section {
        case 0:
            notification = arrNotificationToday[indexPath.row]
        case 1:
            notification = arrNotificationYes[indexPath.row]
        default:
            notification = arrNotificationPre[indexPath.row]
        }
        if notification.hasActions == 1 {
            cell.viewContainer.backgroundColor = COLOR_PRIMARY_BEIGE
        } else {
            cell.viewContainer.backgroundColor = COLOR_PRIMARY_WHITE
        }
        cell.labelTitle.text = notification.message
        var strDate = notification.dueOn
        if notification.dueOn.contains("."){
            strDate = String(strDate.split(separator: ".").first ?? "")
        }
        guard let dueDate = dateFormatterServer.date(from: strDate) else {
            return cell
        }
        cell.labelTime.text = self.getTextFrom(dueDate: dueDate, strDueDate: strDate)
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .none
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        var notification:NotificationData!
        switch indexPath.section {
        case 0:
            notification = arrNotificationToday[indexPath.row]
        case 1:
            notification = arrNotificationYes[indexPath.row]
        default:
            notification = arrNotificationPre[indexPath.row]
        }
        var menuActions = [UIContextualAction]()
        if notification.hasActions == 1 {
            for actions in (notification.actions )  {
                let menuTitle = actions.value
                let menuAction = UIContextualAction(style: .normal, title: menuTitle) { (action, view,  success: (Bool) -> Void) in
                    
                    if actions.key == "0" {
                        switch notification.type {
                        case "UPCOMING SUPERVISOR":
                            self.markNotificationAsRead(notification)
                        default:
                            self.acceptSuperVisorRequestFor(notification)
                        }
                    } else {
                        switch notification.type {
                        case "UPCOMING SUPERVISOR":
                            self.withdrawSuperVisorRequestFor(notification)
                        default:
                            self.declineSuperVisorRequestFor(notification)
                        }
                    }
                    success(true)
                }
                if actions.key == "0" {
                    menuAction.image = #imageLiteral(resourceName: "accept")
                    menuAction.backgroundColor = COLOR_PRIMARY_SKY
                } else {
                    menuAction.image = #imageLiteral(resourceName: "decline")
                    menuAction.backgroundColor = COLOR_LIGHT_ORANGE
                }
                menuActions.append(menuAction)
            }
        }
        
        let config : UISwipeActionsConfiguration = UISwipeActionsConfiguration.init(actions: menuActions)
        config.performsFirstActionWithFullSwipe = false
        return config
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //        let notification = arrayNotifications[indexPath.row]
        //        if notification.hasActions == 0 {
        //            self.markNotificationAsRead(notification)
        //        }
    }
}

extension NotificationsVC {
    func getNotifications() {
        if !CommonFunctions.isNetworkReachable() {
            self.showCustomAlertWith(message: NO_INTERNET_CONNECTION, descMsg: "", itemimage: nil, actions: nil)
            return
        }
        CommonFunctions.showHUD(controller: self)
        let url = ServiceAPI.api_notifications.urlString()
        Services.makeRequest(forStringUrl: url, method: .get, parameters: nil) { (response, error) in
            CommonFunctions.hideHUD(controller: self)
            if (error != nil) {
                self.showCustomAlertWith(
                    message: error ?? "",
                    descMsg: "",
                    itemimage: nil,
                    actions: nil
                )
            } else if (response?.result.value as? [String : Any]) != nil {
                do {
                    guard let data = response?.data else { return }
                    let dataModel = try JSONDecoder().decode(NotificationsResponse.self, from: data)
                    self.arrNotificationToday = dataModel.data.today
                    self.arrNotificationPre = dataModel.data.previous
                    self.arrNotificationYes = dataModel.data.yesterday
                    self.tableViewNotifications.reloadData()
                }catch let error {
                    print(error)
                }
            }
        }
    }
    
    func acceptSuperVisorRequestFor(_ notification: NotificationData) {
        print("going to supervise trip")
        if !CommonFunctions.isNetworkReachable() {
            self.showCustomAlertWith(message: NO_INTERNET_CONNECTION, descMsg: "", itemimage: nil, actions: nil)
            return
        }
        guard let id = notification.payload.tripID else { return}
        let strTripId = String(id)
        CommonFunctions.showHUD(controller: self)
        Services.makeRequest(forStringUrl: ServiceAPI.api_supervise_trip.urlString() + strTripId, method: .put, parameters: nil) { (response, error) in
            CommonFunctions.hideHUD(controller: self)
            var message = INTERNAL_SERVER_ERROR
            if response == nil && error == nil {
                message = INTERNAL_SERVER_ERROR
            } else if (error != nil) {
                message = error ?? ""
            } else if let responseJSON = response?.result.value as? [String : Any] {
                let responseDic: NSDictionary = responseJSON as NSDictionary
                print("response ->\(responseDic)")
                message = responseDic["message"] as? String ?? ""
            }
            
            self.showCustomAlertWith(
                message: message,
                descMsg: "",
                itemimage: nil,
                actions: nil
            )
            self.markNotificationAsRead(notification)
        }
    }
    func withdrawSuperVisorRequestFor(_ notification: NotificationData) {
        print("going to supervise trip")
        if !CommonFunctions.isNetworkReachable() {
            self.showCustomAlertWith(message: NO_INTERNET_CONNECTION, descMsg: "", itemimage: nil, actions: nil)
            return
        }
        guard let id = notification.payload.tripID else { return}
        CommonFunctions.showHUD(controller: self)
        Services.makeRequest(forStringUrl: ServiceAPI.api_withdrawSupervisor.urlString() + "\(id)", method: .delete, parameters: nil) { (response, error) in
            CommonFunctions.hideHUD(controller: self)
            var message = INTERNAL_SERVER_ERROR
            if response == nil && error == nil {
                message = INTERNAL_SERVER_ERROR
            } else if (error != nil) {
                message = error ?? ""
            } else if let responseJSON = response?.result.value as? [String : Any] {
                let responseDic: NSDictionary = responseJSON as NSDictionary
                print("response ->\(responseDic)")
                message = responseDic["message"] as? String ?? ""
            }
            
            self.showCustomAlertWith(
                message: message,
                descMsg: "",
                itemimage: nil,
                actions: nil
            )
            self.markNotificationAsRead(notification)
        }
    }
    func declineSuperVisorRequestFor(_ notification: NotificationData) {
        self.markNotificationAsRead(notification)
    }
    
    func markNotificationAsRead(_ notification: NotificationData) {
        let params = ["id": notification.id]
        Services.makeRequest(forStringUrl: ServiceAPI.api_markNotificationAsRead.urlString(), method: .post, parameters: params) { (response, error) in
            self.getNotifications()
        }
    }
}
extension NotificationsVC{
    static func navigateFromNotificationToNotificationVC() {
        if let topController = UIApplication.topViewController(){
            let vc = NotificationsVC.instantiate(fromStoryboard: .dashboard)
            if UIApplication.topViewController()?.presentingViewController == nil{//  pushed
                DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
                    topController.navigationController?.pushViewController(vc, animated: true)
                }
            }else{
                DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
                    if let navBar = UIApplication.topViewController()?.presentingViewController as? UINavigationController {
                        navBar.pushViewController(vc, animated: true)
                    }else{
                        UIApplication.topViewController()?.dismiss(animated: true, completion: nil)
                        NotificationsVC.navigateFromNotificationToNotificationVC()
                    }
                    
                }
            }
        }
    }
}
extension Date {
    
    // Convert local time to UTC (or GMT)
    func toGlobalTime() -> Date {
        let timezone = TimeZone(identifier: "America/New_York")!
        let seconds = -TimeInterval(timezone.secondsFromGMT(for: self))
        return Date(timeInterval: seconds, since: self)
    }
    
    // Convert UTC (or GMT) to local time
    func toLocalTime() -> Date {
        let timezone = TimeZone.current
        let seconds = TimeInterval(timezone.secondsFromGMT(for: self))
        return Date(timeInterval: seconds, since: self)
    }
    
}
