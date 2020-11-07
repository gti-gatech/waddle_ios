//
//  TripMapBDM.swift
//  MiltonWalking
//
//  Created by Jitendra Singh on 04/08/20.
//  Copyright © 2020 Appzoro. All rights reserved.
//

import Foundation

// MARK: - TripMapBDM
struct TripMapBDM: Codable {
    let type, message: String
    let data: TripData
}

// MARK: - DataClass
struct TripData: Codable {
    let tripStatus: [TripStatus]
    let data: [TripMap]
}

// MARK: - Datum
struct TripMap: Codable {
    let id, studentID, tripID: Int
    var status: String
    let isActive: Int
    let createdOn: String
    let modifiedOn: String
    let stopID: Int
    let pickupCount: Int?
    let studentName: String
    let studentGrade: String
    let contact: String
    let parentName: String
    let stopName: String
    var stopLocation: [String: Double]

    enum CodingKeys: String, CodingKey {
        case id
        case studentID = "studentId"
        case tripID = "tripId"
        case status, isActive, createdOn, modifiedOn
        case stopID = "stopId"
        case pickupCount, studentName, studentGrade, contact, parentName, stopName, stopLocation
    }
}


// MARK: - TripStatus
struct TripStatus: Codable {
    let id: Int
    let status, longitude, latitude: String
}
