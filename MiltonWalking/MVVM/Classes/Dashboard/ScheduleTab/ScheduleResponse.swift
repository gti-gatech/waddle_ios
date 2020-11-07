//
//  ScheduleResponse.swift
//  MiltonWalking
//
//  Created by Krishna Datt Shukla on 20/07/20.
//  Copyright © 2020 Appzoro. All rights reserved.
//

import Foundation

struct ScheduleResponse: Codable {
    let type, message: String
    let data: [Schedule]
}

struct Schedule: Codable {
    let displayTime :String?
    let dueOn :String?
    let groupId :Int?
    let groupName :String?
    let isSupervised :Int?
    let status :String?
    let stopId :Int?
    let studentId :Int?
    let studentName :String?
    let supervisorId :String?
    let supervisorName :String?
    let tripId :Int?
    let stopName:String?
    let routeId:Int?
}
