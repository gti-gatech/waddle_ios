//
//  LoginSignUpVC.swift
//  MiltonWalking
//
//  Created by Krishna Datt Shukla on 01/07/20.
//  Copyright © 2020 Appzoro. All rights reserved.
//

import UIKit

enum SelectedTab: Int {
    case signup
    case login
}

class LoginSignUpVC: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var viewLeftButton: UIImageView!
    @IBOutlet weak var viewRightButton: UIImageView!
    
    @IBOutlet weak var buttonSubmit: UIButton!
    @IBOutlet weak var buttonDesc: UIButton!
    @IBOutlet weak var imageViewUser: UIImageView!
    
    var selectedImage: UIImage?
    
    var viewModel = LoginSignUpViewModel()
    var selectedTab: SelectedTab = .login
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupNavigation(isToHide: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        setupNavigation(isToHide: false)
    }
    
    func setupNavigation(isToHide:Bool) {
        navigationController?.setNavigationBarHidden(isToHide, animated: false)
        navigationController?.setTransparentNavigationBar()
        let attributes = [NSAttributedString.Key.font: UIFont(name: "HelveticaNeue-Light", size: 17)!]
        UINavigationBar.appearance().titleTextAttributes = attributes
        //        navigationController?.setTransparentNavigationBar()
    }
    
    func setupView() {
        updateUI()
        
        buttonSubmit.setCornerRadius(25.0, borderWidth: 0.0, borderColor: .clear)
        viewModel.setupDataSource {
            self.tableView.reloadData()
        }
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(imageTapped))
        tap.numberOfTapsRequired = 1
        imageViewUser.addGestureRecognizer(tap)
        imageViewUser.isUserInteractionEnabled = true
    }
    
    func updateUI() {
        if selectedTab == .login {
            viewLeftButton.isHidden = true
            viewRightButton.isHidden = false
            buttonSubmit.setTitle("Sign In", for: .normal)
            buttonDesc.setTitle("Forgot password?", for: .normal)
            imageViewUser.backgroundColor = .clear
            imageViewUser.image = #imageLiteral(resourceName: "Signin_logo")
            imageViewUser.setCornerRadius(0.0, borderWidth: 0.0, borderColor: .clear)
            imageViewUser.contentMode = .scaleAspectFit
        } else {
            viewLeftButton.isHidden = false
            viewRightButton.isHidden = true
            buttonSubmit.setTitle("Sign Up", for: .normal)
            buttonDesc.setTitle("By creating an account you agree to our Terms & Conditions and Privacy Policy", for: .normal)
            imageViewUser.backgroundColor = COLOR_PRIMARY_DENIM
            imageViewUser.image = #imageLiteral(resourceName: "camera")
            imageViewUser.setCornerRadius(75.0, borderWidth: 0.0, borderColor: .clear)
            imageViewUser.contentMode = .scaleAspectFill
            if selectedImage != nil {
                imageViewUser.image = selectedImage
            }
        }
    }
    
    @IBAction func segmentChanged(button: UIButton) {
        if button.tag == 1 {
            selectedTab = .signup
            viewLeftButton.isHidden = false
            viewRightButton.isHidden = true
        } else  {
            selectedTab = .login
            viewLeftButton.isHidden = true
            viewRightButton.isHidden = false
        }
        tableView.reloadData()
        updateUI()
    }
    
    @IBAction func imageTapped() {
        if selectedTab == .signup {
            showImagePickingOptions(type: PickingMediaType.image, allowEditing: true) { (result) in
                self.selectedImage = result as? UIImage
                DispatchQueue.main.async {
                    self.imageViewUser.image = result as? UIImage
                }
                if let img = result as? UIImage {
                    self.uploadProfileImage(img)
                }
            }
        }
    }
    
    /*
     // MARK: - Navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}

extension LoginSignUpVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return selectedTab == .login ? viewModel.loginFieldsCount : viewModel.signupFieldsCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "InputFieldCell") as! InputFieldCell
        
        if selectedTab == .login {
            if let field = viewModel.loginField(at: indexPath.row) {
                cell.setupCell(with: field)
            }
        } else {
            if let field = viewModel.signupField(at: indexPath.row) {
                cell.setupCell(with: field)
            }
        }
        cell.textFieldValue.delegate = self
        cell.textFieldValue.tag = indexPath.row
        cell.textFieldValue.addTarget(self, action: #selector(updateInputFieldValue(textField:)), for: .editingChanged)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return SCREEN_WIDTH * (60.0/375.0)
    }
}

extension LoginSignUpVC: UITextFieldDelegate {
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if selectedTab == .signup && textField.tag == 6 {
            self.view.endEditing(true)
            let vc = SelectStopMapVC.instantiate(fromStoryboard: .main)
            vc.doneConfirmStop = { data in
                self.viewModel.updateStopField(at: data!)
                self.tableView.reloadRows(at: [IndexPath(row: 6, section: 0)], with: .none)
            }
            self.navigationController?.pushViewController(vc, animated: true)
            return false
        }
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if textField.tag == 4  {
            guard let text = textField.text else { return false }
            let newString = (text as NSString).replacingCharacters(in: range, with: string)
            textField.text = formattedNumber(number: newString)
            viewModel.updateSignUpField(at: textField.tag, value: formattedNumber(number: newString))
            
            return false
        }
        return true
    }
    
    func formattedNumber(number: String) -> String {
        let cleanPhoneNumber = number.components(separatedBy: CharacterSet.decimalDigits.inverted).joined()
        let mask = "(XXX) XXX-XXXX"
        
        var result = ""
        var index = cleanPhoneNumber.startIndex
        for ch in mask where index < cleanPhoneNumber.endIndex {
            if ch == "X" {
                result.append(cleanPhoneNumber[index])
                index = cleanPhoneNumber.index(after: index)
            } else {
                result.append(ch)
            }
        }
        return result
    }
    
    @IBAction func updateInputFieldValue(textField: UITextField) {
        if selectedTab == .signup {
            viewModel.updateSignUpField(at: textField.tag, value: textField.text ?? "")
        } else {
            viewModel.updateLoginField(at: textField.tag, value: textField.text ?? "")
        }
    }
    
    @IBAction func bottomLinkButtonTapped(sender: UIButton) {
        self.view.endEditing(true)
        if selectedTab == .signup {
            // go to t&n
        } else {
            //go to forget password
            performSegue(withIdentifier: "LOGIN_TO_FP", sender: nil)
        }
    }
    func navigateToOTPVC()  {
        let vc = OTPViewController.instantiate(fromStoryboard: .main)
        vc.strEmail = self.viewModel.getStrEmail()
        vc.doneVerification = {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                self.doSignUp()
            }
        }
        let navController = UINavigationController(rootViewController: vc)
        navController.navigationBar.tintColor = UIColor.black
        navController.modalPresentationStyle = .overCurrentContext
        self.present(navController, animated: true, completion: nil)
    }
    @IBAction func submitButtonAction(sender: UIButton) {
        self.view.endEditing(true)
        //        self.navigateToOTPVC()
        //        return
        if selectedTab == .login {
            viewModel.validateLoginFields(completion: { (status, message) in
                if status {
                    self.doLogin()
                } else {
                    self.showCustomAlertWith(
                        message: message ?? "",
                        descMsg: "",
                        itemimage: nil,
                        actions: nil
                    )
                }
            })
        } else {
            viewModel.validateSignUpFields(completion: { (status, message) in
                if status {
                    self.doSignUp()
//                    self.navigateToOTPVC()
                } else {
                    self.showCustomAlertWith(
                        message: message ?? "",
                        descMsg: "",
                        itemimage: nil,
                        actions: nil
                    )
                }
            })
        }
    }
    
    func doLogin() {
        if !CommonFunctions.isNetworkReachable() {
            self.showCustomAlertWith(message: NO_INTERNET_CONNECTION, descMsg: "", itemimage: nil, actions: nil)
            return
        }
        CommonFunctions.showHUD(controller: self)
        viewModel.apiCallForLogin { (status,isFirstTime, message) in
            CommonFunctions.hideHUD(controller: self)
            if status {
                if !isFirstTime{
                    self.navigationController?.pushViewController(TermAndConditionsVC.instantiate(fromStoryboard: .main), animated: true)
                }else{
                    AppDelegate.sharedInstance.setupTabBarAsRoot()
                }
                
            } else {
                self.showCustomAlertWith(
                    message: message,
                    descMsg: "",
                    itemimage: nil,
                    actions: nil
                )
            }
        }
    }
    
    func doSignUp() {
        if !CommonFunctions.isNetworkReachable() {
            self.showCustomAlertWith(message: NO_INTERNET_CONNECTION, descMsg: "", itemimage: nil, actions: nil)
            return
        }
        CommonFunctions.showHUD(controller: self)
        viewModel.apiCallForSignUp { (status, message) in
            CommonFunctions.hideHUD(controller: self)
            
            if status {
                self.navigationController?.pushViewController(TermAndConditionsVC.instantiate(fromStoryboard: .main), animated: true)
            } else {
                if message == "Your OTP has not been verified yet." {
                    self.navigateToOTPVC()
                } else {
                    self.showCustomAlertWith(
                        message: message,
                        descMsg: "",
                        itemimage: nil,
                        actions: nil
                    )
                }
            }
        }
    }
    
    
    func uploadProfileImage(_ image: UIImage) {
        guard let imgData = image.jpegData(compressionQuality: 0.5) else {
            return
        }
        let file = MultipartFile()
        file.fileData = imgData
        DispatchQueue.main.async {
            CommonFunctions.showHUD(controller: self)
        }
        Services.makeMultipartRequest(forStringUrl: ServiceAPI.api_upload_media.urlString(), method: .post, file: file, otherParameters: nil) { (response, message) in
            DispatchQueue.main.async {
                CommonFunctions.hideHUD(controller: self)
            }
            let responseData = response?.result.value as? [String : Any]
            print(responseData as Any)
            let data = responseData?["data"] as? [String : Any]
            
            if let name = data?["fd"] as? String {
                self.viewModel.selectedImageName = name
            }
        }
    }
}
