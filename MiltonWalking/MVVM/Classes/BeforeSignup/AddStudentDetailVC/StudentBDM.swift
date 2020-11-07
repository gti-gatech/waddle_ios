//
//  StudentBDM.swift
//  MiltonWalking
//
//  Created by Jitendra Singh on 08/07/20.
//  Copyright © 2020 Appzoro. All rights reserved.
//
import Foundation

// MARK: - StudentBDM
struct StudentBDM: Codable {
    let type, message: String
    let data: [StudentDM]
}

// MARK: - Datum
struct StudentDM: Codable {
    let id: Int
    let parentID, fullName, email, createdOn: String
    let grade, image, schoolName: String

    enum CodingKeys: String, CodingKey {
        case id
        case parentID = "parentId"
        case fullName, email, createdOn, grade, image, schoolName
    }
}
