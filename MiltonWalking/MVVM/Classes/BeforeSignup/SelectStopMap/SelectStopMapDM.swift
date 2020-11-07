//
//  SelectStopMapDM.swift
//  MiltonWalking
//
//  Created by Jitendra Singh on 04/07/20.
//  Copyright © 2020 Appzoro. All rights reserved.
//

import UIKit

import Foundation

// MARK: - SelectStopMapDM
struct SelectStopMapBaseDM: Codable {
    let type, message: String
    let data: [SelectStopMapDM]?
}

// MARK: - Datum
struct SelectStopMapDM: Codable {
    let stopID, routeID: Int
    let name: String
    let createdOn: String
    let location: [String: Double]
    let groupName: String?
    
    enum CodingKeys: String, CodingKey {
        case stopID = "stopId"
        case routeID = "routeId"
        case name, createdOn, location, groupName
    }
}
