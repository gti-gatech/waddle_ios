//
//  GroupDetailVC.swift
//  MiltonWalking
//
//  Created by Jitendra Singh on 22/07/20.
//  Copyright © 2020 Appzoro. All rights reserved.
//

import UIKit

class GroupDetailVC: UIViewController {
    @IBOutlet weak var btnEditImage: UIButton!
    @IBOutlet weak var txtfTitle: UITextField!
    @IBOutlet weak var imgvHader: UIImageView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    var groupId = 0
    var viewModel = GroupDetailVM()
    let menuDropDown = DropDown()
    var isToEdit = false
    var isFromDashboard = false
    
    var selectedImage: UIImage?
    var indexToManageSupervise = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        self.txtfTitle.delegate = self
        if isFromDashboard {
            isFromDashboard = false
        }
        segmentedControl.selectedSegmentIndex = 1
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setUpUI()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    func manageRightNavigationButton() {
        if isToEdit{
            CommonFunctions.setRightBarButtonItemWith(title: "Save", action: #selector(btnSaveClicked), view: self)
        }else{
            CommonFunctions.setRightBarButtonItemWith(image: #imageLiteral(resourceName: "edit_top"), action: #selector(btnEditClicked), view: self)
        }
    }
    func setupNavigation() {
        CommonFunctions.setLeftBarButtonItemWith(image: #imageLiteral(resourceName: "back"), action: #selector(backbtnClicked), view: self)
        self.manageRightNavigationButton()
        self.tabBarController?.tabBar.isHidden = true
        //self.navigationController?.navigationBar.applyNavigationGradient(colors: [#colorLiteral(red: 1, green: 1, blue: 1, alpha: 0.1023052377), #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0.1959452024)])
    }
    @IBAction func backbtnClicked() {
        self.tabBarController?.tabBar.isHidden = false
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func btnEditClicked() {
        self.isToEdit = true
        self.txtfTitle.isUserInteractionEnabled = true
        self.txtfTitle.becomeFirstResponder()
        self.btnEditImage.isHidden = false
        self.manageRightNavigationButton()
    }
    func setUpUI() {
        self.setUpSegmentController()
        self.setupNavigation()
        CommonFunctions.showHUD(controller: self)
        self.viewModel.callWebServiceToGetGroupDetail(groupId: groupId) { (status, message) in
            CommonFunctions.hideHUD(controller: self)
            if status {
                self.setUpHeaderViewData()
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
    func setUpHeaderViewData() {
        let groupDetails = viewModel.groupDateil()
        self.txtfTitle.text = groupDetails?.groupName
        self.imgvHader.kf.setImage(with: URL(string: imageBucket + (groupDetails?.image ?? "")), placeholder: UIImage(named: "default_placeholder"))
    }
    func setUpSegmentController() {
        var titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor(red: 121/255, green: 121/255, blue: 121/255, alpha: 1), NSAttributedString.Key.font:UIFont(name: "HelveticaNeue-Light", size: 14)!]
        segmentedControl.setTitleTextAttributes(titleTextAttributes, for: .normal)
        titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white,NSAttributedString.Key.font:UIFont(name: "HelveticaNeue-Light", size: 14)!]
        segmentedControl.setTitleTextAttributes(titleTextAttributes, for: .selected)
        segmentedControl.addTarget(self, action: #selector(self.segmentedControlValueChanged(_:)), for:.valueChanged)
        segmentedControl.addTarget(self, action: #selector(self.segmentedControlValueChanged(_:)), for:.touchUpInside)
        segmentedControl.addCornerRadiusWithShadow(color: #colorLiteral(red: 0.05882352963, green: 0.180392161, blue: 0.2470588237, alpha: 1), borderColor: .clear, cornerRadius: 10)
        if #available(iOS 13.0, *) {
            segmentedControl.backgroundColor = UIColor.white
            segmentedControl.tintColor = UIColor.white
        }
    }
    @IBAction func btnEditImageClicked(_ sender: Any) {
        self.view.endEditing(true)
        showImagePickingOptions(type: PickingMediaType.image, allowEditing: true) { (result) in
            self.selectedImage = result as? UIImage
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                self.imgvHader.image = result as? UIImage
            }
            if let img = result as? UIImage {
                self.uploadProfileImage(img)
            }
        }
    }
    func uploadProfileImage(_ image: UIImage) {
        guard let imgData = image.jpegData(compressionQuality: 0.5) else {
            return
        }
        let file = MultipartFile()
        file.fileData = imgData
        DispatchQueue.main.async {
            CommonFunctions.showHUD(controller: self)
        }
        Services.makeMultipartRequest(forStringUrl: ServiceAPI.api_upload_media.urlString(), method: .post, file: file, otherParameters: nil) { (response, message) in
            DispatchQueue.main.async {
                CommonFunctions.hideHUD(controller: self)
            }
            let responseData = response?.result.value as? [String : Any]
            print(responseData as Any)
            let data = responseData?["data"] as? [String : Any]
            
            if let name = data?["fd"] as? String {
                self.viewModel.updateGroupImage(image: name)
            }
        }
    }
    @IBAction func segmentedControlValueChanged(_ sender: UISegmentedControl) {
        self.tableView.reloadData()
    }
    @IBAction func btnSuperViseClicked(_ sender: UIButton) {
        
    }
    @IBAction func btnCellMenuClicked(_ sender:UIButton) {
        self.setupMenuDropDown(sender)
        menuDropDown.show()
    }
    func setupMenuDropDown(_ sender:UIButton) {
        menuDropDown.anchorView = sender
        menuDropDown.bottomOffset = CGPoint(x: 0, y: sender.frame.size.height )
        let trip = self.viewModel.trip(at: sender.tag)
        self.indexToManageSupervise = sender.tag
        var arrStr = ["Supervise", "View Details"]
        if (trip?.supervisorStar ?? 0) == 1{
            arrStr = ["Withdraw Supervise", "View Details"]
        }
        var arrDataSource = [DropDownDataModel]()
        for str in arrStr {
            let dataModel2 = DropDownDataModel()
            dataModel2.item = str
            dataModel2.dataObject = trip as AnyObject
            arrDataSource.append(dataModel2)
        }
        menuDropDown.dataSource = arrDataSource
        menuDropDown.selectionAction = {[weak self] (index, item) in
            guard let trip = item.dataObject as? Trip, let self = self else { return }
            switch index {
            case 0:
                if item.item == "Supervise"{
                    CommonFunctions.showHUD(controller: self)
                    self.viewModel.apiCallToSuperviseTrip(tripId: trip.tripID, completion: { (status, message) in
                        CommonFunctions.hideHUD(controller: self)
                        if status  || message == "You are now appointed as a supervisor."{
                            self.setUpUI()
                        } else {
                            self.showCustomAlertWith(
                                message: message,
                                descMsg: "",
                                itemimage: nil,
                                actions: nil
                            )
                        }
                        
                    })
                }else{
                    let actionYes : [String: () -> Void] = [ "YES" : {
                        CommonFunctions.showHUD(controller: self)
                        self.viewModel.apiCallToWithdrawSupervisor(tripId: trip.tripID, completion: { (status, message) in
                            CommonFunctions.hideHUD(controller: self)
                            if status || message == "You are now removed as supervisor."{
                                self.setUpUI()
                            } else {
                                self.showCustomAlertWith(
                                    message: message,
                                    descMsg: "",
                                    itemimage: nil,
                                    actions: nil
                                )
                            }
                        })
                        }]
                    let actionNo : [String: () -> Void] = [ "No" : {
                        print("tapped NO")
                        }]
                    let arrayActions = [actionYes, actionNo]
                    self.showCustomAlertWith (
                        message: "Are you sure you want to withdraw as supervisor?",
                        descMsg: "",
                        itemimage: nil,
                        actions: arrayActions
                    )
                }
                break
            case 1:
                self.navigateToParentTrackingVC(trip: trip)
            default:
                break
            }
        }
    }
    func refreshCellFor(index:Int) {
        self.viewModel.updateSuperViserFor(index: index)
        self.tableView.reloadRows(at: [IndexPath(row: index, section: 0)], with: UITableView.RowAnimation.none)
    }
    func saveData() {
        if !CommonFunctions.isNetworkReachable() {
            self.showCustomAlertWith(message: NO_INTERNET_CONNECTION, descMsg: "", itemimage: nil, actions: nil)
            return
        }
        CommonFunctions.showHUD(controller: self)
        viewModel.apiCallToEditGroupDetail { (status, message) in
            CommonFunctions.hideHUD(controller: self)
            self.isToEdit = false
            self.manageRightNavigationButton()
            self.btnEditImage.isHidden = true
            self.txtfTitle.isUserInteractionEnabled = false
            if status {
                self.showCustomAlertWith(
                    message: "Group Details has been updated successfully.",
                    descMsg: "",
                    itemimage: nil,
                    actions: nil
                )
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
    @IBAction func btnStartClciked(_ sender: UIButton) {
        guard let trip = self.viewModel.trip(at: sender.tag) else { return }
        if sender.isSelected{
            self.navigateToParentTrackingVC(trip: trip, isToStart:true)
        }else{
            let actionYes : [String: () -> Void] = [ "YES" : {
                CommonFunctions.showHUD(controller: self)
                self.viewModel.apiCallToStopTrip(tripId: trip.tripID) { (status, message) in
                    CommonFunctions.hideHUD(controller: self)
                    if status {
                        self.setUpUI()
                    } else {
                        self.setUpUI()
                        self.showCustomAlertWith(
                            message: message,
                            descMsg: "",
                            itemimage: nil,
                            actions: nil
                        )
                    }
                }
                }]
            let actionNo : [String: () -> Void] = [ "No" : {
                print("tapped NO")
                }]
            let arrayActions = [actionYes, actionNo]
            self.showCustomAlertWith (
                message: "Are you sure you want to complete trip?",
                descMsg: "",
                itemimage: nil,
                actions: arrayActions
            )
        }
        
    }
    @IBAction func btnSaveClicked() {
        self.view.endEditing(true)
        self.viewModel.updateGroupName(groupName: self.txtfTitle.text ?? "")
        viewModel.validateTextFields(completion: { (status, message) in
            if status {
                self.saveData()
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
    func navigateToParentTrackingVC(trip:Trip, isToStart:Bool = false) {
        let vc = ParentTrackingVC.instantiate(fromStoryboard: .groups)
        vc.tripStatus = trip.status
        vc.isSuperviserMode = self.viewModel.checkIfNevigateAsSuperViserMode(trip: trip)
        vc.isSuperviser = trip.supervisorStar
        vc.isToStart = isToStart
        vc.parentID =  trip.supervisorID
        if trip.isSupervised.boolValue == false{
            vc.isSuperviserMode = false
            vc.isToStart = false
        }
        //        vc.tripId = 125//trip.tripID
        vc.tripId = trip.tripID
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
extension GroupDetailVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.segmentedControl.selectedSegmentIndex == 0{
            return self.viewModel.studentsCount
        }else {
            return self.viewModel.tripsCount
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch self.segmentedControl.selectedSegmentIndex {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: GroupStudentTableViewCell.cellIdentifier, for: indexPath) as! GroupStudentTableViewCell
            cell.studentData = self.viewModel.student(at: indexPath.row)
            return cell
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: GroupTripTableViewCell.cellIdentifier, for: indexPath) as! GroupTripTableViewCell
            cell.btnCellMenu.tag = indexPath.row
            cell.btnStart.tag = indexPath.row
            cell.trips = self.viewModel.trip(at: indexPath.row)
            return cell
        }
    }
}

extension GroupDetailVC:UITableViewDelegate {
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let cell = tableView.dequeueReusableCell(withIdentifier: "HeaderCell")
        return cell?.contentView
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if self.segmentedControl.selectedSegmentIndex == 0{
            return 0
        }else {
            return 30
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let trip = self.viewModel.trip(at: indexPath.row), self.segmentedControl.selectedSegmentIndex == 1 else {return}
        self.navigateToParentTrackingVC(trip: trip)
        
    }
}
extension GroupDetailVC: UITextFieldDelegate {
    @IBAction func updateInputFieldValue(textField: UITextField) {
        guard let text = textField.text else { return }
        if text.count >= 25{
            textField.text = String(text.prefix(25))
        }
    }
}
