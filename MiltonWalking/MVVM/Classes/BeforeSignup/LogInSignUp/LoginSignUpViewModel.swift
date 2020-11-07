//
//  LoginSignUpViewModel.swift
//  MiltonWalking
//
//  Created by Krishna Datt Shukla on 01/07/20.
//  Copyright © 2020 Appzoro. All rights reserved.
//

import Foundation

class LoginSignUpViewModel {
    private var arrayLoginFields: [InputField] = [InputField]()
    private var arraySignUpFields: [InputField] = [InputField]()
    
    var selectedImageName: String?

    //Login
    var loginFieldsCount: Int {
        return arrayLoginFields.count
    }

    var signupFieldsCount: Int {
        return arraySignUpFields.count
    }
    
    func loginField(at index: Int) -> InputField? {
        if index < arrayLoginFields.count {
            return arrayLoginFields[index]
        }
        return nil
    }
    
    func signupField(at index: Int) -> InputField? {
        if index < arraySignUpFields.count {
            return arraySignUpFields[index]
        }
        return nil
    }
    
    func setupDataSource(completion: @escaping (() -> Void)) {
        let email = InputField(key: InputFieldKey.email.rawValue, value: "", keyboardType: .emailAddress, placeholder: InputFieldPlaceholder.email.rawValue, icon: #imageLiteral(resourceName: "email"))
        let password = InputField(key: InputFieldKey.password.rawValue, value: "", keyboardType: .default, placeholder: InputFieldPlaceholder.password.rawValue, icon: #imageLiteral(resourceName: "password"))
        arrayLoginFields = [email, password]
        
        //Signup
        let name = InputField(key: InputFieldKey.name.rawValue, value: "", keyboardType: .namePhonePad, placeholder: InputFieldPlaceholder.name.rawValue, icon: #imageLiteral(resourceName: "user"))
        let confirmPassword = InputField(key: InputFieldKey.confirmPassword.rawValue, value: "", keyboardType: .default, placeholder: InputFieldPlaceholder.confirmPassword.rawValue, icon: #imageLiteral(resourceName: "password"))
        let phone = InputField(key: InputFieldKey.phone.rawValue, value: "", keyboardType: .phonePad, placeholder: InputFieldPlaceholder.phone.rawValue, icon: #imageLiteral(resourceName: "phone"))
        let address = InputField(key: InputFieldKey.address.rawValue, value: "", keyboardType: .default, placeholder: InputFieldPlaceholder.address.rawValue, icon: #imageLiteral(resourceName: "address"))
        let stop = InputField(key: InputFieldKey.stop.rawValue, value: "", keyboardType: .default, placeholder: InputFieldPlaceholder.stop.rawValue, icon: #imageLiteral(resourceName: "default_stop"))
        
        arraySignUpFields = [name, email, password, confirmPassword, phone, address, stop]
        completion()
    }
    
    func updateLoginField(at index: Int, value: String) {
        var input = arrayLoginFields[index]
        input.value = value
        arrayLoginFields[index] = input
    }
    
    func updateSignUpField(at index: Int, value: String) {
        var input = arraySignUpFields[index]
        input.value = value
        arraySignUpFields[index] = input
    }
    
    func updateStopField(at value: SelectStopMapDM) {
        var input = arraySignUpFields[6]
        input.value = value
        arraySignUpFields[6] = input
    }
    
    func validateLoginFields(completion: @escaping ((Bool, String?) -> Void)) {
        guard let email = arrayLoginFields[0].value as? String, !email.isEmpty else {
            return completion(false, ValidationError.emailBlank.rawValue)
        }
        
        if !Validation.validateEmail(email) {
            return completion(false, ValidationError.emailInvalid.rawValue)
        }
        
        guard let password = arrayLoginFields[1].value as? String, !password.isEmpty else {
           return completion(false, ValidationError.passwordBlankLogin.rawValue)
        }
        
        if !Validation.validatePassword(password) {
            return completion(false, ValidationError.passwordInvalid.rawValue)
        }
        
        return completion(true, "")
    }
    
    func validateSignUpFields(completion: @escaping ((Bool, String?) -> Void) ) {
        
        guard let name = arraySignUpFields[0].value as? String, !name.isEmpty else {
            return completion(false, ValidationError.nameBlank.rawValue)
        }

        guard let email = arraySignUpFields[1].value as? String, !email.isEmpty else {
           return completion(false, ValidationError.emailBlank.rawValue)
        }
        
        if !Validation.validateEmail(email) {
            return completion(false, ValidationError.emailInvalid.rawValue)
        }
        
        guard let password = arraySignUpFields[2].value as? String, !password.isEmpty else {
           return completion(false, ValidationError.passwordBlank.rawValue)
        }
        
        if !Validation.validatePassword(password) {
            return completion(false, ValidationError.passwordInvalid.rawValue)
        }
        
        guard let cPassword = arraySignUpFields[3].value as? String, !cPassword.isEmpty else {
           return completion(false, ValidationError.confirmPasswordBlank.rawValue)
        }
        
        if password != cPassword {
            return completion(false, ValidationError.passwordNotMatched.rawValue)
        }
        
        guard let phone = arraySignUpFields[4].value as? String, !phone.isEmpty else {
           return completion(false, ValidationError.phoneBlank.rawValue)
        }
        
        if !phone.isValidPhone {
            return completion(false, ValidationError.phoneInvalid.rawValue)
        }
        
        guard let address = arraySignUpFields[5].value as? String, !address.isEmpty else {
           return completion(false, ValidationError.addressBlank.rawValue)
        }
        
        guard arraySignUpFields[6].value is SelectStopMapDM else {
           return completion(false, ValidationError.stopBlank.rawValue)
        }
        
        return completion(true, "")
    }
    func getStrEmail() -> String {
        return arraySignUpFields[1].value as? String ?? ""
    }
    func apiCallForSignUp(completion: @escaping (Bool, String) -> Void) {
        let requestParams = [
            "email": arraySignUpFields[1].value as? String ?? "",
            "fullName": arraySignUpFields[0].value as? String ?? "",
            "password": arraySignUpFields[2].value as? String ?? "",
            "contact": arraySignUpFields[4].value as? String ?? "",
            "stopId": (arraySignUpFields[6].value as? SelectStopMapDM)?.stopID ?? 0,
            "deviceToken": AppDelegate.sharedInstance.apnsToken,
            "image": self.selectedImageName ?? "",
            "address": arraySignUpFields[5].value as? String ?? ""
            ] as [String:Any]
        
        Services.makeRequest(forStringUrl: ServiceAPI.api_signup.urlString(), method: .post, parameters: requestParams) { (response, error) in
            if (error != nil) {
                return completion(false, error ?? INTERNAL_SERVER_ERROR)
            } else if let responseJSON = response?.result.value as? [String : Any] {
                let responseDic: NSDictionary = responseJSON as NSDictionary
                guard let data = response?.data else { return completion(true, "")}
                do {
                    let userData = try JSONDecoder().decode(UserBaseDM.self, from: data)
                    CommonFunctions.saveUserDetailInUserDefault(data:userData.data)
                } catch let error {
                    print(error)
                }
                if let authToken = ((responseDic["data"] as? [String : Any])?["auth"] as? [String : Any])?["authToken"] as? String{
                    CommonFunctions.setUserDefaultFor(key: AUTHTOKEN, value: authToken)
                }
                
                return completion(true, responseDic["message"] as? String ?? "")
            }
        }
    }
    
    func apiCallForLogin(completion: @escaping (Bool, Bool, String) -> Void) {
        let requestParams = [
            "email": arrayLoginFields[0].value as? String ?? "",
            "password": arrayLoginFields[1].value as? String ?? "",
            "deviceToken": AppDelegate.sharedInstance.apnsToken
        ] as [String:Any]
        
        Services.makeRequest(forStringUrl: ServiceAPI.api_login.urlString(), method: .post, parameters: requestParams) { (response, error) in
            if (error != nil) {
                return completion(false, false, error ?? INTERNAL_SERVER_ERROR)
            } else if let responseJSON = response?.result.value as? [String : Any] {
                let responseDic: NSDictionary = responseJSON as NSDictionary
                if let authToken = ((responseDic["data"] as? [String : Any])?["auth"] as? [String : Any])?["authToken"] as? String{
                    CommonFunctions.setUserDefaultFor(key: AUTHTOKEN, value: authToken)
                }
                guard let data = response?.data else { return completion(true, false, "")}
                do {
                    let userData = try JSONDecoder().decode(UserBaseDM.self, from: data)
                    CommonFunctions.saveUserDetailInUserDefault(data:userData.data)
                    return completion(true, userData.data.parentData.isFirstTime.boolValue, responseDic["message"] as? String ?? "")
                } catch let error {
                    print(error)
                }
                return completion(true, false, responseDic["message"] as? String ?? "")
            }
        }
    }
    
    
}
