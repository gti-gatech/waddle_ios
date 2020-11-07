//
//  GroupsVC.swift
//  MiltonWalking
//
//  Created by Jitendra Singh on 16/07/20.
//  Copyright © 2020 Appzoro. All rights reserved.
//

import UIKit
import GoogleMaps
class GroupsVC: UIViewController {
    
    @IBOutlet weak var btnAdd: UIButton!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var mapView: GMSMapView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var viewBottom: UIView!
    @IBOutlet weak var lblStopName: UILabel!
    @IBOutlet weak var lblGroupName: UILabel!

    var errorLabel: UILabel!

    let cellMenuDropDown = DropDown()
    
    var viewModel = GroupsViewModel()
    
    lazy var dateFormatterServer: DateFormatter = {
        let df = DateFormatter()
        df.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        return df
    }()
    
    lazy var dateFormatterApp: DateFormatter = {
        let df = DateFormatter()
        df.dateFormat = "MM/dd/yyyy"
        df.locale = Locale(identifier: "en_US")
        return df
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupNavigation()
        self.setUpView()
        self.setupGestureForSideMene()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.viewBottom.isHidden = true
        self.errorLabel.isHidden = true
        getGroups()
    }
    
    func setupNavigation() {
       navigationController?.setTransparentNavigationBar()
    }
    func setUpView() {
        self.tableView.contentInset = UIEdgeInsets(top: 20, left: 0, bottom: 10, right: 0)
        self.setUpSegmentController()
        mapView.delegate = self
        
        errorLabel = UILabel(frame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: SCREEN_HEIGHT))
        errorLabel.text = "No data Found!"
        errorLabel.textAlignment = .center
        view.addSubview(errorLabel)
        errorLabel.isHidden = true
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
    @IBAction func segmentedControlValueChanged(_ sender: UISegmentedControl) {
        self.errorLabel.isHidden = true
        self.viewBottom.isHidden = true

        switch sender.selectedSegmentIndex {
        case 0:
            self.tableView.isHidden = false
            self.mapView.isHidden = true
            self.btnAdd.isHidden = false
            getGroups()
            
        default:
            self.tableView.isHidden = true
            self.mapView.isHidden = false
            self.btnAdd.isHidden = true
            getStops()

        }
    }
    
    @IBAction func btnCellMenuClicked(_ sender:UIButton) {
        self.setupQtyDropDown(sender: sender)
        cellMenuDropDown.show()
    }
    
    @IBAction func btnAddClicked(_ sender: Any) {
        let vc = SelectGroupsVC.instantiate(fromStoryboard: .main)
        vc.isToAddGroup = true
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func setupQtyDropDown(sender:UIButton) {
        cellMenuDropDown.anchorView = sender
        cellMenuDropDown.bottomOffset = CGPoint(x: 0, y: sender.frame.size.height)
        let arrStr = ["Leave Group"]
        var arrDataSource = [DropDownDataModel]()
        for str in arrStr {
            let dataModel2 = DropDownDataModel()
            dataModel2.dataObject = sender.tag as AnyObject
            dataModel2.item = str
            arrDataSource.append(dataModel2)
        }
        cellMenuDropDown.dataSource = arrDataSource
        cellMenuDropDown.selectionAction = {[weak self] (index, item) in
            if index == 0 {
                let actionYes : [String: () -> Void] = [ "YES" : {
                    self?.leaveGroup(at: item.dataObject as? Int ?? 0)
                }]
                let actionNo : [String: () -> Void] = [ "No" : {
                    print("tapped NO")
                }]
                let arrayActions = [actionYes, actionNo]
                self?.showCustomAlertWith (
                    message: "Are you sure you want to exit the group?",
                    descMsg: "",
                    itemimage: nil,
                    actions: arrayActions
                )
            }
        }
    }
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        self.prepareSideMenu(segue: segue)
    }
    
