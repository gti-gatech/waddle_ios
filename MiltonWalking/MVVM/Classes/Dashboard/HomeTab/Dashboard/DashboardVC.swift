//
//  DashboardVC.swift
//  MiltonWalking
//
//  Created by Krishna Datt Shukla on 09/07/20.
//  Copyright © 2020 Appzoro. All rights reserved.
//

import UIKit

class DashboardVC: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var imageViewUser: UIImageView!
    @IBOutlet weak var viewUserImage: UIView!
    
    @IBOutlet weak var labelName: UILabel!
    @IBOutlet weak var labelDesc: UILabel!
    
    var errorLabel: UILabel!
    
    var viewModel = DashboardViewModel()
    
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
        self.setupGestureForSideMene()
        setupNavigation()
        viewUserImage.setCornerRadius(65.0, borderWidth: 7.0, borderColor: COLOR_PRIMARY_DENIM)
        imageViewUser.setCornerRadius(60.0, borderWidth: 0, borderColor: .clear)
        errorLabel = UILabel(frame: CGRect(x: 0, y: 400, width: SCREEN_WIDTH, height: 50))
        errorLabel.text = "No data Found!"
        errorLabel.textAlignment = .center
        view.addSubview(errorLabel)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.getData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    
    func setupNavigation() {
        navigationController?.setTransparentNavigationBar()
        CommonFunctions.setRightBarButtonItemWith(image: #imageLiteral(resourceName: "notification"), action: #selector(notificationTapped), view: self)
    }
    
    func setupView() {
        errorLabel.isHidden = true
        if let user = CommonFunctions.getUserDetailFromUserDefault() {
            let p = user.parentData
            labelName.text = "Hi, \(p.fullName)"
            labelDesc.text = "Your upcoming trips in the next two days "//"Your kids have taken \(self.viewModel.tripsWalked) trips this week"
            let strImage = imageBucket + p.image
            self.imageViewUser.kf.setImage(with: URL(string: strImage), placeholder: UIImage(named: "user_profile"))
        }
    }
    
    @IBAction func notificationTapped() {
        performSegue(withIdentifier: "HOME_TO_NOTIFICATION", sender: nil)
    }
    
    func clearUserDetails() {
        UserDefaults.standard.removeObject(forKey: USER_DETAILS)
    }
    
    func getData() {
        CommonFunctions.showHUDOnTop()
        viewModel.getDashboardData { (status, message) in
            DispatchQueue.main.async {
                CommonFunctions.hideHUDFromTop()
                if self.viewModel.tripCount > 0 {
                    self.errorLabel.isHidden = true
                } else {
                    self.errorLabel.isHidden = false
                }
            }
            self.setupView()
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
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        self.prepareSideMenu(segue: segue)
    }
    
}

extension DashboardVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.tripCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DashboardCell") as! DashboardCell
        
        if let trip = viewModel.getTrip(at: indexPath.row) as? SupervisorTrip {
            cell.stackViewSupervisor.isHidden = false
            cell.labelStudent.isHidden = true
            let dueDate = dateFormatterServer.date(from: trip.dueOn)
            let strDate = dateFormatterApp.string(from: dueDate!)
            cell.labelDate.text = "Date: \(strDate)"
            cell.labelSupervisor.text = "Supervisor: \(trip.supervisorName)"
            cell.labelStop.text = trip.groupName
        } else if let trip = viewModel.getTrip(at: indexPath.row) as? StudentTrip {
            cell.stackViewSupervisor.isHidden = true
            cell.labelStudent.isHidden = false
            let dueDate = dateFormatterServer.date(from: trip.dueOn)
            let strDate = dateFormatterApp.string(from: dueDate!)
            cell.labelDate.text = "Date: \(strDate)"
            cell.labelSupervisor.text = "Supervisor: \(trip.supervisorName)"
            cell.labelStudent.text = "Student: \(trip.studentName)"
            cell.labelStop.text = trip.groupName
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return SCREEN_WIDTH * (110.0/375.0)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = GroupDetailVC.instantiate(fromStoryboard: .groups)
        if let trip = viewModel.getTrip(at: indexPath.row) as? SupervisorTrip {
            vc.groupId = trip.groupID
        } else if let trip = viewModel.getTrip(at: indexPath.row) as? StudentTrip {
            vc.groupId = trip.groupID
        }
        vc.isFromDashboard = true
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}


