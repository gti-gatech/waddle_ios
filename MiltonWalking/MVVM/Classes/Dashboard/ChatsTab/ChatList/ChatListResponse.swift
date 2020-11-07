//
//  ChatListResponse.swift
//  MiltonWalking
//
//  Created by Krishna Datt Shukla on 17/08/20.
//  Copyright © 2020 Appzoro. All rights reserved.
//


// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let chatListResponse = try? newJSONDecoder().decode(ChatListResponse.self, from: jsonData)

import Foundation

// MARK: - ChatListResponse
struct ChatListResponse: Codable {
    let type, message: String
    let data: [ChatList]
}

// MARK: - Datum
struct ChatList: Codable {
    let groupID: Int?
    let groupName: String?
    let routeID: Int?
    let image: String?
    let messageID: Int?
    let message: String?
    let senderID, createdOn: String?
    let senderName: String?
    let totalUnRead: Int?

    enum CodingKeys: String, CodingKey {
        case groupID = "groupId"
        case groupName
        case routeID = "routeId"
        case image
        case messageID = "messageId"
        case message
        case senderID = "senderId"
        case createdOn, senderName, totalUnRead
    }
}
