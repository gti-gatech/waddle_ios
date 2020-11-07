//
//  StudentDetail.swift
//  MiltonWalking
//
//  Created by Jitendra Singh on 06/07/20.
//  Copyright © 2020 Appzoro. All rights reserved.
//

import UIKit

enum ParentDetailTitle: String {
    case name = "Full Name"
    case email = "Email"
    case phoneNumber = "Phone Number"
    case address = "Address"
    case defaultStop = "Select Default Stop"
}


struct ParentDetailField {
    var value: Any
    var title: String = ""
    var keyboardType: UIKeyboardType = .default
}

