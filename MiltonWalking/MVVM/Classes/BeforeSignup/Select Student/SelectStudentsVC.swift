//
//  SelectStudentsVC.swift
//  MiltonWalking
//
//  Created by Krishna Datt Shukla on 07/07/20.
//  Copyright © 2020 Appzoro. All rights reserved.
//

import UIKit

class SelectStudentsVC: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    var arrStudnets = [StudentDM]()
    var arrselectedIndex = [Int]()
    var viewModel = SelectStudentsViewModel()
    var isSingleSelection = true
    var isToSchedule = false
    var isToAddGroup = false // from GroupsVC tab
    var groupId = 0
    var stopID = 0
    override func viewDidLoad() {
        super.viewDidLoad()

        setupNavigation()
        setupView()
    }
    
    func setupNavigation() {
        CommonFunctions.setLeftBarButtonItemWith(image: #imageLiteral(resourceName: "back"), action: #selector(backButtonAction), view: self)
        CommonFunctions.setRightBarButtonItemWith(image: UIImage(named: "done_2") ?? UIImage(), action: #selector(btnDoneClicked), view: self)
    }
    
    func setupView() {
        if isToSchedule || isToAddGroup{
            getAllStudents()
            self.isSingleSelection = false
        }else{
            self.viewModel.updateArrStudents(arrayStudents:self.arrStudnets)
            self.tableView.reloadData()
        }
    }
}

extension SelectStudentsVC {
    
    @IBAction func backButtonAction() {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnDoneClicked() {
        
        var arrID =  self.arrselectedIndex.compactMap { (index) -> Int in
            if let student = viewModel.student(at: index) {
                return student.id
            }
            return -1
        }
        arrID.removeAll(where: {$0 == -1})
        if !arrID.isEmpty {
            if isToSchedule{
                NotificationCenter.default.post(name: .createSchedulePopUpPreset, object: nil, userInfo: ["StudentIDs":arrID,"groupId":groupId, "stopID":stopID])
                self.navigationController?.popToRootViewController(animated: true)
            }else if self.isToAddGroup{
                self.createGroupProcess(arrStudentID:arrID)
                
            }else{
                let vc = SelectGroupsVC.instantiate(fromStoryboard: .main)
                vc.arrStudentID = arrID
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }else{
            self.showCustomAlertWith(
                message: "Please select member to add",
                descMsg: "",
                itemimage: nil,
                actions: nil
            )
        }
    }
    func createGroupProcess(arrStudentID:[Int]) {
        self.viewModel.apiCallForGroupeJoin(groupId: "\(self.groupId)", stopId: "\(self.stopID)", students: arrStudentID) { (status, message) in
            if status{
                self.navigationController?.popToRootViewController(animated: true)
            }else{
                self.showCustomAlertWith(
                    message: "Please select member to add",
                    descMsg: "",
                    itemimage: nil,
                    actions: nil
                )
            }
        }
    }
}

extension SelectStudentsVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.studentsCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SelectStudentsCell", for: indexPath) as! SelectStudentsCell
        if let group = viewModel.student(at: indexPath.row) {
            cell.setupCellWith(group, selectionStatus:self.arrselectedIndex.contains(indexPath.row))
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let index = indexPath.row
        if isSingleSelection{
            arrselectedIndex = [index]
        }else{
            if arrselectedIndex.contains(index) {
                arrselectedIndex.removeAll(where: {$0 == index})
            }else{
                arrselectedIndex.append(index)
            }
        }
        self.tableView.reloadData()
    }
}

extension SelectStudentsVC {
    
    func getAllStudents() {
        if !CommonFunctions.isNetworkReachable() {
            self.showCustomAlertWith(message: NO_INTERNET_CONNECTION, descMsg: "", itemimage: nil, actions: nil)
            return
        }
        CommonFunctions.showHUD(controller: self)
        viewModel.getStudents { (status, message) in
            CommonFunctions.hideHUD(controller: self)
            if status {
                self.tableView.reloadData()
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
}
