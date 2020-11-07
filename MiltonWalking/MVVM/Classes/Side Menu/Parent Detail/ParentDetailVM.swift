//
//  ParentDetailVM.swift
//  MiltonWalking
//
//  Created by Jitendra Singh on 14/07/20.
//  Copyright © 2020 Appzoro. All rights reserved.
//

import UIKit

class ParentDetailVM {
    private var arrParentDetailFields: [ParentDetailField] = [ParentDetailField]()
    var selectedImageName: String?
    func setupDataSource(completion: @escaping ((_ imgStr:String) -> Void)) {
        guard let userData = CommonFunctions.getUserDetailFromUserDefault() else { return  }
        self.selectedImageName = userData.parentData.image
        let stopData = SelectStopMapDM.init(stopID: userData.parentData.stopID, routeID: 0, name: userData.parentData.stopName ?? "", createdOn: "", location: [:], groupName: nil)
        let name = ParentDetailField(value: userData.parentData.fullName, title: ParentDetailTitle.name.rawValue, keyboardType: .default)
        let email = ParentDetailField(value: userData.parentData.email, title: ParentDetailTitle.email.rawValue, keyboardType: .emailAddress)
        let phoneNumber = ParentDetailField(value: userData.parentData.contact, title: ParentDetailTitle.phoneNumber.rawValue, keyboardType: .default)
        let address = ParentDetailField(value: userData.parentData.address, title: ParentDetailTitle.address.rawValue, keyboardType: .default)
        let selectStop = ParentDetailField(value: stopData, title: ParentDetailTitle.defaultStop.rawValue, keyboardType: .default)
        arrParentDetailFields = [name,email ,phoneNumber, address,selectStop]
        let strImage = imageBucket + userData.parentData.image
        completion(strImage)
    }
    func getParentDataForFieldAt(index:Int) -> ParentDetailField? {
        guard let data = self.arrParentDetailFields[safe:index] else { return nil }
        return data
    }
    
    func validateTextFields(completion: @escaping ((Bool, String?) -> Void)) {
        guard let name = arrParentDetailFields[0].value as? String, !name.isEmpty else {
            return completion(false, "Please enter your full name.")
        }
        guard let phoneNumber = arrParentDetailFields[2].value as? String, !phoneNumber.isEmpty else {
            return completion(false, "Please enter your phone number.")
        }
        
        if !phoneNumber.isValidPhone {
            return completion(false, ValidationError.phoneInvalid.rawValue)
        }
        
        guard let address = arrParentDetailFields[3].value as? String, !address.isEmpty else {
            return completion(false, "Please enter your address.")
        }
        guard let selectStop = (arrParentDetailFields[4].value as? SelectStopMapDM)?.name, !selectStop.isEmpty else {
            return completion(false, "Please select a default stop.")
        }
        return completion(true, "")
    }
    func updateTextField(at index: Int, value: String) {
        var input = self.arrParentDetailFields[index]
        input.value = value
        arrParentDetailFields[index] = input
    }
    func updateStopField(at value: SelectStopMapDM) {
        var input = self.arrParentDetailFields[4]
        input.value = value
        arrParentDetailFields[4] = input
    }
    func apiCallForSaveParentData(completion: @escaping (Bool, String) -> Void) {
        let requestParams = [
            "fullName": arrParentDetailFields[0].value as? String ?? "",
            "contact": arrParentDetailFields[2].value as? String ?? "",
            "stopId": (arrParentDetailFields[4].value as? SelectStopMapDM)?.stopID ?? "",
            "image":  self.selectedImageName ?? "",
            "address": arrParentDetailFields[3].value as? String ?? "",
            ] as [String:Any]
        
        Services.makeRequest(forStringUrl: ServiceAPI.api_save_parent.urlString(), method: .post, parameters: requestParams) { (response, error) in
            if response == nil && error == nil {
                return completion(false, INTERNAL_SERVER_ERROR)
            } else if (error != nil) {
                return completion(false, error ?? "")
            } else if let responseJSON = response?.result.value as? [String : Any] {
                let responseDic: NSDictionary = responseJSON as NSDictionary
                guard let data = response?.data else { return completion(true, "")}
                do {
                    let userData = try JSONDecoder().decode(UserBaseDM.self, from: data)
                    CommonFunctions.saveUserDetailInUserDefault(data:userData.data)
                    print("data ->\(CommonFunctions.getUserDetailFromUserDefault())")
                } catch let error {
                    print(error)
                }
                print("response ->\(responseDic)")
                return completion(true, "")
            }
        }
    }
}
