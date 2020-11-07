//
//  OTPViewModel.swift
//  MiltonWalking
//
//  Created by Jitendra Singh on 21/08/20.
//  Copyright © 2020 Appzoro. All rights reserved.
//

import UIKit

class OTPViewModel {
    private var strOTP = ""
    func apiCallToSendOtp(strEmail:String,completion: @escaping (Bool, String) -> Void) {
        let requestParams = [
        "email": strEmail
        ] as [String:Any]
        Services.makeRequest(forStringUrl: ServiceAPI.api_send_otp.urlString(), method: .post, parameters: requestParams) { (response, error) in
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
    func apiCallToVarifyOtp(strEmail:String,strOTP:String, completion: @escaping (Bool, String) -> Void) {
        let requestParams = [
        "email": strEmail,
        "otp": strOTP
        ] as [String:Any]
        Services.makeRequest(forStringUrl: ServiceAPI.api_verify_otp.urlString(), method: .post, parameters: requestParams) { (response, error) in
            if (error != nil) {
                if error == "OTP verification has been successfully processed."{
                    return completion(true, "")
                }
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
