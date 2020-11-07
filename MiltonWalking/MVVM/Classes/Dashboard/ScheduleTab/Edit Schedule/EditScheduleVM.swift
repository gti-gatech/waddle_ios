//
//  CreateScheduleVM.swift
//  MiltonWalking
//
//  Created by Jitendra Singh on 20/07/20.
//  Copyright © 2020 Appzoro. All rights reserved.
//

import UIKit

class EditScheduleVM {
    
    private var tripId = 0
    private var oldSelectedDate = ""
    private var newSelectedDate = ""
    private var isDateChanged = false
    private var stopId = 0
    private var isSupervisor = false
    private var studentID = 0




    func updateData(studentID:Int, oldSelectedDate:String,stopId:Int, isSupervisor:Bool, tripId:Int) {
        self.studentID = studentID
        self.oldSelectedDate = oldSelectedDate
        self.stopId = stopId
        self.isSupervisor = isSupervisor
        self.tripId = tripId
    }
    func updateDataStr(date:Date) {
        self.newSelectedDate = date.getFormattedDate(format: "yyyy-MM-dd")
        self.isDateChanged = !(self.newSelectedDate == self.oldSelectedDate)
    }
    func updateStopData(data:SelectStopMapDM?) {
        self.stopId = data?.stopID ?? 0 
    }
    func callWebServiceToEditSchedule(completion: @escaping (Bool, String) -> Void) {
        let requestParams = [
            "tripId":self.tripId,
            "newDate":self.newSelectedDate,
            "isDateChanged":isDateChanged,
            "stopId":stopId,
            "isSupervisor":isSupervisor,
            "studentId":studentID
            ] as [String:Any]
        Services.makeRequest(forStringUrl: ServiceAPI.api_schedule_edit.urlString(), method: .post, parameters: requestParams) { (response, error) in
            if (error != nil) {
                return completion(false, error ?? INTERNAL_SERVER_ERROR)
            } else if let responseJSON = response?.result.value as? [String : Any] {
                let responseDic: NSDictionary = responseJSON as NSDictionary
                print("response ->\(responseDic)")
                return completion(true, "")
            }
        }
    }
}
