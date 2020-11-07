//
//  Services.swift
//  Sessions
//
//  Created by Bharat Kumar Pathak on 25/07/17.
//  Copyright © 2017 kipl. All rights reserved.
//

import Foundation
import Alamofire

// MARK:- Service Configuration



private struct ServiceConfig {
    static let localHost      = "http://18.237.16.9:1337"
    static let stagingHost    = "http://34.209.64.150:1337"
    static let liveHost       = "http://34.209.64.150:1337"
}
let imageBucket = "https://waddlemilton.s3-us-west-2.amazonaws.com/"

// MARK:- Service Environments

enum ServiceEnvironment: String {
    case development
    case staging
    case production
}

var host: String!
var port: String!

// MARK:- APIs

enum ServiceAPI {
    
    case api_login
    case api_signup
    case api_stop
    case api_save_student
    case api_reset_password
    case api_get_groups
    case api_groups_stop
    case api_groups_join
    case api_upload_media
    //    case api_get_student
    case api_save_parent
    case api_get_schedule
    case api_get_students
    case api_get_home_data
    case api_schedule_create
    case api_schedule_edit
    case api_schedule_delete
    case api_get_schedule_by_month
    case api_my_groups
    case api_group_Detail
    case api_group_edit
    
    case api_leave_group
    case api_supervise_trip
    case api_edit_student
    case api_delete_student
    case api_withdrawSupervisor
    case api_trip_history
    case api_tripMap
    
    case api_notifications
    case api_markNotificationAsRead
    
    case api_tripStart
    case api_tripStop
    
    case api_chat_list
    case api_message_list
    case api_terms
    case api_privacy
    case api_about
    case api_tips
    
    case api_send_otp
    case api_verify_otp
    case api_logout
    func urlString() -> String {
        
        let prefix_api                  = host+"/api"
        let prefix_parent               = prefix_api+"/parents"
        let prefix_common               = prefix_api+"/common"
        let prefix_group                = prefix_api+"/group"
        let prefix_schedule             = prefix_api+"/schedule"
        let prefix_studeent             = prefix_api+"/student"
        
        switch self {
            
        case .api_login:
            return prefix_parent + "/login"
        case .api_signup:
            return prefix_parent + "/register"
        case .api_stop:
            return prefix_common + "/stops"
        case .api_save_student:
            return prefix_api + "/students/add"
        case .api_reset_password:
            return prefix_parent + "/passwordReset"
        case .api_get_groups:
            return prefix_common + "/groups"
        case .api_groups_stop:
            return prefix_common + "/routeStops/"
        case .api_groups_join:
            return prefix_group + "/joinGroup/"
        case .api_save_parent:
            return prefix_parent + "/updateProfile/"
        case .api_upload_media:
            return prefix_common+"/uploadMedia"
        case .api_get_schedule:
            return prefix_api + "/schedule/"
        case .api_get_students:
            return prefix_api + "/students"
        case .api_get_home_data:
            return prefix_parent + "/homePage"
        case .api_schedule_create:
            return prefix_schedule + "/create"
        case .api_schedule_edit:
            return prefix_schedule + "/edit"
        case .api_schedule_delete:
            return prefix_schedule
        case .api_get_schedule_by_month:
            return prefix_schedule + "/byMonth/"
            
        case .api_my_groups:
            return prefix_api + "/groups"
        case .api_group_Detail:
            return prefix_api + "/groups/details"
        case .api_group_edit:
            return prefix_api + "/group/edit"
        case .api_leave_group:
            return prefix_group + "/leave/"
        case .api_supervise_trip:
            return prefix_group + "/superviseTrip/"
        case .api_edit_student:
            return prefix_studeent + "/edit/"
        case .api_delete_student:
            return prefix_api + "/students/"
        case .api_withdrawSupervisor:
            return prefix_group + "/withdrawSupervisor/"
        case .api_trip_history:
            return prefix_api + "/trips/history"
        case .api_tripMap:
            return prefix_group + "/tripMap/"
        case .api_tripStart:
            return prefix_api + "/trips/start/"
        case .api_tripStop:
            return prefix_api + "/trips/end/"
            
        case .api_notifications:
            return prefix_parent + "/notifications"
        case .api_markNotificationAsRead:
            return prefix_parent + "/markNotificationRead"
            
        case .api_chat_list:
            return prefix_api + "/messages/list"
        case .api_message_list:
            return prefix_api + "/messages/"
            
        case .api_terms:
            return host + "/admin/view/terms"
        case .api_privacy:
            return host + "/admin/view/privacy"
        case .api_about:
            return host + "/pdfs/About%20us.pdf"
        case .api_tips:
            return host + "/pdfs/Tips.pdf"
            
        case .api_send_otp:
            return prefix_parent + "/sendOTP"
        case .api_verify_otp:
            return prefix_parent + "/verifyOTP"
        case .api_logout:
            return prefix_parent + "/logout"
            
        }
    }
}

