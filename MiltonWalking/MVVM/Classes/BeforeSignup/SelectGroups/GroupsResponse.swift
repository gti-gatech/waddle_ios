//
//  GroupsResponse.swift
//  MiltonWalking
//
//  Created by Krishna Datt Shukla on 07/07/20.
//  Copyright © 2020 Appzoro. All rights reserved.
//

import Foundation

// MARK: - GroupsBDM
struct GroupsBDM: Codable {
    let type, message: String
    let data: [GrouopsDM]
}

// MARK: - Datum
struct GrouopsDM: Codable {
    let groupID, routeID: Int
    let groupName, image, createdOn: String
    let totalStudents, totalTrips: Int
    let startLocation, endLocation: [String: Double]

    enum CodingKeys: String, CodingKey {
        case groupID = "groupId"
        case routeID = "routeId"
        case groupName, image, createdOn, totalStudents, totalTrips, startLocation, endLocation
    }
}
