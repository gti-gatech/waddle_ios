//
//  StringExtension.swift
//  MyancarePatient
//
//  Created by Jyoti on 04/01/18.
//  Copyright © 2018 konstant. All rights reserved.
//

import Foundation
import UIKit

extension String {
    
    func isEmptyString() -> Bool {
        let newString = self.trimmingCharacters(in: .whitespacesAndNewlines)
        if newString.isEmpty
        {
            return true
        }
        return false
    }
    
    var condensedWhitespace: String {
        let components = self.components(separatedBy: .whitespacesAndNewlines)
        return components.filter { !$0.isEmpty }.joined(separator: " ")
    }
    
    
    func getTrimmedText() -> String {
        let newString = self.trimmingCharacters(in: .whitespacesAndNewlines)
        return newString
    }
    
    var firstUppercased: String {
        guard let first = first else { return "" }
        return String(first).uppercased() + dropFirst()
    }
    
    func containsWhiteSpace() -> Bool {
        
        // check if there's a range for a whitespace
        let range = self.rangeOfCharacter(from: .whitespaces)
        // returns false when there's no range for whitespace
        if let _ = range {
            return true
        } else {
            return false
        }
    }
    
    func isValidEmailAddress() -> Bool {
        
        var returnValue = true
        let emailRegEx = "[A-Z0-9a-z.-_]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,3}"
        
        do {
            let regex = try NSRegularExpression(pattern: emailRegEx)
            let nsString = self as NSString
            let results = regex.matches(in: self, range: NSRange(location: 0, length: nsString.length))
            
            if results.count == 0 {
                returnValue = false
            }
            
        } catch let error as NSError {
            print("invalid regex: \(error.localizedDescription)")
            returnValue = false
        }
        return  returnValue
    }
    
    func randomStringGenerateFromString(length: Int) -> String {
        let base = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        var randomString: String = ""
        
        for _ in 0..<length {
            let randomValue = arc4random_uniform(UInt32(base.count))
            randomString += "\(base[base.index(base.startIndex, offsetBy: Int(randomValue))])"
        }
        return randomString
    }
    
    func stringByAddingPercentEncodingForRFC3986() -> String? {
        let str = self.addingPercentEncoding(withAllowedCharacters: .urlFragmentAllowed)
        return str
    }
    
    var isValidPhone: Bool {
        return self.count == 14
////       let regularExpressionForPhone = "^(\\d{3}) \\d{3}-\\d{4}$"
//
//        let regularExpressionForPhone = "^({3}) {3}-{4}$";
//
//       let testPhone = NSPredicate(format:"SELF MATCHES %@", regularExpressionForPhone)
//       return testPhone.evaluate(with: self)
    }
    
}
