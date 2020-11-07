//
//  AddStudentDetailVM.swift
//  MiltonWalking
//
//  Created by Jitendra Singh on 06/07/20.
//  Copyright © 2020 Appzoro. All rights reserved.
//

import UIKit

class AddStudentDetailVM: NSObject {
    private var arrStudentDetailFields: [StudentDetailField] = [StudentDetailField]()
    private var arrStudent = [StudentDM]()
    func setupDataSource(completion: @escaping (() -> Void)) {
        let name = StudentDetailField(value: "", title: StudentDetailPlaceholder.name.rawValue, keyboardType: .default, placeholder: StudentDetailPlaceholder.name.rawValue)
        let email = StudentDetailField(value: "", title: StudentDetailPlaceholder.email.rawValue, keyboardType: .emailAddress, placeholder: StudentDetailPlaceholder.email.rawValue)
        let schoolName = StudentDetailField(value: "", title: StudentDetailPlaceholder.schoolName.rawValue, keyboardType: .default, placeholder: StudentDetailPlaceholder.schoolName.rawValue)
        let studentgrade = StudentDetailField(value: "", title: StudentDetailPlaceholder.studentgrade.rawValue, keyboardType: .default, placeholder: StudentDetailPlaceholder.studentgrade.rawValue)
        arrStudentDetailFields = [name,email ,schoolName, studentgrade]
        completion()
    }
    
    func setupStudentData(_ student: Student, completion: @escaping (() -> Void)) {
        let name = StudentDetailField(value: student.fullName ?? "", title: StudentDetailPlaceholder.name.rawValue, keyboardType: .default, placeholder: StudentDetailPlaceholder.name.rawValue)
        let email = StudentDetailField(value: student.email ?? "", title: StudentDetailPlaceholder.email.rawValue, keyboardType: .emailAddress, placeholder: StudentDetailPlaceholder.email.rawValue)
        let schoolName = StudentDetailField(value: student.schoolName ?? "", title: StudentDetailPlaceholder.schoolName.rawValue, keyboardType: .default, placeholder: StudentDetailPlaceholder.schoolName.rawValue)
        let studentgrade = StudentDetailField(value: student.grade ?? "", title: StudentDetailPlaceholder.studentgrade.rawValue, keyboardType: .default, placeholder: StudentDetailPlaceholder.studentgrade.rawValue)
        arrStudentDetailFields = [name,email ,schoolName, studentgrade]
        completion()
    }
    
    func getStudentDataForFieldAt(index:Int) -> StudentDetailField? {
        guard let data = self.arrStudentDetailFields[safe:index] else { return nil }
        return data
    }
    func getArrStudents() -> [StudentDM] {
        return self.arrStudent
    }
    func validateTextFields(completion: @escaping ((Bool, String?) -> Void)) {
        guard let name = arrStudentDetailFields[0].value as? String, !name.isEmpty else {
            return completion(false, "Please enter student’s name.")
        }
        guard let email = arrStudentDetailFields[1].value as? String, !email.isEmpty else {
            return completion(false, "Please enter student's email.")
        }
        guard let schoolName = arrStudentDetailFields[2].value as? String, !schoolName.isEmpty else {
            return completion(false, "Please enter the name of your student's school.")
        }
        guard let schoolGrade = arrStudentDetailFields[3].value as? String, !schoolGrade.isEmpty else {
            return completion(false, "Please enter your student's grade.")
        }
        if !Validation.validateEmail(email) {
            return completion(false, "Please enter valid email")
        }
        return completion(true, "")
    }
    func updateTextField(at index: Int, value: String) {
        var input = arrStudentDetailFields[index]
        input.value = value
        arrStudentDetailFields[index] = input
    }
    func apiCallForSaveStudentData(completion: @escaping (Bool, String) -> Void) {
        let requestParams = [
            "email": arrStudentDetailFields[1].value as? String ?? "",
            "fullName": arrStudentDetailFields[0].value as? String ?? "",
            "schoolName": arrStudentDetailFields[2].value as? String ?? "",
            "image":  "",
            "grade": arrStudentDetailFields[3].value as? String ?? "",
            ] as [String:Any]
        
        Services.makeRequest(forStringUrl: ServiceAPI.api_save_student.urlString(), method: .post, parameters: requestParams) { (response, error) in
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
    
    func apiCallForUpdateStudentData(_ studentId: Int, completion: @escaping (Bool, String) -> Void) {
        let requestParams = [
            "email": arrStudentDetailFields[1].value as? String ?? "",
            "fullName": arrStudentDetailFields[0].value as? String ?? "",
            "schoolName": arrStudentDetailFields[2].value as? String ?? "",
            "image":  "",
            "grade": arrStudentDetailFields[3].value as? String ?? "",
            ] as [String:Any]
        
        Services.makeRequest(forStringUrl: ServiceAPI.api_edit_student.urlString() + "\(studentId)", method: .post, parameters: requestParams) { (response, error) in
            if response == nil && error == nil {
                return completion(false, INTERNAL_SERVER_ERROR)
            } else if (error != nil) {
                return completion(false, error ?? "")
            } else if (response?.result.value as? [String : Any]) != nil {
                return completion(true, "")
            }
        }
    }
    
    func apiCallForDeleteStudentData(_ studentId: Int, completion: @escaping (Bool, String) -> Void) {
        
        Services.makeRequest(forStringUrl: ServiceAPI.api_delete_student.urlString() + "\(studentId)", method: .delete, parameters: nil) { (response, error) in
            if response == nil && error == nil {
                return completion(false, INTERNAL_SERVER_ERROR)
            } else if (error != nil) {
                return completion(false, error ?? "")
            } else if (response?.result.value as? [String : Any]) != nil {
                return completion(true, "")
            }
        }
    }
}
