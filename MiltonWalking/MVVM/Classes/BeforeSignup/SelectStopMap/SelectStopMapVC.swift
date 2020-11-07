//
//  SelectStopMapVC.swift
//  MiltonWalking
//
//  Created by Jitendra Singh on 02/07/20.
//  Copyright © 2020 Appzoro. All rights reserved.
//

import UIKit
import GoogleMaps
import CoreLocation
class SelectStopMapVC: UIViewController{
    
    @IBOutlet weak var lblStopName: UILabel!
    @IBOutlet weak var mapView: GMSMapView!
    @IBOutlet weak var viewBottom: UIView!
    var viewModel = SelectStopMapViewModel()
    var doneConfirmStop:((SelectStopMapDM?) -> Void)?
    var currentLocation : CLLocation?
    var selectedStopMapData:SelectStopMapDM?
    var routeID:Int = 0
    var groupId:Int = 0
    var arrStudentID = [Int]()
    var isFromSelectGroupVC = false
    var isToUpdateParent = false
    var isToSchedule = false
    var isToEditSchedule = false
    var isToAddGroup = false // from GroupsVC tab
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
        LocationService.sharedInstance.delegate = self
        if isFromSelectGroupVC || self.isToEditSchedule{
            self.callWebSeviceGroupeStops()
        }else {
            self.callWebSeviceToGetStops()
        }
        self.setupNavigation()
    }
    func setupNavigation() {
        CommonFunctions.setLeftBarButtonItemWith(image: #imageLiteral(resourceName: "back"), action: #selector(backButtonAction), view: self)
    }
    @IBAction func backButtonAction() {
        if isToEditSchedule{
            self.dismiss(animated: true, completion: nil)
        }else{
            navigationController?.popViewController(animated: true)
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setTransparentNavigationBar()
        LocationService.sharedInstance.startUpdatingLocation()
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if !self.isFromSelectGroupVC || !self.isToUpdateParent || self.isToEditSchedule{
            self.navigationController?.setNavigationBarHidden(true, animated: true)
        }
        if self.isToSchedule || self.isToAddGroup{
            self.navigationController?.setNavigationBarHidden(false, animated: true)
        }
        LocationService.sharedInstance.stopUpdatingLocation()
    }
    func callWebSeviceToGetStops() {
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
    func callWebSeviceGroupeStops() {
        CommonFunctions.showHUD(controller: self)
        viewModel.apiCallForGroupeStops(routeID: "\(self.routeID)") { (status, message) in
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
    @IBAction func btnConfirmStopClicked(_ sender: Any) {
        guard  let data = selectedStopMapData else { return }
        if isToSchedule || self.isToAddGroup{
            let vc = SelectStudentsVC.instantiate(fromStoryboard: .main)
            vc.groupId = self.groupId
            vc.stopID = data.stopID
            vc.isToSchedule = isToSchedule
            vc.isToAddGroup = isToAddGroup
            self.navigationController?.pushViewController(vc, animated: true)
            return
        }else if self.isToEditSchedule{
            doneConfirmStop?(data)
            self.dismiss(animated: true, completion: nil)
        }
        if self.isFromSelectGroupVC { //This means for group route
            CommonFunctions.showHUD(controller: self)
            viewModel.apiCallForGroupeJoin(groupId: "\(self.groupId)", stopId: "\(data.stopID)", students: self.arrStudentID) { (status, message) in
                CommonFunctions.hideHUD(controller: self)
                if status {
                    self.navigationController?.pushViewController(AllSetOnBoardVC.instantiate(fromStoryboard: .main), animated: true)
                } else {
                    self.showCustomAlertWith(
                        message: message,
                        descMsg: "",
                        itemimage: nil,
                        actions: nil
                    )
                }
            }
            
        }else  {
            doneConfirmStop?(data)
            self.navigationController?.popViewController(animated: true)
        }
        
    }
    func manageAllAnnotaionPinsOnMap() {
        self.viewModel.managePinsOnMap(mapView: self.mapView)
        self.manageBottomViewForFirstTime()
    }
    func manageBottomViewForFirstTime() {
        guard let data = self.viewModel.getDefaultStopForFirstTime() else {return}
        self.viewBottom.isHidden = false
        self.selectedStopMapData = data
        self.lblStopName.text = "Default Stop: " + (data.name )
    }
}
// MARK: LocationService Delegate
extension SelectStopMapVC: LocationServiceDelegate{
    
    func tracingLocation(currentLocation: CLLocation) {
        LocationService.sharedInstance.stopUpdatingLocation()
        self.currentLocation = currentLocation
//        mapView.camera = GMSCameraPosition(target: currentLocation.coordinate, zoom: 15, bearing: 0, viewingAngle: 0)
        let marker = GMSMarker()
        marker.icon = #imageLiteral(resourceName: "home")
        marker.title = "Home"
        marker.position = CLLocationCoordinate2D(latitude:currentLocation.coordinate.latitude, longitude:currentLocation.coordinate.longitude)
        marker.tracksInfoWindowChanges = false
        marker.map = self.mapView
    }
    
    func tracingLocationDidFailWithError(error: NSError) {
        print("tracing Location Error : \(error.description)")
    }
}
// MARK: - GMSMapViewDelegate
extension SelectStopMapVC: GMSMapViewDelegate {
    func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
        if marker.title == "Home"{
            return true
        }
        self.viewBottom.isHidden = false
        self.selectedStopMapData = marker.userData as? SelectStopMapDM
        self.lblStopName.text = "Default Stop: " + (marker.title ?? "")
        return true
    }
}
