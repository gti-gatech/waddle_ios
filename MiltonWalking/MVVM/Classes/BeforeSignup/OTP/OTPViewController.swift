//
//  OTPViewController.swift
//  MiltonWalking
//
//  Created by Jitendra Singh on 19/08/20.
//  Copyright © 2020 Appzoro. All rights reserved.
//

import UIKit

class OTPViewController: UIViewController {
    @IBOutlet var pinView: SVPinView!
    var doneVerification:(() -> Void)?
    var strEmail = ""
    var viewModle = OTPViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //self.callWebServiceToSendOTP()
        configurePinView()
        self.setupNavigation()
    }
    func setupNavigation() {
        CommonFunctions.setRightBarButtonItemWith(image: UIImage(named: "close") ?? UIImage(), action: #selector(backButtonAction), view: self)
    }
    @IBAction func backButtonAction() {
        self.dismiss(animated: true, completion: nil)
    }
    func configurePinView() {
        pinView.becomeFirstResponderAtIndex = 0
        pinView.shouldDismissKeyboardOnEmptyFirstField = false
        
        pinView.font = UIFont.systemFont(ofSize: 15)
        pinView.keyboardType = .phonePad
        pinView.pinInputAccessoryView = { () -> UIView in
            let doneToolbar: UIToolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: 320, height: 50))
            doneToolbar.barStyle = UIBarStyle.default
            let flexSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
            let done: UIBarButtonItem  = UIBarButtonItem(title: "cancel", style: UIBarButtonItem.Style.done, target: self, action: #selector(dismissKeyboard))
            
            var items = [UIBarButtonItem]()
            items.append(flexSpace)
            items.append(done)
            
            doneToolbar.items = items
            doneToolbar.sizeToFit()
            return doneToolbar
        }()
        
        pinView.didFinishCallback = didFinishEnteringPin(pin:)
        pinView.didChangeCallback = { pin in
            print("The entered pin is \(pin)")
        }
    }
    @IBAction func btnResendClicked(_ sender: Any) {
        self.callWebServiceToSendOTP()
    }
    func didFinishEnteringPin(pin:String) {
        
    }
    @IBAction func btnVerifyClicked(_ sender: Any) {
        CommonFunctions.showHUD(controller: self)
        self.viewModle.apiCallToVarifyOtp(strEmail: self.strEmail, strOTP: self.pinView.getPin()) { (status, message) in
            CommonFunctions.hideHUD(controller: self)
            if status {
                self.doneVerification?()
                self.dismiss(animated: true, completion: nil)
            } else {
                self.showCustomAlertWith(
                    message: message ,
                    descMsg: "",
                    itemimage: nil,
                    actions: nil
                )
            }
        }
        
    }
    func callWebServiceToSendOTP() {
        CommonFunctions.showHUD(controller: self)
        self.viewModle.apiCallToSendOtp(strEmail: self.strEmail) { (status, message) in
            CommonFunctions.hideHUD(controller: self)
            if status || message == "OTP has been sent successfully."{
                
            } else {
                self.showCustomAlertWith(
                    message: message ,
                    descMsg: "",
                    itemimage: nil,
                    actions: nil
                )
            }
        }
    }
}
