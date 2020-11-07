//
//  MessageListResponse.swift
//  MiltonWalking
//
//  Created by Krishna Datt Shukla on 18/08/20.
//  Copyright © 2020 Appzoro. All rights reserved.
//

import Foundation

// MARK: - MessageListResponse
struct MessageListResponse: Codable {
    let type, message: String
    let data: [MessageList]
}

// MARK: - Datum
struct MessageList: Codable {
    let messageID, groupID: Int
    let senderID, createdOn, status, message: String
    let senderName: String

    enum CodingKeys: String, CodingKey {
        case messageID = "messageId"
        case groupID = "groupId"
        case senderID = "senderId"
        case createdOn, status, message, senderName
    }
}
