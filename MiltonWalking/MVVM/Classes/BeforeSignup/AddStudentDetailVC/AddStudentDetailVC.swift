//
//  AddStudentDetailVC.swift
//  MiltonWalking
//
//  Created by Jitendra Singh on 06/07/20.
//  Copyright © 2020 Appzoro. All rights reserved.
//

import UIKit

class AddStudentDetailVC: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var buttonSave: UIButton!

    var viewModel = AddStudentDetailVM()
    
    var isFromStudents: Bool = false
    var student: Student?
    
    var alertMessage = "Student added successfully"

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupView()
        CommonFunctions.setLeftBarButtonItemWith(image: #imageLiteral(resourceName: "back"), action: #selector(backButtonAction), view: self)
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.barTintColor = UIColor(red: 239/255, green: 239/255, blue: 239/255, alpha: 1)
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.navigationBar.barTintColor = UIColor.white
    }
    func setupView() {
        if isFromStudents {
            if student == nil {
                self.title = "Add Student"
                viewModel.setupDataSource {
                    self.tableView.reloadData()
                }
            } else {
                self.tableView.isUserInteractionEnabled = false
                self.buttonSave.isHidden = true
                let edit : UIBarButtonItem = UIBarButtonItem.init(image: #imageLiteral(resourceName: "edit_top"), style: UIBarButtonItem.Style.plain, target: self, action: #selector(editButtonAction))
                let delete : UIBarButtonItem = UIBarButtonItem.init(image: #imageLiteral(resourceName: "trash"), style: UIBarButtonItem.Style.plain, target: self, action: #selector(deleteButtonAction))
                self.navigationItem.rightBarButtonItems = [delete, edit]
                
                viewModel.setupStudentData(student!) {
                    self.tableView.reloadData()
                }
            }
            CommonFunctions.setLeftBarButtonItemWith(image: #imageLiteral(resourceName: "back"), action: #selector(backButtonAction), view: self)
        }else{
            viewModel.setupDataSource {
                self.tableView.reloadData()
            }
        }
    }
    
    func updateNavigationBar() {
        let edit : UIBarButtonItem = UIBarButtonItem.init(image: #imageLiteral(resourceName: "edit_top"), style: UIBarButtonItem.Style.plain, target: self, action: #selector(editButtonAction))
        let delete : UIBarButtonItem = UIBarButtonItem.init(image: #imageLiteral(resourceName: "trash"), style: UIBarButtonItem.Style.plain, target: self, action: #selector(deleteButtonAction))
        if buttonSave.isHidden {
            self.navigationItem.rightBarButtonItems = [delete, edit]
        } else {
            self.navigationItem.rightBarButtonItems = [delete]
        }
    }
    
    @IBAction func editButtonAction() {
        self.tableView.isUserInteractionEnabled = true
        self.buttonSave.isHidden = false
        updateNavigationBar()
    }
    
    @IBAction func deleteButtonAction() {
        let actionYes : [String: () -> Void] = [ "YES" : {
            self.deleteStudent()
        }]
        let actionNo : [String: () -> Void] = [ "No" : {
            print("tapped NO")
        }]
        let arrayActions = [actionYes, actionNo]
        self.showCustomAlertWith (
            message: "Are you sure, you want to delete the student.",
            descMsg: "",
            itemimage: nil,
            actions: arrayActions
        )
    }
    
    func deleteStudent() {
        if !CommonFunctions.isNetworkReachable() {
            self.showCustomAlertWith(message: NO_INTERNET_CONNECTION, descMsg: "", itemimage: nil, actions: nil)
            return
        }
        CommonFunctions.showHUD(controller: self)
        
        viewModel.apiCallForDeleteStudentData(student!.id!) { (status, message) in
            CommonFunctions.hideHUD(controller: self)
            if status {
                self.alertMessage = "Student has been deleted succesfully."
                self.handleNavigation()
            } else {
                let actionYes: () -> Void = { (
                    self.navigationController?.popViewController(animated: true)
                ) }
                self.showCustomAlertWith(
                    okButtonAction: actionYes, // This is optional
                    message: message,
                    descMsg: "",
                    itemimage: nil,
                    actions: nil
                )
            }
        }
    }
    
    @IBAction func backButtonAction() {
        navigationController?.popViewController(animated: true)
    }

    @IBAction func btnSaveClicked(_ sender: Any) {
        viewModel.validateTextFields(completion: { (status, message) in
            if status {
                self.callWebServiceToSaveStaudentData()
            } else {
                self.showCustomAlertWith(
                    message: message ?? "",
                    descMsg: "",
                    itemimage: nil,
                    actions: nil
                )
            }
        })
    }
    func callWebServiceToSaveStaudentData() {
        if !CommonFunctions.isNetworkReachable() {
            self.showCustomAlertWith(message: NO_INTERNET_CONNECTION, descMsg: "", itemimage: nil, actions: nil)
            return
        }
        CommonFunctions.showHUD(controller: self)
        
        if isFromStudents && student != nil {
            updateStudent()
        } else {
            addStudent()
        }

    }
    
    func updateStudent() {
        viewModel.apiCallForUpdateStudentData(student!.id!) { (status, message) in
            CommonFunctions.hideHUD(controller: self)
            if status {
                self.alertMessage = "Student details updated successfully."
                self.handleNavigation()
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
    
    func addStudent() {
        viewModel.apiCallForSaveStudentData { (status, message) in
            CommonFunctions.hideHUD(controller: self)
            if status {
                self.alertMessage = "Student added successfully"
                self.handleNavigation()
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
    
    func handleNavigation() {
        if self.isFromStudents {
            let actionYes: () -> Void = { (
                self.navigationController?.popViewController(animated: true)
            ) }
            self.showCustomAlertWith(
                okButtonAction: actionYes, // This is optional
                message: self.alertMessage,
                descMsg: "",
                itemimage: nil,
                actions: nil
            )
        } else {
            viewModel.setupDataSource {
                self.tableView.reloadData()
            }
            let vc = SelectStudentsVC.instantiate(fromStoryboard: .main)
            vc.arrStudnets = self.viewModel.getArrStudents()
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
}

extension AddStudentDetailVC:UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: AddStudentDetailTableViewCell.cellIdentifier, for: indexPath) as! AddStudentDetailTableViewCell
        cell.txtfDetail.tag = indexPath.row
        cell.txtfDetail.addTarget(self, action: #selector(updateInputFieldValue(textField:)), for: .editingChanged)
        if let data = viewModel.getStudentDataForFieldAt(index: indexPath.row) {
            cell.studentData = data
        }
        return cell
    }
}

extension AddStudentDetailVC: UITextFieldDelegate {
    @IBAction func updateInputFieldValue(textField: UITextField) {
        guard let text = textField.text else { return }
        if text.count >= 25{
            textField.text = String(text.prefix(25))
        }
        self.viewModel.updateTextField(at: textField.tag, value: textField.text ?? "")
    }
}
