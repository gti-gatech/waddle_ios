//
//  AddStudentDetailTableViewCell.swift
//  MiltonWalking
//
//  Created by Jitendra Singh on 06/07/20.
//  Copyright © 2020 Appzoro. All rights reserved.
//

import UIKit

class AddStudentDetailTableViewCell: UITableViewCell {
    
    @IBOutlet weak var btnEdit: UIButton!
    @IBOutlet weak var txtfDetail: UITextField!
    @IBOutlet weak var lblTitle: UILabel!
    static let cellIdentifier = "AddStudentDetailTableViewCell"
    var studentData:StudentDetailField?{
        didSet{
            self.setData()
        }
    }
    func setData() {
        self.lblTitle.text = self.studentData?.title
        self.txtfDetail.placeholder = self.studentData?.placeholder
        self.txtfDetail.text = self.studentData?.value as? String ?? ""
        self.txtfDetail.keyboardType = UIKeyboardType.default
    }
}
