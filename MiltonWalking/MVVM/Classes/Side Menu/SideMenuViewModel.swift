//
//  SideMenuViewModel.swift
//  MiltonWalking
//
//  Created by Jitendra Singh on 10/07/20.
//  Copyright © 2020 Appzoro. All rights reserved.
//

import UIKit

class SideMenuViewModel: NSObject {
    private var arrSideMenu: [SideMenuField] = [SideMenuField]()
    
    //Login
    var sideMenuCount: Int {
        return arrSideMenu.count
    }
    func setupDataSource(completion: @escaping (() -> Void)) {
        let profile = SideMenuField(title: "Profile", icon: #imageLiteral(resourceName: "user (1)"))
        let trips = SideMenuField(title: "Trips", icon: #imageLiteral(resourceName: "bus (3)"))
        let tAndC = SideMenuField(title: "Terms & Conditions", icon: #imageLiteral(resourceName: "Solid"))
        let plociy = SideMenuField(title: "Privacy Policy", icon: #imageLiteral(resourceName: "privacy"))
        let tips = SideMenuField(title: "Tips", icon: #imageLiteral(resourceName: "pen"))
        let about = SideMenuField(title: "About", icon: #imageLiteral(resourceName: "help"))
        let logout = SideMenuField(title: "Logout", icon: #imageLiteral(resourceName: "logout"))
        arrSideMenu = [profile, trips, tAndC, plociy, tips, about, logout]
        completion()
    }
    func sideMenuField(at index: Int) -> SideMenuField? {
        if let data = arrSideMenu[safe: index],index < arrSideMenu.count {
            return data
        }
        return nil
    }
    func callWebServiceToLogout(completion: @escaping (Bool, String) -> Void) {
           Services.makeRequest(forStringUrl: ServiceAPI.api_logout.urlString(), method: .get, parameters: nil) { (response, error) in
               if (error != nil) {
                   return completion(false, error ?? INTERNAL_SERVER_ERROR)
               } else if (response?.result.value as? [String : Any]) != nil {
                   guard let data = response?.data else { return }
                   return completion(true, "")
               }
           }
       }
}
struct SideMenuField {
    var title: String
    var icon: UIImage = UIImage()
}
