//
//  GroupDetailBDM.swift
//  MiltonWalking
//
//  Created by Jitendra Singh on 30/07/20.
//  Copyright © 2020 Appzoro. All rights reserved.
//

import Foundation

// MARK: - GroupDetailBDM
struct GroupDetailBDM: Codable {
    let type, message: String
    let data: GroupDetailData
}

// MARK: - DataClass
struct GroupDetailData: Codable {
    var groupDetails: GroupDetails
    var groupStudents: [GroupStudent]
    var trips: [Trip]
}

// MARK: - GroupDetails
struct GroupDetails: Codable {
    var groupID: Int
    var groupName: String
    let routeID: Int
    var image, createdOn: String
    let totalStudents, tripsWalked: Int

    enum CodingKeys: String, CodingKey {
        case groupID = "groupId"
        case groupName
        case routeID = "routeId"
        case image, createdOn, totalStudents, tripsWalked
    }
}

// MARK: - GroupStudent
struct GroupStudent: Codable {
    let id, studentID: Int
    let createdOn: String
    let isActive, stopID, groupID: Int
    let stopName: String?
    let location: [String: Double]?
    let fullName, grade, schoolName: String

    enum CodingKeys: String, CodingKey {
        case id
        case studentID = "studentId"
        case createdOn, isActive
        case stopID = "stopId"
        case groupID = "groupId"
        case stopName, location, fullName, grade, schoolName
    }
}

// MARK: - Trip
struct Trip: Codable {
    let tripID, groupID, isSupervised: Int
    let supervisorID, dueOn: String
    var status: TripCompleteStatus
    let tripDate: String
    let displayTime: String
    let groupName: String
    let supervisorName: String?
    let pickupStopName:String?
    let pickupStop: Int?
    let supervisorStar: Int
    let startTripFlag:Int

    enum CodingKeys: String, CodingKey {
        case tripID = "tripId"
        case groupID = "groupId"
        case isSupervised,startTripFlag
        case supervisorID = "supervisorId"
        case dueOn, status, tripDate, displayTime, groupName, supervisorName, supervisorStar, pickupStop,pickupStopName
    }
}

enum TripCompleteStatus: String, Codable {
    case tripCompleted = "TRIP_COMPLETED"
    case tripNotStarted = "TRIP_NOT_STARTED"
    case tripStarted = "TRIP_STARTED"
}
