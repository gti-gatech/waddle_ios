//
//  GroupDetailVM.swift
//  MiltonWalking
//
//  Created by Jitendra Singh on 30/07/20.
//  Copyright © 2020 Appzoro. All rights reserved.
//

import UIKit

class GroupDetailVM {
    private var groupDetailData: GroupDetailData?
    
    var studentsCount:Int {
        return self.groupDetailData?.groupStudents.count ?? 0
    }
    var tripsCount: Int {
        return groupDetailData?.trips.count ?? 0
    }

    func updateGroupName(groupName:String) {
        self.groupDetailData?.groupDetails.groupName = groupName
    }
    func updateGroupImage(image:String) {
        self.groupDetailData?.groupDetails.image = image
    }
    func student(at index: Int) -> GroupStudent? {
        guard let student = self.groupDetailData?.groupStudents[safe: index] else { return nil }
        return student
    }
    func trip(at index: Int) -> Trip? {
        guard let trip = self.groupDetailData?.trips[safe: index] else { return nil }
        return trip
    }
    func groupDateil() -> GroupDetails? {
        return self.groupDetailData?.groupDetails
    }
    func checkIfNevigateAsSuperViserMode(trip:Trip) -> Bool {
        let df = DateFormatter()
        df.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        guard let dueDate = df.date(from: trip.dueOn), trip.supervisorStar == 1 else {
            return false
        }
        if trip.status == .tripStarted  {
            return true
        }else {
            return false
        }
    }
    func updateSuperViserFor(index:Int) {
//        guard var trip = self.groupDetailData?.trips[safe: index] else { return }
//        trip.supervisorStar = (trip.supervisorStar == 1 ) ? 0 : 1
//        self.groupDetailData?.trips[index] = trip
    }
    func validateTextFields(completion: @escaping ((Bool, String?) -> Void)) {
        if self.groupDetailData?.groupDetails.groupName.isEmpty ?? true{
            return completion(false, "Please enter group name")
        }
        return completion(true, "")
    }
    func apiCallToStopTrip(tripId:Int, completion: @escaping (Bool, String) -> Void) {
        Services.makeRequest(forStringUrl: ServiceAPI.api_tripStop.urlString() + "\(tripId)", method: .put, parameters: nil) { (response, error) in
            if (error != nil) {
                return completion(false, error ?? INTERNAL_SERVER_ERROR)
            } else if (response?.result.value as? [String : Any]) != nil {
                return completion(true, "")
            }
        }
    }
    func callWebServiceToGetGroupDetail(groupId:Int, completion: @escaping (Bool, String) -> Void) {
        Services.makeRequest(forStringUrl: ServiceAPI.api_group_Detail.urlString() + "/\(groupId)", method: .get, parameters: nil) { (response, error) in
            if (error != nil) {
                return completion(false, error ?? INTERNAL_SERVER_ERROR)
            } else if let responseJSON = response?.result.value as? [String : Any] {
                let responseDic: NSDictionary = responseJSON as NSDictionary
                print("response ->\(responseDic)")
                guard let data = response?.data else { return }
                do {
                    let groupData = try JSONDecoder().decode(GroupDetailBDM.self, from: data)
                    self.groupDetailData = groupData.data
                } catch let error {
                    print(error)
                }
                return completion(true, "")
            }
        }
    }
    func apiCallToEditGroupDetail(completion: @escaping (Bool, String) -> Void) {
        let requestParams = [
            "groupId": self.groupDetailData?.groupDetails.groupID ?? 0,
            "groupName": self.groupDetailData?.groupDetails.groupName ?? "",
            "image":  self.groupDetailData?.groupDetails.image ?? ""
            ] as [String:Any]
        
        Services.makeRequest(forStringUrl: ServiceAPI.api_group_edit.urlString(), method: .post, parameters: requestParams) { (response, error) in
            if response == nil && error == nil {
                return completion(false, INTERNAL_SERVER_ERROR)
            } else if (error != nil) {
                return completion(false, error ?? "")
            } else if let responseJSON = response?.result.value as? [String : Any] {
                let responseDic: NSDictionary = responseJSON as NSDictionary
                print("response ->\(responseDic)")
                guard let data = response?.data else { return completion(true, "")}
                
                return completion(true, "")
            }
        }
    }
    
    func apiCallToSuperviseTrip(tripId:Int, completion: @escaping (Bool, String) -> Void) {

        Services.makeRequest(forStringUrl: ServiceAPI.api_supervise_trip.urlString() + "\(tripId)", method: .put, parameters: nil) { (response, error) in
            if response == nil && error == nil {
                return completion(false, INTERNAL_SERVER_ERROR)
            } else if (error != nil) {
                return completion(false, error ?? "")
            } else if let responseJSON = response?.result.value as? [String : Any] {
                let responseDic: NSDictionary = responseJSON as NSDictionary
                print("response ->\(responseDic)")
                guard let data = response?.data else { return completion(true, "")}
                
                return completion(true, "")
            }
        }
    }
    func apiCallToWithdrawSupervisor(tripId:Int, completion: @escaping (Bool, String) -> Void) {
        Services.makeRequest(forStringUrl: ServiceAPI.api_withdrawSupervisor.urlString() + "\(tripId)", method: .delete, parameters: nil) { (response, error) in
            if response == nil && error == nil {
                return completion(false, INTERNAL_SERVER_ERROR)
            } else if (error != nil) {
                return completion(false, error ?? "")
            } else if let responseJSON = response?.result.value as? [String : Any] {
                let responseDic: NSDictionary = responseJSON as NSDictionary
                print("response ->\(responseDic)")
                guard let data = response?.data else { return completion(true, "")}
                
                return completion(true, "")
            }
        }
    }
}
