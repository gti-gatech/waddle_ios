//
//  InputFieldCell.swift
//  MiltonWalking
//
//  Created by Krishna Datt Shukla on 01/07/20.
//  Copyright © 2020 Appzoro. All rights reserved.
//

import UIKit

class InputFieldCell: UITableViewCell {
    
    @IBOutlet weak var imageViewIcon: UIImageView!
    @IBOutlet weak var textFieldValue: UITextField!
    @IBOutlet weak var imageViewDropDown: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setupCell(with field: InputField) {
        imageViewIcon.image = field.icon
        textFieldValue.placeholder = field.placeholder
        textFieldValue.keyboardType = field.keyboardType
        if let value = field.value as? String {
            textFieldValue.text =  value
        }
        if let value = (field.value as? SelectStopMapDM)?.name{
            textFieldValue.text =  value
        }
        if field.key == InputFieldKey.password.rawValue || field.key == InputFieldKey.confirmPassword.rawValue {
            textFieldValue.isSecureTextEntry = true
        } else {
            textFieldValue.isSecureTextEntry = false
        }
        
        if field.key == InputFieldKey.stop.rawValue {
            imageViewDropDown.isHidden = false
        } else {
            imageViewDropDown.isHidden = true
        }
    }

}
