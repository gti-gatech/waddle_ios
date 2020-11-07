//
//  MyGroupsResponse.swift
//  MiltonWalking
//
//  Created by Krishna Datt Shukla on 28/07/20.
//  Copyright © 2020 Appzoro. All rights reserved.
//

// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let dashBoardResponse = try? newJSONDecoder().decode(DashBoardResponse.self, from: jsonData)

import Foundation

// MARK: - DashBoardResponse
struct MyGroupsResponse: Codable {
    let type, message: String
    let data: [Group]
}

// MARK: - Datum
struct Group: Codable {
    let groupID: Int?
    let groupName: String?
    let routeID: Int?
    let image: String?
    let totalStudents, tripsWalked, isSupervised: Int?
    let supervisorID, tripDate, displayTime, dueOn: String?
    let status: String?
    let supervisorStar: Int?

    enum CodingKeys: String, CodingKey {
        case groupID = "groupId"
        case groupName
        case routeID = "routeId"
        case image, totalStudents, tripsWalked, isSupervised
        case supervisorID = "supervisorId"
        case tripDate, displayTime, dueOn, status, supervisorStar
    }
}
