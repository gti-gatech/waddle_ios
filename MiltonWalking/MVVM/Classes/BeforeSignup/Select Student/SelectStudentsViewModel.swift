//
//  SelectStudentsViewModel.swift
//  MiltonWalking
//
//  Created by Krishna Datt Shukla on 07/07/20.
//  Copyright © 2020 Appzoro. All rights reserved.
//

import Foundation

class SelectStudentsViewModel {
    
    private var arrStudent = [StudentDM]()
        
    var studentsCount: Int {
        return arrStudent.count
    }
    func updateArrStudents(arrayStudents:[StudentDM]) {
        self.arrStudent = arrayStudents
    }
    func student(at index: Int) -> StudentDM? {
        if arrStudent.count > index {
            return arrStudent[index]
        }
        return nil
    }
    
    
    func getStudents(completion: @escaping (Bool, String) -> Void) {
        Services.makeRequest(forStringUrl: ServiceAPI.api_get_students.urlString(), method: .get, parameters: nil) { (response, error) in
            if response == nil && error == nil {
                return completion(false, INTERNAL_SERVER_ERROR)
            } else if (error != nil) {
                return completion(false, error ?? "")
            } else if let responseJSON = response?.result.value as? [String : Any] {
                let responseDic: NSDictionary = responseJSON as NSDictionary
                print("response ->\(responseDic)")
                guard let data = response?.data else { return completion(true, "")}
                do {
                    let studentData = try JSONDecoder().decode(StudentBDM.self, from: data)
                    self.arrStudent = studentData.data
                } catch let error {
                    self.arrStudent = []
                    print(error)
                }
                return completion(true, "")
            }
        }
    }
    func apiCallForGroupeJoin(groupId:String, stopId:String,students:[Int], completion: @escaping (Bool, String) -> Void) {
        let requestParams = [
        "groupId": groupId,
        "stopId": stopId,
        "students": students,
        ] as [String:Any]
        Services.makeRequest(forStringUrl: ServiceAPI.api_groups_join.urlString(), method: .post, parameters: requestParams) { (response, error) in
            if (error != nil) {
                return completion(false, error ?? INTERNAL_SERVER_ERROR)
            } else if let responseJSON = response?.result.value as? [String : Any] {
                let responseDic: NSDictionary = responseJSON as NSDictionary
                print("response ->\(responseDic)")
                guard let data = response?.data else { return completion(true, "")}
                return completion(true, "")
            }
        }
    }
}
