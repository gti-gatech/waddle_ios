//
//  CreateScheduleVM.swift
//  MiltonWalking
//
//  Created by Jitendra Singh on 20/07/20.
//  Copyright © 2020 Appzoro. All rights reserved.
//

import UIKit

class CreateScheduleVM {
    private var arrStudentID = [Int]()
    private var groupId = ""
    private var stopId = ""
    private var isSupervisor = false
    private var selectedDate = ""
    private var isRepetition = false
    private var repetitionCount = 0
    var repeatDay = ""
    private var scheduleData:CreateScheduleFieldData = CreateScheduleFieldData(arrRepeateOnTitle: ["Mon","Tue","Wed","Thu","Fri",], arrRepeateOnSelected: [false, false, false, false, false])
    var scheduleResponse:CreateScheduleDM?
    
    func getRepeateOnat(index:Int) -> (String,Bool) {
        return (self.scheduleData.arrRepeateOnTitle[index],self.scheduleData.arrRepeateOnSelected[index])
    }
    func updateRepeatFrequency(index:Int) {
        self.repetitionCount = index
        switch index {
        case 0:
            isRepetition = false
        default:
            isRepetition = true
        }
    }
    func checkIfRepetaionDayRequiredIFNotSecected() -> Bool {
        if self.repetitionCount > 0 &&  !self.scheduleData.arrRepeateOnSelected.contains(true){
            return true
        }
        return false
    }
    func updateRepeateOnat(index:Int)  {
        self.scheduleData.arrRepeateOnSelected = self.scheduleData.arrRepeateOnSelected.enumerated().map({ (offSet, _) -> Bool in
            if index == offSet{
                switch offSet {
                case 0:
                    self.repeatDay = "Monday"
                case 1:
                    self.repeatDay = "Tuesday"
                case 2:
                    self.repeatDay = "Wednesday"
                case 3:
                    self.repeatDay = "Wednesday"
                default:
                    self.repeatDay = "Friday"
                }
                return true
            }
            return false
        })
    }
    func updateStudnedtIds(arrStudentID:[Int], groupId:String,stopId:String, isSupervisor:Bool, selectedDate:String ) {
        self.arrStudentID = arrStudentID
        self.groupId = groupId
        self.stopId = stopId
        self.isSupervisor = isSupervisor
        self.selectedDate = selectedDate
    }
    func callWebServiceToCreateSchedule(completion: @escaping (Bool, String) -> Void) {
        let requestParams = [
            "groupId":self.groupId,
            "stopId":self.stopId,
            "students":self.arrStudentID,
            "repetition":self.isRepetition,
            "repetitionCount":self.repetitionCount,
            "repeatDay":self.repeatDay,
            "selectedDate":self.selectedDate,
            "isSupervisor":self.isSupervisor
            ] as [String:Any]
        Services.makeRequest(forStringUrl: ServiceAPI.api_schedule_create.urlString(), method: .post, parameters: requestParams) { (response, error) in
            if (error != nil) {
                return completion(false, error ?? INTERNAL_SERVER_ERROR)
            } else if (response?.result.value as? [String : Any]) != nil {
                guard let data = response?.data else { return }
                do {
                    self.scheduleResponse = try JSONDecoder().decode(CreateScheduleDM.self, from: data)
                } catch let error {
                    print(error)
                }
                return completion(true, "")
            }
        }
    }
}
