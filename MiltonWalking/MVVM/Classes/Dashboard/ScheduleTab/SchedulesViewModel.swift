//
//  SchedulesViewModel.swift
//  MiltonWalking
//
//  Created by Krishna Datt Shukla on 20/07/20.
//  Copyright © 2020 Appzoro. All rights reserved.
//

import Foundation

class SchedulesViewModel {
    
    private var arraySchedule: [Schedule] = [Schedule]()
    private var response: ScheduleResponse?
    var monthResponse: ScheduleResponse?

    var scheduleCount: Int {
        return arraySchedule.count
    }
    
    func getSchedule(at index: Int) -> Schedule? {
        if arraySchedule.count > index {
            return arraySchedule[index]
        }
        return nil
    }

    func getScheduleFor(date: String, isSupervisor: Bool, completion: @escaping (Bool, String) -> Void) {
        let url = "\(ServiceAPI.api_get_schedule.urlString())\(date)/\(isSupervisor)"
        Services.makeRequest(forStringUrl: url, method: .get, parameters: nil) { (response, error) in
            if (error != nil) {
                return completion(false, error ?? INTERNAL_SERVER_ERROR)
            } else if (response?.result.value as? [String : Any]) != nil {
                guard let data = response?.data else { return }
                do {
                    let data = try JSONDecoder().decode(ScheduleResponse.self, from: data)
                    self.arraySchedule = data.data
                } catch let error {
                    print(error)
                }
                return completion(true, "")
            }
        }
    }
    
    func getScheduleFor(month: String, year: String, isSupervisor: Bool, completion: @escaping (Bool, String) -> Void) {
        let url = "\(ServiceAPI.api_get_schedule_by_month.urlString())\(month)/\(year)/\(isSupervisor)"
        Services.makeRequest(forStringUrl: url, method: .get, parameters: nil) { (response, error) in
            if (error != nil) {
                return completion(false, error ?? INTERNAL_SERVER_ERROR)
            } else if (response?.result.value as? [String : Any]) != nil {
                guard let data = response?.data else { return }
                do {
                    self.monthResponse = try JSONDecoder().decode(ScheduleResponse.self, from: data)
                } catch let error {
                    print(error)
                }
                return completion(true, "")
            }
        }
    }
    
    func callWebServiceToDeleteSchedule(tripId: Int, studentId: Int, isSupervisor: Bool, completion: @escaping (Bool, String) -> Void) {
        let requestParams = [
        "tripId":tripId,
        "studentId":studentId,
        "isSupervisor":isSupervisor
        ] as [String:Any]
        Services.makeRequest(forStringUrl: ServiceAPI.api_schedule_delete.urlString(), method: .delete, parameters: requestParams) { (response, error) in
            if (error != nil) {
                return completion(false, error ?? INTERNAL_SERVER_ERROR)
            } else if (response?.result.value as? [String : Any]) != nil {
                guard let data = response?.data else { return }
                return completion(true, "")
            }
        }
    }
}
