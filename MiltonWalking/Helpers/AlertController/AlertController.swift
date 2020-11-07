//
//  AlertController.swift
//  AlamoFireHTTPDemo
//
//  Created by Krishna Datt Shukla on 9/13/16.
//  Copyright © 2016 Appzoro. All rights reserved.
//

import UIKit

open class AlertController: NSObject {
    
    static func showAlertWithTitle(_ title: String?, message : String?, buttonTitle : String, delay : Int64, alertStyle: UIAlertController.Style) {
        let delayInSeconds : Int64 = delay
        let popTime : DispatchTime = DispatchTime.now() + Double(delayInSeconds * Int64(NSEC_PER_SEC)) / Double(NSEC_PER_SEC)
        DispatchQueue.main.asyncAfter(deadline: popTime) {
            var alertTitle : String = title!
            if title == nil {
                alertTitle = ""
            }
            let alert : UIAlertController = UIAlertController.init(title: alertTitle, message: message, preferredStyle: alertStyle)
            alert.addAction(UIAlertAction.init(title: buttonTitle, style: .cancel, handler: nil))
            UIApplication.shared.keyWindow?.rootViewController!.present(alert, animated: true, completion: nil)
        }
    }
    
    static func showAlertWithTitle(_ title: String?, message : String?, actionDic : [String: (UIAlertAction) -> Void], alertStyle: UIAlertController.Style) {
        var alertTitle : String = title!
        if title == nil {
            alertTitle = ""
        }
        let alert : UIAlertController = UIAlertController.init(title: alertTitle, message: message, preferredStyle: alertStyle)
        
        for (key, value) in actionDic {
            let buttonTitle : String = key
            let action: (UIAlertAction) -> Void = value
            alert.addAction(UIAlertAction.init(title: buttonTitle, style: .default, handler: action))
        }
        
        if alertStyle == .actionSheet {
            alert.addAction(UIAlertAction.init(title: "Cancel", style: .cancel, handler: nil))
        }
        
        UIApplication.shared.keyWindow?.rootViewController!.present(alert, animated: true, completion: nil)
    }
    
    static func showActionSheetWithTitle(_ title: String?, message : String?, actionDic : [[String: Any]], tag: Int, complete: @escaping ( _ tag: Int, _ action: UIAlertAction? ) -> ()) {
        
        let alert : UIAlertController = UIAlertController.init(title: title, message: message, preferredStyle: .actionSheet)
        for dic in actionDic {
            let buttonTitle : String = dic["title"] as! String
            let style: UIAlertAction.Style = dic["style"] as! UIAlertAction.Style
            let action = UIAlertAction.init(title: buttonTitle, style: style, handler: { (action) in
                complete(tag, action)
            })
            
            alert.addAction(action)
        }
        
        alert.addAction(UIAlertAction.init(title: "Cancel", style: .cancel, handler: nil))
        
        UIApplication.shared.keyWindow?.rootViewController!.present(alert, animated: true, completion: nil)
    }
}
