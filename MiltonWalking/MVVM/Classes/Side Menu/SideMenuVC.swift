//
//  SideMenuVC.swift
//  MiltonWalking
//
//  Created by Jitendra Singh on 09/07/20.
//  Copyright © 2020 Appzoro. All rights reserved.
//

import UIKit
import SideMenu
class SideMenuVC: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    var viewModel = SideMenuViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.setupDataSource {
            
            self.tableView.reloadData()
        }
    }
    
    @IBAction func logout() {
        let actionYes : [String: () -> Void] = [ "YES" : {
            self.callWebServiceToLogOutUSer()
            
            }]
        let actionNo : [String: () -> Void] = [ "No" : {
            print("tapped NO")
            }]
        let arrayActions = [actionYes, actionNo]
        guard let tabbarVC = (self.view.window?.rootViewController as?CustomTabBarController), let currnetVC = tabbarVC.viewControllers?[tabbarVC.selectedIndex] else {return}
        self.dismiss(animated: false, completion: nil)
        currnetVC.showCustomAlertWith (
            message: "Are you sure you want to logout?",
            descMsg: "",
            itemimage: nil,
            actions: arrayActions
        )
    }
    func callWebServiceToLogOutUSer() {
        self.viewModel.callWebServiceToLogout { (status, message) in
            self.clearUserDetails()
            AppDelegate.sharedInstance.setupLoginAsRoot()
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
    func clearUserDetails() {
        UserDefaults.standard.removeObject(forKey: USER_DETAILS)
        UserDefaults.standard.removeObject(forKey: AUTHTOKEN)
        
    }
}

extension SideMenuVC:UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.sideMenuCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: SideMenuTableViewCell.cellIdentifier, for: indexPath) as!SideMenuTableViewCell
        cell.data = viewModel.sideMenuField(at: indexPath.row)
        return cell
    }
}
extension SideMenuVC:UITableViewDelegate{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let tabbarVC = (self.view.window?.rootViewController as?CustomTabBarController) else {
            dismiss(animated: false, completion: nil)
            return
        }
        switch indexPath.row {
        case 0:
            self.navigationController?.pushViewController(ParentDetailVC.instantiate(fromStoryboard: .dashboard), animated: false)
            tabbarVC.hidesBottomBarWhenPushed = true
            
        case 1:
            self.navigationController?.pushViewController(TripsVC.instantiate(fromStoryboard: .trips), animated: false)
            dismiss(animated: false, completion: nil)
        case 2:
            let vc = TermAndConditionsVC.instantiate(fromStoryboard: .main)
            vc.isFromSideMenu = true
            vc.webViewType = .terms
            self.navigationController?.pushViewController(vc, animated: false)
            dismiss(animated: false, completion: nil)
        case 3:
            let vc = TermAndConditionsVC.instantiate(fromStoryboard: .main)
            vc.isFromSideMenu = true
            vc.webViewType = .privacy
            self.navigationController?.pushViewController(vc, animated: false)
            dismiss(animated: false, completion: nil)
        case 4:
            let vc = TermAndConditionsVC.instantiate(fromStoryboard: .main)
            vc.isFromSideMenu = true
            vc.webViewType = .tips
            self.navigationController?.pushViewController(vc, animated: false)
            dismiss(animated: false, completion: nil)
        case 5:
            let vc = TermAndConditionsVC.instantiate(fromStoryboard: .main)
            vc.isFromSideMenu = true
            vc.webViewType = .about
            self.navigationController?.pushViewController(vc, animated: false)
            dismiss(animated: false, completion: nil)
        case 6:
            logout()
        default:
            break
        }
    }
    
}
