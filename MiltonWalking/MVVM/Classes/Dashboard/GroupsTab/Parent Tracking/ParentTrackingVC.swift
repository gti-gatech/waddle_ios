//
//  ParentTrackingVC.swift
//  MiltonWalking
//
//  Created by Jitendra Singh on 31/07/20.
//  Copyright © 2020 Appzoro. All rights reserved.
//

import UIKit
import GoogleMaps
import CoreLocation
import Starscream
class ParentTrackingVC: UIViewController {
    

    @IBOutlet weak var constraintLViewBottom: NSLayoutConstraint!
    @IBOutlet weak var constraintTViewBottom: NSLayoutConstraint!
    @IBOutlet weak var constraintHTableView: NSLayoutConstraint!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var constraintBViewSuperStudent: NSLayoutConstraint!
    @IBOutlet weak var viewSuperStudent: UIView!
    @IBOutlet weak var btnShowHideStudent: UIButton!
    
    @IBOutlet weak var btnSlider: UIButton!
    @IBOutlet weak var viewSlider: UIView!
    @IBOutlet weak var mapView: GMSMapView!
    var viewModel = ParentTrackingVM()
    var tableContentHeight:CGFloat = 0
    var isSuperviserMode = false
    var isSuperviser = 0
    var tripId = 0
    var currentLocation : CLLocation?
    var parentID = ""
    var timerChat:Timer?
    var tripStatus:TripCompleteStatus = .tripNotStarted
    var isToStart = false
    var annotationApiCalled = false
    override func viewDidLoad() {
        super.viewDidLoad()
        if !self.isSuperviser.boolValue{
                    self.constraintTViewBottom.constant = 0
                    self.constraintLViewBottom.constant = 0
                    self.view.layoutIfNeeded()
                }
        mapView.delegate = self
        LocationService.sharedInstance.delegate = self
        self.setupNavigation()
        self.setupUI()
        navigationController?.setTransparentNavigationBar()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setTransparentNavigationBar()
        LocationService.sharedInstance.startUpdatingLocation()
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        LocationService.sharedInstance.stopUpdatingLocation()
    }
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        self.timerChat?.invalidate()
        SocketIOManager.shared.disconnectSocket()
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        viewSuperStudent.roundCorners(corners: [.topLeft, .topRight], radius: 60)
    }
    
    func setupUI() {
        self.viewSlider.isHidden = true
        if !self.isSuperviser.boolValue{
            self.viewSlider.isHidden = false
            self.btnSlider.isHidden = false
            self.btnShowHideStudent.isHidden = true
//            self.constraintHTableView.constant = 0
//            self.constraintLViewBottom.constant = 0
            self.view.layoutIfNeeded()
        }else{
            self.viewSlider.isHidden = true
            self.btnSlider.isHidden = true
            self.btnShowHideStudent.isHidden = false
        }
        if tripStatus == .tripNotStarted && self.isSuperviser.boolValue && isToStart{
            self.callSrtartTrip()
            self.tripStatus = .tripStarted
            self.isSuperviserMode = true
        }
        if self.tripStatus == .tripStarted && self.isSuperviser.boolValue{
            CommonFunctions.setRightBarButtonItemWith(title: "End Trip", action: #selector(btnEndTripClicked), view: self)
            self.isSuperviserMode = true
        }
        self.manageSocket()
        self.mapView.isMyLocationEnabled = true
        CommonFunctions.showHUD(controller: self)
        self.viewModel.apiCallForTripMap(tripId: tripId) { (status, message) in
            CommonFunctions.hideHUD(controller: self)
            if status {
                self.manageAllAnnotaionPinsOnMap()
                
                self.tableView.reloadData()
                self.tableContentHeight  = self.tableView.contentSize.height
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
    func callSrtartTrip()  {
        CommonFunctions.showHUD(controller: self)
        self.viewModel.apiCallToStartTrip(tripId: tripId) { (status, message) in
            CommonFunctions.hideHUD(controller: self)
            if status {
                
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
    func disableTripButton() {
        if let button = self.navigationItem.rightBarButtonItem {
            button.isEnabled = false
            button.tintColor = UIColor.clear
        }
    }
    @objc func btnEndTripClicked()  {
        let actionYes : [String: () -> Void] = [ "YES" : {
            CommonFunctions.showHUD(controller: self)
            self.viewModel.apiCallToStopTrip(tripId: self.tripId) { (status, message) in
                CommonFunctions.hideHUD(controller: self)
                if status {
                    self.disableTripButton()
                } else {
                    if message == "Trips Ended successfully."{
                        self.disableTripButton()
                    }
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
    func manageAllAnnotaionPinsOnMap() {
        self.viewModel.managePinsOnMap(mapView: self.mapView, completion: { _ in
            self.tableView.reloadData()
        })
    }
    func setupNavigation() {
        CommonFunctions.setLeftBarButtonItemWith(image: #imageLiteral(resourceName: "back"), action: #selector(backButtonAction), view: self)
    }
    func manageSocket() {
        SocketIOManager.shared.connectSocket { (isConnected) in
            self.joinSocketTrip()
            self.timerChat = Timer.scheduledTimer(timeInterval: 5, target: self, selector: #selector(self.updateStatusSocket), userInfo: nil, repeats: true)
            self.setSocketListner()
        }
    }
    func setSocketListner() {
        SocketIOManager.Events.tripStatusChanged.listen { [weak self] (result) in
            self?.viewModel.setSocketData(response:result , completion: {status in
                if status{
                    self?.tableView.reloadData()
                    self?.getTableHeight()
                    if self?.viewModel.isAllStudnetPickedUp() ?? false{
                        self?.constraintHTableView.constant = self?.tableContentHeight ?? 200
                    }
                }
            })
            // print(result[0])
        }
    }
    @objc func updateStatusSocket() {
        let param = ["parentId": CommonFunctions.getUserDetailFromUserDefault()?.parentData.parentID ?? "" ,
                     "longitude": self.mapView.myLocation?.coordinate.longitude ?? 0,
                     "latitude": self.mapView.myLocation?.coordinate.latitude ?? 0,
                     "tripId": self.tripId,
            ] as [String : Any]
        SocketIOManager.Events.updateLocation.emit(params: param)
    }
    func joinSocketTrip() {
        let param = [
            "tripId": self.tripId,
        ]
        SocketIOManager.Events.joinTripUpdates.emit(params: param)
    }
    @IBAction func backButtonAction() {
        navigationController?.popViewController(animated: true)
    }
    @IBAction func btnShowHideStudentClicked(_ sender: Any) {
        self.getTableHeight()
 
        self.constraintHTableView.constant = self.tableContentHeight
        if self.btnShowHideStudent.isSelected && self.btnSlider.isSelected{
            self.constraintBViewSuperStudent.constant = -self.tableContentHeight
        }else{
            self.constraintBViewSuperStudent.constant = 0 // to show
        }
        self.btnShowHideStudent.isSelected = !self.btnShowHideStudent.isSelected
        self.btnSlider.isSelected = !self.btnSlider.isSelected
        UIView.animate(withDuration: 0.3, animations: {
                self.view.layoutIfNeeded()
            }, completion: {res in
                //Do something
        })
    }
    func getTableHeight() {
        var height:CGFloat = 0
        if self.isSuperviser.boolValue && self.tripStatus == .tripStarted {
            height = height + (self.viewModel.isAllStudnetPickedUp() ? 0 : 75)
        }
        self.viewSlider.isHidden = true
        if self.isSuperviser.boolValue && (tripStatus == .tripNotStarted){
            height = height + (56.0)*CGFloat(self.viewModel.getTripDataCount())
        }else if self.isSuperviser.boolValue && tripStatus == .tripStarted{
            height = height + (56.0)*CGFloat(self.viewModel.getTripDataCount())
        }else{
            self.viewSlider.isHidden = false
            self.btnShowHideStudent.isHidden = true
            height = height + (70)*CGFloat(self.viewModel.getTripDataCount())
        }
        if height > self.view.frame.height/2{
            height = self.view.frame.height/2
        }
        self.tableContentHeight = height
    }
    @IBAction func btnCallClicked(_ sender: UIButton) {
        guard let tripD = self.viewModel.getTipDataFor(index: sender.tag) else { return }
        self.callNumber(phoneNumber: tripD.contact)
    }
    @IBAction func btnStudentPickClicked(_ sender: UIButton) {
        guard let studentData = self.viewModel.getTipDataFor(index: sender.tag) else { return }
        let param = [
            "studentId": studentData.studentID,
            "tripId": studentData.tripID,
        ]
        SocketIOManager.Events.markPresent.emit(params: param)
    }
    
    private func callNumber(phoneNumber:String) {
        let number = phoneNumber.filter { (item) -> Bool in
            switch item {
                case "(",")"," ","-":
                    return false
                default:
                    return true
            }
        }
        if let url = URL(string: "tel://\(number)"),
        UIApplication.shared.canOpenURL(url) {
           if #available(iOS 10, *) {
             UIApplication.shared.open(url, options: [:], completionHandler:nil)
            } else {
                UIApplication.shared.openURL(url)
            }
        } else {
                 self.showCustomAlertWith(
                     message: "Unable to process. Please check mobile number",
                     descMsg: "",
                     itemimage: nil,
                     actions: nil
                 )
        }
    }
}
// MARK: LocationService Delegate
extension ParentTrackingVC: LocationServiceDelegate{
    
    func tracingLocation(currentLocation: CLLocation) {
        self.currentLocation = currentLocation
//        mapView.camera = GMSCameraPosition(target: currentLocation.coordinate, zoom: 15, bearing: 0, viewingAngle: 0)
        let marker = GMSMarker()
        marker.icon = #imageLiteral(resourceName: "home")
        marker.title = "Home"
        marker.position = CLLocationCoordinate2D(latitude:currentLocation.coordinate.latitude, longitude:currentLocation.coordinate.longitude)
        marker.tracksInfoWindowChanges = false
        marker.map = self.mapView
        if annotationApiCalled{
            self.manageAllAnnotaionPinsOnMap()
            annotationApiCalled = true
        }
    }
    
    func tracingLocationDidFailWithError(error: NSError) {
        print("tracing Location Error : \(error.description)")
    }
}
// MARK: - GMSMapViewDelegate
extension ParentTrackingVC: GMSMapViewDelegate {
    func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
        if marker.title == "Home"{
            return true
        }
        return true
    }
}

extension ParentTrackingVC:UITableViewDataSource, UITableViewDelegate{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0{
            if self.isSuperviser.boolValue && self.tripStatus == .tripStarted{
                return 1
            }
            return 0
        }
        return self.viewModel.getTripDataCount()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0{
            let cell = tableView.dequeueReusableCell(withIdentifier: PickeUpInfoTableViewCell.cellIdentifier, for: indexPath) as! PickeUpInfoTableViewCell
            let data = self.viewModel.getStudentNumberToPickAndDistanceAndStopName()
            cell.updateUI(studentNumber: data.0, distance: data.1)
            return cell
        }
        if self.isSuperviser.boolValue && (tripStatus == .tripNotStarted){
            let cell = tableView.dequeueReusableCell(withIdentifier: SuperviseNonTrackingCell.cellIdentifier, for: indexPath) as! SuperviseNonTrackingCell
            cell.tripData = self.viewModel.getTipDataFor(index: indexPath.row)
            return cell
        }else if self.isSuperviser.boolValue && tripStatus == .tripStarted{
            let cell = tableView.dequeueReusableCell(withIdentifier: ParentTrackingStudentCell.cellIdentifier, for: indexPath) as! ParentTrackingStudentCell
            cell.btnSelection.tag = indexPath.row
            cell.btnCall.tag = indexPath.row
            cell.tripData = self.viewModel.getTipDataFor(index: indexPath.row)
            return cell
        }else{
            let data = self.viewModel.getStudentStopNameDistanceTimePickedStatusFor(index: indexPath.row)
            let cell = tableView.dequeueReusableCell(withIdentifier: ParentViewTableViewCell.cellIdentifier, for: indexPath) as! ParentViewTableViewCell
            cell.updateUI(studentName: data.0, stopName: data.1, distance: data.2, time: data.3, status: data.4)
            return cell
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0{
            return 0
        }
        return UITableView.automaticDimension
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let tripData = self.viewModel.getTipDataFor(index: indexPath.row) else {return}
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if self.isSuperviser.boolValue && self.tripStatus == .tripStarted && section == 1{
            return self.viewModel.isAllStudnetPickedUp() ? 0 : 75
        }
        return 0
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let cell = tableView.dequeueReusableCell(withIdentifier: PickeUpInfoTableViewCell.cellIdentifier) as! PickeUpInfoTableViewCell
        let data = self.viewModel.getStudentNumberToPickAndDistanceAndStopName()
        cell.updateUI(studentNumber: data.0, distance: data.1)
        return cell.contentView
    }
}
