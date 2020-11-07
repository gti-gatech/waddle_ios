//
//  ForgetPasswordViewController.swift
//  MiltonWalking
//
//  Created by Jitendra Singh on 03/07/20.
//  Copyright © 2020 Appzoro. All rights reserved.
//

import UIKit

class ForgetPasswordVC: UIViewController {

    @IBOutlet weak var txtfEmail: UIView!
    @IBOutlet weak var txtfieldEmail: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.isNavigationBarHidden = false

        self.hideKeyboardWhenTappedAround()
        CommonFunctions.setLeftBarButtonItemWith(image: #imageLiteral(resourceName: "back"), action: #selector(backButtonAction), view: self)
    }
    
    @IBAction func backButtonAction() {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func sendButtonAction() {
        if txtfieldEmail.text?.isEmpty ?? false {
            self.showCustomAlertWith(
                message: ValidationError.resetEmailBlank.rawValue,
            descMsg: "",
            itemimage: nil,
            actions: nil
            )
        } else if !Validation.validateEmail(txtfieldEmail.text) {
            self.showCustomAlertWith(
            message: ValidationError.emailInvalid.rawValue,
            descMsg: "",
            itemimage: nil,
            actions: nil
            )
        } else {
            resetPassword()
        }
    }
    
    func resetPassword() {
        let requestParams = [
            "email": txtfieldEmail.text?.getTrimmedText() ?? "",
        ] as [String:Any]
        CommonFunctions.showHUDOnTop()
        Services.makeRequest(forStringUrl: ServiceAPI.api_reset_password.urlString(), method: .post, parameters: requestParams) { (response, error) in
            DispatchQueue.main.async {
                CommonFunctions.hideHUDFromTop()
                if (error != nil) {
                    self.showCustomAlertWith(
                    message: error ?? INTERNAL_SERVER_ERROR,
                    descMsg: "",
                    itemimage: nil,
                    actions: nil
                    )
                } else if let responseJSON = response?.result.value as? [String : Any] {
                    let responseDic: NSDictionary = responseJSON as NSDictionary
                    let actionYes: () -> Void = { (
                        self.navigationController?.popViewController(animated: true)
                    ) }
                    self.showCustomAlertWith(
                        okButtonAction: actionYes, // This is optional
                        message: responseDic[API_MESSAGE_KEY] as? String ?? "",
                        descMsg: "",
                        itemimage: nil,
                        actions: nil
                    )
                }
            }
        }
    }
}

extension ForgetPasswordVC: UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
}
