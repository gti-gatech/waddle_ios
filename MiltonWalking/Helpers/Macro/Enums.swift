//
//  Enums.swift
//  MiltonWalking
//
//  Created by Krishna Datt Shukla on 13/07/20.
//  Copyright © 2020 Appzoro. All rights reserved.
//

import Foundation

enum ValidationError: String {
    case nameBlank = "Please enter your full name."
    case emailBlank = "Please enter your email."
    case emailInvalid = "Please provide a valid email."
    case resetEmailBlank = "Email can't be left blank."
    case passwordBlank = "Please enter a password."
    case passwordBlankLogin = "Please enter your password."
    case passwordInvalid = "Password should be atleast 5 characters long"
    case confirmPasswordBlank = "Please confirm password."
    case passwordNotMatched = "Passwords do not match, please re-enter."
    case phoneBlank = "Please enter your phone number."
    case phoneInvalid = "Please enter valid phone number."
    case addressBlank = "Please enter your address."
    case stopBlank = "Please select a default stop."
}

enum InputFieldPlaceholder: String {
    case email = "Email"
    case name = "Full Name"
    case password = "Password"
    case confirmPassword = "Confirm Password"
    case phone = "Phone Number"
    case address = "Address"
    case stop = "Select Default Stop"
}

enum InputFieldKey: String {
    case name
    case email
    case password
    case confirmPassword
    case phone
    case address
    case stop
}
