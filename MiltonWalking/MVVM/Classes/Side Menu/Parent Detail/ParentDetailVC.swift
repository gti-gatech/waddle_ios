//
//  ParentDetailVC.swift
//  MiltonWalking
//
//  Created by Jitendra Singh on 13/07/20.
//  Copyright © 2020 Appzoro. All rights reserved.
//

import UIKit
import Kingfisher
class ParentDetailVC: UIViewController {
    
    @IBOutlet weak var btnEditImage: UIButton!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var imageViewUser: UIImageView!
    var viewModel = ParentDetailVM()
    var selectedImage: UIImage?
    var isToEdit = false
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupView()
        self.setupNavigation()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: false)
    }
    func setupNavigation() {
        self.title = "Parent Details"
        CommonFunctions.setLeftBarButtonItemWith(image: #imageLiteral(resourceName: "back"), action: #selector(backbtnClicked), view: self)
        self.manageRightNavigationButton()
        self.tabBarController?.tabBar.isHidden = true
    }
    func manageRightNavigationButton() {
        if isToEdit{
            CommonFunctions.setRightBarButtonItemWith(image: UIImage(named: "save_2") ?? UIImage(), action: #selector(btnSaveClicked), view: self)
        }else{
            CommonFunctions.setRightBarButtonItemWith(image: UIImage(named: "edit_blue_circle") ?? UIImage(), action: #selector(btnEditClicked), view: self)
        }
    }
    func setupView() {
        self.imageViewUser.setCornerRadius(58, borderWidth: 0, borderColor: .clear)
        viewModel.setupDataSource { strImage in
            self.tableView.reloadData()
            self.imageViewUser.kf.setImage(with: URL(string: strImage), placeholder: UIImage(named: "user_profile"))
        }
    }
    @IBAction func backbtnClicked() {
        self.tabBarController?.tabBar.isHidden = false
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func btnEditProfileImageClicked(_ sender: Any) {
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
    @IBAction func btnSaveClicked() {
        self.view.endEditing(true)
        viewModel.validateTextFields(completion: { (status, message) in
            if status {
                self.saveData()
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
    @IBAction func btnEditClicked() {
        self.isToEdit = true
        self.btnEditImage.isHidden = false
        self.manageRightNavigationButton()
    }
    func saveData() {
        if !CommonFunctions.isNetworkReachable() {
            self.showCustomAlertWith(message: NO_INTERNET_CONNECTION, descMsg: "", itemimage: nil, actions: nil)
            return
        }
        CommonFunctions.showHUD(controller: self)
        viewModel.apiCallForSaveParentData { (status, message) in
            CommonFunctions.hideHUD(controller: self)
            self.isToEdit = false
            self.manageRightNavigationButton()
            self.btnEditImage.isHidden = true
            if status {
                self.showCustomAlertWith(
                    message: "Your profile has been updated successfully.",
                    descMsg: "",
                    itemimage: nil,
                    actions: nil
                )
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
extension ParentDetailVC:UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 4 {
            let cell = tableView.dequeueReusableCell(withIdentifier: PrentSelectStopCell.cellIdenifier, for: indexPath) as! PrentSelectStopCell
            if let data = viewModel.getParentDataForFieldAt(index: indexPath.row) {
                cell.parentData = data
            }
            return cell
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: ParentEditCell.cellIdenifier, for: indexPath) as! ParentEditCell
        cell.txtfDetail.tag = indexPath.row
        cell.txtfDetail.addTarget(self, action: #selector(updateInputFieldValue(textField:)), for: .editingChanged)
        if let data = viewModel.getParentDataForFieldAt(index: indexPath.row) {
            cell.parentData = data
            if indexPath.row == 2 {
                cell.txtfDetail.text = formattedNumber(number: data.value as? String ?? "")
            }
        }
        return cell
    }
}

extension ParentDetailVC:UITableViewDelegate{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 4 && self.isToEdit{
            self.view.endEditing(true)
            let vc = SelectStopMapVC.instantiate(fromStoryboard: .main)
            vc.isToUpdateParent = true
            vc.doneConfirmStop = { data in
                self.viewModel.updateStopField(at: data!)
                self.tableView.reloadRows(at: [IndexPath(row: 4, section: 0)], with: .none)
            }
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
}

extension ParentDetailVC: UITextFieldDelegate {
    @IBAction func updateInputFieldValue(textField: UITextField) {
        guard let text = textField.text else { return }
        if text.count >= 25{
            textField.text = String(text.prefix(25))
        }
        self.viewModel.updateTextField(at: textField.tag, value: textField.text ?? "")
    }
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if !self.isToEdit{
            return false
        }
        if textField.tag == 1{
            return false
        }
        return true
    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if textField.tag == 2  {
            guard let text = textField.text else { return false }
            let newString = (text as NSString).replacingCharacters(in: range, with: string)
            textField.text = formattedNumber(number: newString)
            viewModel.updateTextField(at: textField.tag, value: formattedNumber(number: newString))

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
}
