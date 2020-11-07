//
//  StudentDetail.swift
//  MiltonWalking
//
//  Created by Jitendra Singh on 06/07/20.
//  Copyright © 2020 Appzoro. All rights reserved.
//

import UIKit

enum StudentDetailPlaceholder: String {
    case name = "Student Name"
    case email = "Email"
    case schoolName = "School Name"
    case studentgrade = "Student Grade"
}


struct StudentDetailField {
    var value: Any
    var title: String = ""
    var keyboardType: UIKeyboardType = .default
    var placeholder: String = ""
}