    func leaveGroup(at index: Int) {
        if !CommonFunctions.isNetworkReachable() {
            self.showCustomAlertWith(message: NO_INTERNET_CONNECTION, descMsg: "", itemimage: nil, actions: nil)
            return
        }
        CommonFunctions.showHUD(controller: self)
        if let group = viewModel.group(at: index) {
            viewModel.leaveGroup(group.groupID ?? 0) { (status, message) in
                CommonFunctions.hideHUD(controller: self)
                if status {
                    self.showCustomAlertWith(
                        message: "You left the group succesfully.",
                        descMsg: "",
                        itemimage: nil,
                        actions: nil
                    )
                    self.getGroups()
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

}

extension GroupsVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.groupsCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: GroupListTableViewCell.cellIdentifier, for: indexPath) as! GroupListTableViewCell
        cell.btnCellMenu.tag = indexPath.row
        if let group = viewModel.group(at: indexPath.row) {
            cell.lblName.text = group.groupName
            cell.lblStudent.text = "Students: \(group.totalStudents ?? 0)"
            cell.stackViewSupervisor.isHidden = group.supervisorStar == 1 ? false : true
            cell.lblDistance.text = "Total trips walked: \(group.tripsWalked ?? 0)"
            let strImage = imageBucket + (group.image ?? "")
            cell.imgvParent.kf.setImage(with: URL(string: strImage), placeholder: UIImage(named: "user_profile"))
            guard let dueDate = dateFormatterServer.date(from: group.dueOn ?? "") else {
                cell.lblUpcomingDate.text = "No upcoming trips for now"
                return cell
            }
            
//            let cdate = Date()
//            if cdate.dayOfMonth == dueDate.dayOfMonth {
//                let calendar = Calendar.current
//                let diff = calendar.dateComponents([.hour, .minute], from: cdate, to: dueDate)
//                if let hour = diff.hour, hour > 0 {
//                    cell.lblUpcomingDate.text = "Upcoming date: In \(hour) \(hour == 1 ? "Hour" : "Hours")"
//                } else if let minute = diff.minute {
//                    cell.lblUpcomingDate.text = "Upcoming date: In \(minute) \(minute == 1 ? "Minute" : "Minutes")"
//                }
//            } else {
                let strDate = dateFormatterApp.string(from: dueDate)
                cell.lblUpcomingDate.text = "Upcoming date: \(strDate)"
//            }
        }
        return cell
    }
}

extension GroupsVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = GroupDetailVC.instantiate(fromStoryboard: .groups)
        if let group = viewModel.group(at: indexPath.row) {
            vc.groupId = group.groupID ?? 0
        }
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

extension GroupsVC {
    func getGroups() {
        if !CommonFunctions.isNetworkReachable() {
            self.showCustomAlertWith(message: NO_INTERNET_CONNECTION, descMsg: "", itemimage: nil, actions: nil)
            return
        }
        CommonFunctions.showHUD(controller: self)
        viewModel.getGroups { (status, message) in
            CommonFunctions.hideHUD(controller: self)
            if self.viewModel.groupsCount > 0 || self.segmentedControl.selectedSegmentIndex == 1 {
                self.errorLabel.isHidden = true
            } else {
                self.errorLabel.isHidden = false
            }
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
    
    func getStops() {
        if !CommonFunctions.isNetworkReachable() {
            self.showCustomAlertWith(message: NO_INTERNET_CONNECTION, descMsg: "", itemimage: nil, actions: nil)
            return
        }
        CommonFunctions.showHUD(controller: self)
        viewModel.apiCallForStops { (status, message) in
            CommonFunctions.hideHUD(controller: self)
            if status {
                self.manageAllAnnotaionPinsOnMap()
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
    
    func manageAllAnnotaionPinsOnMap() {
        self.viewModel.managePinsOnMap(mapView: self.mapView)
    }
}

extension GroupsVC: GMSMapViewDelegate {
    func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
        
        if marker.title == "" {
            return true
        }
        if let data = marker.userData as? SelectStopMapDM {
            self.viewBottom.isHidden = false
            self.lblStopName.text = "Default Stop: " + (data.name)
            self.lblGroupName.text = data.groupName ?? ""
        }

        return true
    }
}


