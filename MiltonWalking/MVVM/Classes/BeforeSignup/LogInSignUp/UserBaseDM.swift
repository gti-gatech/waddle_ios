//
//  UserData.swift
//  MiltonWalking
//
//  Created by Jitendra Singh on 14/07/20.
//  Copyright © 2020 Appzoro. All rights reserved.
//

// MARK: - UserBaseDM
struct UserBaseDM: Codable {
    let type, message: String
    let data: loginData
}

// MARK: - DataClass
struct loginData: Codable {
    let parentData: ParentData
    let auth: Auth?
}

// MARK: - Auth
struct Auth: Codable {
    let type, authToken: String
}

// MARK: - ParentData
struct ParentData: Codable {
    let parentID, email, fullName, contact: String
    let address, image, createdOn: String
    let isFirstTime, totalStudents, totalTrips, stopID: Int
    let stopName: String?

    enum CodingKeys: String, CodingKey {
        case parentID = "parentId"
        case email, fullName, contact, address, image, createdOn, isFirstTime, totalStudents, totalTrips
        case stopID = "stopId"
        case stopName
    }
}
