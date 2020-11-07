//
//  StudentsResponse.swift
//  MiltonWalking
//
//  Created by Krishna Datt Shukla on 21/07/20.
//  Copyright © 2020 Appzoro. All rights reserved.
//

import Foundation


struct StudentsResponse: Codable {
    let type, message: String
    let data: [Student]
}

struct Student: Codable {
    let id: Int?
    let parentId: String?
    let fullName: String?
    let email: String?
    let createdOn: String?
    let grade: String?
    let image: String?
    let schoolName: String?
}
