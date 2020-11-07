//
//  SelectGroupsVC.swift
//  MiltonWalking
//
//  Created by Krishna Datt Shukla on 07/07/20.
//  Copyright © 2020 Appzoro. All rights reserved.
//

import UIKit

class SelectGroupsVC: UIViewController {
    
    @IBOutlet weak var tableViewGroups: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!

    var viewModel = SelectGroupsViewModel()
    var arrStudentID = [Int]()
    var isToSchedule = false
    var isToAddGroup = false // from GroupsVC tab 
    override func viewDidLoad() {
        super.viewDidLoad()

        setupNavigation()
        setupView()
    }
    
    func setupNavigation() {
        CommonFunctions.setLeftBarButtonItemWith(image: #imageLiteral(resourceName: "back"), action: #selector(backButtonAction), view: self)
        CommonFunctions.setRightBarButtonItemWith(image: #imageLiteral(resourceName: "cancel"), action: #selector(cancelButtonAction), view: self)
        self.navigationItem.rightBarButtonItem?.tintColor = UIColor(red: 22/255, green: 31/255, blue: 61/255, alpha: 1)
    }
    
    func setupView() {
        searchBar.setSearchFieldBackgroundImage(UIImage(), for: .normal)
        searchBar.setBackgroundImage(UIImage(), for: .any, barMetrics: .default)
        searchBar.setCornerRadius(10, borderWidth: 0, borderColor: .clear)
        searchBar.returnKeyType = .default
        searchBar.setImage(#imageLiteral(resourceName: "search"), for: .search, state: .normal)
        let textFieldInsideSearchBar = searchBar.value(forKey: "searchField") as? UITextField
        textFieldInsideSearchBar?.textColor = #colorLiteral(red: 0.0862745098, green: 0.1215686275, blue: 0.2392156863, alpha: 1)
        
        getAllGroups()
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension SelectGroupsVC {
    
    @IBAction func backButtonAction() {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func cancelButtonAction() {
        navigationController?.popViewController(animated: true)
    }
}

extension SelectGroupsVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.groupsCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SelectGroupsCell") as! SelectGroupsCell
        if let group = viewModel.group(at: indexPath.row) {
            cell.setupCellWith(group)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let group = viewModel.group(at: indexPath.row) {
            let vc = SelectStopMapVC.instantiate(fromStoryboard: .main)
            vc.routeID = group.routeID
            vc.groupId = group.groupID
            vc.isFromSelectGroupVC = true
            vc.arrStudentID = self.arrStudentID
            vc.isToSchedule = self.isToSchedule
            vc.isToAddGroup = self.isToAddGroup
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
}

extension SelectGroupsVC: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        self.viewModel.filterGroupArray(searchText: searchText) { (_) in
            self.tableViewGroups.reloadData()
        }
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
}

extension SelectGroupsVC {
    
    func getAllGroups() {
        if !CommonFunctions.isNetworkReachable() {
            self.showCustomAlertWith(message: NO_INTERNET_CONNECTION, descMsg: "", itemimage: nil, actions: nil)
            return
        }
        CommonFunctions.showHUD(controller: self)
        viewModel.getGroups { (status, message) in
            CommonFunctions.hideHUD(controller: self)
            if status {
                self.tableViewGroups.reloadData()
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
