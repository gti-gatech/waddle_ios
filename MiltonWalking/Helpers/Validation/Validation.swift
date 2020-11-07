//
//  Validation.swift
//  AlamoFireHTTPDemo
//
//  Created by Krishna on 9/14/16.
//  Copyright © 2016 Appzoro. All rights reserved.
//

import UIKit

class Validation: NSObject {
    
    /**
     Used to validate whether email is in email format or not
     - parameter email: email string to be tested for valid email
     - returns: YES if email is following email constraints or NO if email is not following email constraints
     */
    static func validateEmail(_ email : String?) -> Bool {
        let emailRegex : String = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"
        let emailTest : NSPredicate = NSPredicate(format:"SELF MATCHES %@", emailRegex)
        return emailTest.evaluate(with: email)
    }
    
    /**
     Used to Validate Password to have at least 6 alpha numerics
     
     - parameter password: password string to be validated
     
     - returns: YES if password is valid or NO if password is in-valid
     */
    static func validatePassword(_ password : String) -> Bool {
        let passwordRegex : String = "^.{5,}$"
        let passwordTest : NSPredicate = NSPredicate(format:"SELF MATCHES %@", passwordRegex)
        return passwordTest.evaluate(with: password)
    }
    
    /**
     Used to validate whether value is empty or not
     
     - parameter value: value string to be validated
     
     - returns: YES if value is not empty or NO if value is empty
     */
    static func isValueNotEmpty(_ value : String?) -> Bool {
        if (value == nil || (value?.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines).isEmpty)!) {
            return false
        }
        return true
    }
    
    /**
     Used to validate whether a string contains only numbers
     
     - parameter numberString: number string to be validated
     
     - returns: YES if string contains only numbers otherwise NO
     */
    static func isNumber(_ numberString : String) -> Bool {
        let nonDigits : CharacterSet = CharacterSet.decimalDigits.inverted
        if (numberString.rangeOfCharacter(from: nonDigits)) != nil {
            return false
        }
        return true
    }
}
