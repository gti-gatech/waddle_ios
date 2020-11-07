//
//  ParentEditCell.swift
//  MiltonWalking
//
//  Created by Jitendra Singh on 14/07/20.
//  Copyright © 2020 Appzoro. All rights reserved.
//

import UIKit

class ParentEditCell: UITableViewCell {
    static let cellIdenifier = "ParentEditCell"
        @IBOutlet weak var txtfDetail: UITextField!
        @IBOutlet weak var lblTitle: UILabel!

        var parentData:ParentDetailField?{
            didSet{
                self.setData()
            }
        }
        func setData() {
            self.lblTitle.text = self.parentData?.title
            self.txtfDetail.text = self.parentData?.value as? String
            self.txtfDetail.keyboardType = UIKeyboardType.default
        }
    }

