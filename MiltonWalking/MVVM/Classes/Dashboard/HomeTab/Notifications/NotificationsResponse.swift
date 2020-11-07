//
//  NotificationsResponse.swift
//  MiltonWalking
//
//  Created by Krishna Datt Shukla on 11/08/20.
//  Copyright © 2020 Appzoro. All rights reserved.
//

import Foundation

// MARK: - NotificationsResponse
struct NotificationsResponse: Codable {
    let type, message: String
    let data: DataN
}
// MARK: - DataClass
struct DataN: Codable {
    let today, yesterday, previous: [NotificationData]
}

// MARK: - Datum
struct NotificationData: Codable {
    let id: Int
    let parentID: String
    let hasActions: Int
    let message: String
    let payload: Payload
    let type: String
    let actions: [String: String]
    let status, dueOn: String

    enum CodingKeys: String, CodingKey {
        case id
        case parentID = "parentId"
        case hasActions, message, payload, type, actions, status, dueOn
    }
}

// MARK: - Payload
struct Payload: Codable {
    let parentID:String?
    let deviceToken: String?
    let tripID:Int?
    let groupID: Int
    let dueOn: String?
    let groupName: String?
    
    enum CodingKeys: String, CodingKey {
        case parentID = "parentId"
        case deviceToken
        case tripID = "tripId"
        case groupID = "groupId"
        case dueOn, groupName
    }
}
