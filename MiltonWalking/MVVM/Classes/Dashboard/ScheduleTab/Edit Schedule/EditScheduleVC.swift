//
//  EditScheduleVC.swift
//  MiltonWalking
//
//  Created by Jitendra Singh on 23/07/20.
//  Copyright © 2020 Appzoro. All rights reserved.
//

import UIKit

class EditScheduleVC: UIViewController {
    
    @IBOutlet weak var constraintHLblDefault: NSLayoutConstraint!
    @IBOutlet weak var constraintHViewStop: NSLayoutConstraint!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var btnDone: UIButton!
    @IBOutlet weak var btnClose: UIButton!
    @IBOutlet weak var viewSuper: UIView!
    @IBOutlet weak var lblStop: UILabel!
    @IBOutlet weak var lblError: UILabel!

    @IBOutlet weak var viewSuperStop: UIView!
    var viewModel = EditScheduleVM()
    var studentID = 0
    var oldSelectedDate = ""
    var stopId = 0
    var isSupervisor = false
    var strPickerDate = ""
    var stopName = ""
    var tripId = 0
    var routeId = 0
    var doneEditSchedule:((String) -> Void)?
    override func viewDidLoad() {
        super.viewDidLoad()
        self.updateUIAndData()
        lblError.isHidden = true
    }
    
    func updateUIAndData()  {
        
        self.updateDatePickerUI()
        self.btnDone.setCornerRadius(3, borderWidth: 0.3, borderColor: .clear)
        self.viewSuper.setCornerRadius(10, borderWidth: 0.3, borderColor: .clear)
        self.viewSuperStop.setCornerRadius(5, borderWidth: 0.3, borderColor: .lightGray)
        self.viewModel.updateData(studentID: studentID, oldSelectedDate: oldSelectedDate, stopId: stopId, isSupervisor: isSupervisor, tripId:tripId)
        self.lblStop.text = self.stopName
        let dateToSet = self.oldSelectedDate.getDate(formatter: "yyyy-MM-dd") ?? Date()
        self.datePicker.setDate(dateToSet, animated: true)
        self.viewModel.updateDataStr(date: Date())
        if self.isSupervisor{
            self.constraintHViewStop.constant = 0
            self.constraintHLblDefault.constant = 0
            self.view.layoutIfNeeded()
        }
    }
    func updateDatePickerUI() {
        let currentDate = Date()
        var lastOfYear = currentDate
        let year = Calendar.current.component(.year, from: Date())
        if let firstOfNextYear = Calendar.current.date(from: DateComponents(year: year + 1, month: 1, day: 1)) {
            lastOfYear = Calendar.current.date(byAdding: .day, value: -1, to: firstOfNextYear) ?? currentDate
        }
        datePicker.minimumDate = currentDate
        datePicker.maximumDate = lastOfYear
    }
    @IBAction func btnSelectStopClicked(_ sender: Any) {
        let vc = SelectStopMapVC.instantiate(fromStoryboard: .main)
        vc.isToEditSchedule = true
        vc.routeID = self.routeId
        vc.doneConfirmStop = { data in
            self.lblStop.text = data?.name
            self.viewModel.updateStopData(data: data)
        }
        let navController = UINavigationController(rootViewController: vc)
//        (self.presentingViewController as? UINavigationController)?.pushViewController(vc, animated: true)
        self.present(navController, animated: true, completion: nil)
    }
    @IBAction func datePickerValueChnaged(_ sender: UIDatePicker) {
        lblError.isHidden = true
        self.viewModel.updateDataStr(date: sender.date)
    }
    
    @IBAction func btnDoneClicked(_ sender: Any) {
        if datePicker.date.isWeekend{
            lblError.isHidden = false
            return
        }
        if !CommonFunctions.isNetworkReachable() {
            self.showCustomAlertWith(message: NO_INTERNET_CONNECTION, descMsg: "", itemimage: nil, actions: nil)
            return
        }
        CommonFunctions.showHUD(controller: self)
        self.viewModel.callWebServiceToEditSchedule { (status, message) in
            CommonFunctions.hideHUD(controller: self)
            if status || message == "Schedule has been edited successfully!"{
                self.doneEditSchedule?(self.oldSelectedDate)
                self.dismiss(animated: true) {
                    
                }
            } else {
                self.showCustomAlertWith(
                    message: message,
                    descMsg: "",
                    itemimage: nil,
                    actions: nil
                )
            }
        }
        
    }
    @IBAction func btnCloseClicked(_ sender: Any) {
        let actionYes : [String: () -> Void] = [ "YES" : {
            self.dismiss(animated: true)
            }]
        let actionNo : [String: () -> Void] = [ "No" : {
            print("tapped NO")
            }]
        let arrayActions = [actionYes, actionNo]
        self.showCustomAlertWith (
            message: "Are you sure you want to cancel schedule?",
            descMsg: "",
            itemimage: nil,
            actions: arrayActions
        )
    }
}
