//
//  DashboardResponse.swift
//  MiltonWalking
//
//  Created by Krishna Datt Shukla on 22/07/20.
//  Copyright © 2020 Appzoro. All rights reserved.
//

// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let dashBoardResponse = try? newJSONDecoder().decode(DashBoardResponse.self, from: jsonData)

import Foundation

// MARK: - DashBoardResponse
struct DashBoardResponse: Codable {
    let type, message: String
    let data: DashboardData
}

// MARK: - DataClass
struct DashboardData: Codable {
    let studentTrips: [StudentTrip]
    let supervisorTrips: [SupervisorTrip]
    let parentData:ParentData
    let tripsWalked: Int
    
    enum CodingKeys: String, CodingKey {
        case studentTrips = "studentTrips"
        case supervisorTrips = "supervisorTrips"
        case parentData = "parentData"
        case tripsWalked = "tripsWalked"
    }
}

// MARK: - StudentTrip
struct StudentTrip: Codable {
    let studentID, tripID, stopID, groupID: Int
    let isSupervised: Int
    let supervisorID, status, displayTime, dueOn: String
    let groupName, supervisorName, studentName: String

    enum CodingKeys: String, CodingKey {
        case studentID = "studentId"
        case tripID = "tripId"
        case stopID = "stopId"
        case groupID = "groupId"
        case isSupervised
        case supervisorID = "supervisorId"
        case status, displayTime, dueOn, groupName, supervisorName, studentName
    }
}

// MARK: - SupervisorTrip
struct SupervisorTrip: Codable {
    let groupID, isSupervised: Int
    let supervisorID, status, displayTime, dueOn: String
    let groupName, supervisorName: String

    enum CodingKeys: String, CodingKey {
        case groupID = "groupId"
        case isSupervised
        case supervisorID = "supervisorId"
        case status, displayTime, dueOn, groupName, supervisorName
    }
}