// MARK:-
class MultipartFile {
    var fileData: Data?
    var fileKey: String = "file"
    var fileName: String = "image.jpg"
    var fileMime: String = "image/jpg"
}

// MARK:-

class Services {
    
    typealias CompletionHandler = (_ response:DataResponse<Any>?, _ error:String?) -> ()
    
    static func initWebServicesEnvironment(_ environment: ServiceEnvironment) {
        
        let environment: ServiceEnvironment = environment
        
        switch environment as ServiceEnvironment {
        case .development:
            host = ServiceConfig.localHost
            break
        case .staging:
            host = ServiceConfig.stagingHost
            break
        case .production:
            host = ServiceConfig.liveHost
            break
        }
    }
}


// MARK:-

extension Services {
    
    class func makeRequest(forStringUrl urlString:String, method: HTTPMethod, parameters: [String:Any]?, completionHandler:CompletionHandler?) {
        
        
        let apiHeaders = getApiHeaders()
        print("--------------------------------------------------------------------")
        print("request url      :: \(urlString)")
        print("request headers  :: \(apiHeaders)")
        print("request params   :: \(String(describing: parameters))")
        print("--------------------------------------------------------------------")
        
        Alamofire.request(urlString, method: method, parameters: parameters, encoding: JSONEncoding.default, headers: apiHeaders)
            .responseJSON {(response:DataResponse<Any>) in
                
                if response.response?.allHeaderFields["force_update"] as? String == "1" {
                    print("force update")
                    showUpdateAlert()
                    return
                }
                
                print(response.result.value as Any)
                
                switch(response.result) {
                case .success(_):
                    let responseData = response.result.value as? [String : Any]
                    if let _ = responseData?["data"] {
                        completionHandler!(response, nil)
                    } else if let status = responseData?["status"] as? String, status == "OK"{
                        completionHandler!(response, nil) // Google map API
                    } else {
                        completionHandler!(nil, responseData?["message"] as? String ?? INTERNAL_SERVER_ERROR)
                    }
                case .failure(_):
                    let data = response.result.value as? [String : Any]
                    completionHandler!(nil, data?["message"] as? String ?? INTERNAL_SERVER_ERROR)
                    break
                }
        }
    }
    
    class func makeMultipartRequest(forStringUrl urlString:String, method: HTTPMethod, file: MultipartFile, otherParameters: [String:Any]?, completionHandler:CompletionHandler?) {
        
        Alamofire.upload(multipartFormData: { (multipartFormData) in
            
            multipartFormData.append(file.fileData!, withName: file.fileKey, fileName: file.fileName, mimeType: file.fileMime)
            if let _otherParams = otherParameters {
                for (key, value) in _otherParams {
                    multipartFormData.append((value as AnyObject).data(using: String.Encoding.utf8.rawValue)!, withName: key)
                }
            }
            
        }, to: urlString, method: .post, headers: getApiHeaders()) { (encodingResult) in
            
            switch encodingResult {
            case .success(let upload, _, _):
                upload.responseJSON { response in
                    let responseData = response.result.value as? [String : Any]
                    print(responseData as Any)
                    if let _ = responseData?["data"] {
                        completionHandler!(response, nil)
                    } else {
                        completionHandler!(nil, responseData?["message"] as? String ?? INTERNAL_SERVER_ERROR)
                    }
                }
            case .failure(let encodingError):
                print(encodingError)
                completionHandler!(nil, encodingError.localizedDescription )
            }
        }
    }
    
    class func getApiHeaders() -> HTTPHeaders {
        
        var headers: HTTPHeaders = [
            "Content-Type":"application/json"
        ]
        if let token = CommonFunctions.getUserDefaultFor(key: AUTHTOKEN) as? String {
            headers["authtoken"] = token
        }
        
        return headers
    }
}

extension Services {
    
    class func showUpdateAlert() {
        //        CommonFunctions.hideHUD(controller: (APP_DELEGATE.window?.rootViewController)!)
        //        let updateAlert = UIAlertController(title: "New version available for \(APP_NAME)", message: "A newer version of the application is available, please update to continue further.", preferredStyle: UIAlertController.Style.alert)
        //
        //        updateAlert.addAction(UIAlertAction(title: "Update", style: .default, handler: { action in
        //            //"http://itunes.apple.com/app/id1375232479"
        //            UIApplication.shared.open(NSURL(string:"https://itunes.apple.com/us/app/apple-store/id1375232479?mt=8")! as URL, options: [:], completionHandler: nil)
        //        }))
        //        APP_DELEGATE.window?.rootViewController?.present(updateAlert, animated: true, completion: nil)
    }
    
    class func handleUnAuthorisedUserWith(message: String) {
        //        CommonFunctions.hideHUD(controller: (SceneDelegate.shared?.window?.rootViewController)!)
        //        CommonFunctions.showAlertWithTitle(title: "", message: message, onViewController: APP_DELEGATE.window?.rootViewController, withButtonArray: nil, dismissHandler: { (buttonIndex) in
        //            
        //        })
    }
}
