//
//  TripsResponse.swift
//  MiltonWalking
//
//  Created by Krishna Datt Shukla on 07/08/20.
//  Copyright © 2020 Appzoro. All rights reserved.
//

// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let tripsResponse = try? newJSONDecoder().decode(TripsResponse.self, from: jsonData)

import Foundation

// MARK: - TripsResponse
struct TripsResponse: Codable {
    let type, message: String
    let data: Trips
}

// MARK: - DataClass
struct Trips: Codable {
    let history: History
    let upcoming: Upcoming
}

// MARK: - History
struct History: Codable {
    let studentsHistory: StudentsHistory
    let supervisorHistory: SupervisorHistory
}

// MARK: - StudentsHistory
struct StudentsHistory: Codable {
    let today, yesterday, previous: [TripDetail]
}

// MARK: - SupervisorHistory
struct SupervisorHistory: Codable {
    let today, yesterday, previous: [TripDetail]
//    let today, yesterday, previous: [SupervisorUpcoming]
}
// MARK: - Upcoming
struct Upcoming: Codable {
    let studentsUpcoming: [TripDetail]
    let supervisorUpcoming: [TripDetail]
}

// MARK: - StudentsUpcoming
struct TripDetail: Codable {
    let studentID, tripID, stopID, groupID: Int?
    let supervisorID, dueOn, groupName, stopName: String?
    let fullName, studentName: String?
    var supervisorStar: Int?

    enum CodingKeys: String, CodingKey {
        case studentID = "studentId"
        case tripID = "tripId"
        case stopID = "stopId"
        case groupID = "groupId"
        case supervisorID = "supervisorId"
        case dueOn, groupName, stopName, fullName, studentName, supervisorStar
    }
}

// MARK: - SupervisorUpcoming
struct SupervisorUpcoming: Codable {
    let groupID: Int?
    let supervisorID, dueOn, groupName, stopName: String?
    let fullName: String?
    let supervisorStar: Int?

    enum CodingKeys: String, CodingKey {
        case groupID = "groupId"
        case supervisorID = "supervisorId"
        case dueOn, groupName, stopName, fullName, supervisorStar
    }
}


