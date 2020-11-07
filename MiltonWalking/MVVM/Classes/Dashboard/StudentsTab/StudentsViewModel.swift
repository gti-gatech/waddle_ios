//
//  StudentsViewModel.swift
//  MiltonWalking
//
//  Created by Krishna Datt Shukla on 21/07/20.
//  Copyright © 2020 Appzoro. All rights reserved.
//

import Foundation

class StudentsViewModel {
    
    private var arrayStudents: [Student] = [Student]()
    private var response: StudentsResponse?
    
    var studentsCount: Int {
        return arrayStudents.count
    }
    
    func getStudent(at index: Int) -> Student? {
        if arrayStudents.count > index {
            return arrayStudents[index]
        }
        return nil
    }

    func getStudents(completion: @escaping (Bool, String) -> Void) {
        let url = ServiceAPI.api_get_students.urlString()
        Services.makeRequest(forStringUrl: url, method: .get, parameters: nil) { (response, error) in
            if (error != nil) {
                return completion(false, error ?? INTERNAL_SERVER_ERROR)
            } else if let responseJSON = response?.result.value as? [String : Any] {
                let responseDic: NSDictionary = responseJSON as NSDictionary
                print("response ->\(responseDic)")
                guard let data = response?.data else { return }
                do {
                    let data = try JSONDecoder().decode(StudentsResponse.self, from: data)
                    self.arrayStudents = data.data
                } catch let error {
                    print(error)
                }
                return completion(true, "")
            }
        }
    }
}
