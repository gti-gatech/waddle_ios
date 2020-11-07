//
//  CreateScheduleVC.swift
//  MiltonWalking
//
//  Created by Jitendra Singh on 20/07/20.
//  Copyright © 2020 Appzoro. All rights reserved.
//

import UIKit

class CreateScheduleVC: UIViewController {
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var btnDone: UIButton!
    @IBOutlet weak var btnClose: UIButton!
    @IBOutlet weak var viewSuper: UIView!
    @IBOutlet weak var viewSuperDopDown: UIView!
    @IBOutlet weak var lblRepeate: UILabel!
    var selectedDayName = ""
    var arrStudentID = [Int]()
    var groupId = ""
    var stopId = ""
    var isSupervisor = false
    var selectedDate = ""
    var viewModel = CreateScheduleVM()
    let repeatMenuDropDown = DropDown()
    var doneCreateSchedule:((String?) -> Void)?
    override func viewDidLoad() {
        super.viewDidLoad()
        self.updateUIAndData()
    }
    func updateUIAndData()  {
        self.collectionView.setCornerRadius(5, borderWidth: 0.3, borderColor: .lightGray)
        self.viewSuperDopDown.setCornerRadius(5, borderWidth: 0.3, borderColor: .lightGray)
        self.btnDone.setCornerRadius(4, borderWidth: 0.3, borderColor: .clear)
        self.viewSuper.setCornerRadius(10, borderWidth: 0.3, borderColor: .clear)
        self.viewModel.updateStudnedtIds(arrStudentID: arrStudentID, groupId: groupId, stopId: stopId, isSupervisor: isSupervisor, selectedDate:selectedDate)
        self.lblRepeate.text = "Never"
        self.viewModel.updateRepeatFrequency(index: 0)
        self.viewModel.repeatDay = selectedDayName
    }
    
    @IBAction func btnDoneClicked(_ sender: Any) {
//        if self.viewModel.checkIfRepetaionDayRequiredIFNotSecected(){
//            self.showCustomAlertWith(
//                message: "please select repeat on day",
//                descMsg: "",
//                itemimage: nil,
//                actions: nil
//            )
//            return
//        }
        
        if !CommonFunctions.isNetworkReachable() {
            self.showCustomAlertWith(message: NO_INTERNET_CONNECTION, descMsg: "", itemimage: nil, actions: nil)
            return
        }
        CommonFunctions.showHUD(controller: self)
        self.viewModel.callWebServiceToCreateSchedule { (status, message) in
            CommonFunctions.hideHUD(controller: self)
            if status || message == "Your schedule has been added. Please refresh your schedule for latest updates!"{
                self.doneCreateSchedule?(self.viewModel.scheduleResponse?.message)
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
    @IBAction func btnRepeatClicked(_ sender: UIButton) {
        self.setupRepeatDropDown(sender: sender)
        repeatMenuDropDown.show()
    }
    func setupRepeatDropDown(sender:UIButton) {
        repeatMenuDropDown.anchorView = sender
        repeatMenuDropDown.bottomOffset = CGPoint(x: 0, y: sender.frame.size.height)
        let arrStr = ["Never", "1", "2", "3", "4", "5"]
        var arrDataSource = [DropDownDataModel]()
        for str in arrStr {
            let dataModel2 = DropDownDataModel()
            dataModel2.dataObject = sender.tag as AnyObject
            dataModel2.item = str
            arrDataSource.append(dataModel2)
        }
        repeatMenuDropDown.dataSource = arrDataSource
        repeatMenuDropDown.selectionAction = {[weak self] (index, item) in
            self?.viewModel.updateRepeatFrequency(index: index)
            self?.lblRepeate.text = item.item
        }
    }
}
extension CreateScheduleVC:UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CreateScheduleCell.cellIdentifier, for: indexPath) as! CreateScheduleCell
        let data = self.viewModel.getRepeateOnat(index: indexPath.row)
        cell.setUI(title: data.0, isSelected: data.1)
        return cell
    }
}
extension CreateScheduleVC:UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.viewModel.updateRepeateOnat(index: indexPath.row)
        self.collectionView.reloadData()
    }
}
extension CreateScheduleVC:UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width/5, height: collectionView.frame.height)
    }
}
