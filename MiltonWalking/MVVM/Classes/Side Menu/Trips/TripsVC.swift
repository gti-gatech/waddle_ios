//
//  TripsVC.swift
//  MiltonWalking
//
//  Created by Krishna Datt Shukla on 06/08/20.
//  Copyright © 2020 Appzoro. All rights reserved.
//

import UIKit

class TripsVC: UIViewController {
    
    @IBOutlet weak var tableViewTrips: UITableView!
    var errorlabel: UILabel!
    
    var arrayUpcoming = [TripDetail]()
    var arrayHistory = [TripDetail]()
    
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
        self.title = "Trips"
        errorlabel = UILabel(frame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: 50))
        errorlabel.text = "No Trips Found!"
        errorlabel.textAlignment = .center
        errorlabel.center = view.center
        view.addSubview(errorlabel)
        errorlabel.isHidden = true
        setupNavigation()
        self.view.backgroundColor = COLOR_DARK_GRAY
        getTrips()
    }
    
    func setupNavigation() {
        CommonFunctions.setLeftBarButtonItemWith(image: #imageLiteral(resourceName: "back"), action: #selector(backbtnClicked), view: self)
    }
    
    @IBAction func backbtnClicked() {
        self.navigationController?.popViewController(animated: true)
    }
    
}

extension TripsVC: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 44
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let viewHeader = UIView(frame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: 0))
        viewHeader.backgroundColor = COLOR_DARK_GRAY
        
        let label = UILabel(frame: CGRect(x: 30, y: 10, width: SCREEN_WIDTH - 100, height: 26))
        label.font = UIFont(name: "HelveticaNeue-Medium", size: 16.0)
        label.textColor = COLOR_DARK_BLUE_GRAY
        viewHeader.addSubview(label)
        label.text = section == 0 ? "Upcoming Trips" : "History"
        return viewHeader
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return arrayUpcoming.count
        }
        return arrayHistory.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DashboardCell") as! DashboardCell
        
        var trip: TripDetail!
        if indexPath.section == 0 {
            trip = arrayUpcoming[indexPath.row]
        } else {
            trip = arrayHistory[indexPath.row]
        }
        
        
        let dueDate = dateFormatterServer.date(from: trip.dueOn ?? "")
        let strDate = dateFormatterApp.string(from: dueDate!)
        cell.labelDate.text = "Date: \(strDate)"
        cell.labelSupervisor.text = "Supervisor: \(trip.fullName ?? "")"
        cell.labelStudent.text = "Student: \(trip.studentName ?? "")"
        cell.labelStop.text = "Pick up Stop: \(trip.stopName ?? "")"
        cell.labelGroup.text = trip.groupName ?? ""
        
//        if trip.supervisorStar == 1 {
//            cell.stackViewSupervisor.isHidden = false
//            cell.labelStudent.isHidden = true
//        } else {
//            cell.stackViewSupervisor.isHidden = true
//            cell.labelStudent.isHidden = false
//        }
        if ((trip.studentName ?? "").isEmpty){
            cell.stackViewSupervisor.isHidden = false
            cell.labelStudent.isHidden = true
        } else {
            cell.stackViewSupervisor.isHidden = true
            cell.labelStudent.isHidden = false
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return SCREEN_WIDTH * (125.0/375.0)
    }
}

extension TripsVC {
    func getTrips() {
        if !CommonFunctions.isNetworkReachable() {
            self.showCustomAlertWith(message: NO_INTERNET_CONNECTION, descMsg: "", itemimage: nil, actions: nil)
            return
        }
        CommonFunctions.showHUD(controller: self)
        let url = ServiceAPI.api_trip_history.urlString()
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
                    let response = try JSONDecoder().decode(TripsResponse.self, from: data)
                    self.parseResponse(response)
                } catch let error {
                    print(error)
                }
            }
        }
    }
    
    func parseResponse(_ response: TripsResponse) {
        self.arrayUpcoming.append(contentsOf: response.data.upcoming.supervisorUpcoming)
        self.arrayUpcoming.append(contentsOf: response.data.upcoming.studentsUpcoming)
        self.arrayHistory.append(contentsOf: response.data.history.supervisorHistory.previous)
        self.arrayHistory.append(contentsOf: response.data.history.supervisorHistory.yesterday)
        self.arrayHistory.append(contentsOf: response.data.history.supervisorHistory.today)
        self.arrayHistory.append(contentsOf: response.data.history.studentsHistory.previous)
        self.arrayHistory.append(contentsOf: response.data.history.studentsHistory.yesterday)
        self.arrayHistory.append(contentsOf: response.data.history.studentsHistory.today)
        tableViewTrips.reloadData()
        errorlabel.isHidden = (arrayHistory.count != 0 || arrayUpcoming.count != 0)
    }
}
