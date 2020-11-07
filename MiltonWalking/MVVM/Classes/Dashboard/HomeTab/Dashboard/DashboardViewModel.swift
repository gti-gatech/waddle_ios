//
//  DashboardViewModel.swift
//  MiltonWalking
//
//  Created by Krishna Datt Shukla on 22/07/20.
//  Copyright © 2020 Appzoro. All rights reserved.
//

import Foundation

class DashboardViewModel {
    
    private var dashboardResponse: DashBoardResponse?
    private var arrayTrips: [Any] = [Any]()
    var tripsWalked = 0
    var tripCount: Int {
        return arrayTrips.count
    }
    
    func getTrip(at index: Int) -> Any {
        return arrayTrips[index]
    }

    func getDashboardData(completion: @escaping (Bool, String) -> Void) {
        let url = ServiceAPI.api_get_home_data.urlString()
        Services.makeRequest(forStringUrl: url, method: .get, parameters: nil) { (response, error) in
            if (error != nil) {
                return completion(false, error ?? INTERNAL_SERVER_ERROR)
            } else if let responseJSON = response?.result.value as? [String : Any] {
                let responseDic: NSDictionary = responseJSON as NSDictionary
                print("response ->\(responseDic)")
                guard let data = response?.data else { return }
                do {
                    self.arrayTrips = [Any]()
                    self.dashboardResponse = try JSONDecoder().decode(DashBoardResponse.self, from: data)
                    if let parentD = self.dashboardResponse?.data.parentData, let auth = CommonFunctions.getUserDetailFromUserDefault()?.auth{
                        let loginD = loginData.init( parentData: parentD, auth: auth)
                        CommonFunctions.saveUserDetailInUserDefault(data:loginD)
                    }
                    self.tripsWalked = self.dashboardResponse?.data.tripsWalked ?? 0
                    self.arrayTrips.append(contentsOf: self.dashboardResponse?.data.supervisorTrips ?? [])
                    self.arrayTrips.append(contentsOf: self.dashboardResponse?.data.studentTrips ?? [])
                } catch let error {
                    print(error)
                }
                return completion(true, "")
            }
        }
    }
}
