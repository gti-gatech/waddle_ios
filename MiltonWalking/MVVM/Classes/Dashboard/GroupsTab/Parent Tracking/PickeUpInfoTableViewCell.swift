//
//  PickeUpInfoTableViewCell.swift
//  MiltonWalking
//
//  Created by Jitendra Singh on 28/08/20.
//  Copyright © 2020 Appzoro. All rights reserved.
//

import UIKit

class PickeUpInfoTableViewCell: UITableViewCell {
    static let cellIdentifier = "PickeUpInfoTableViewCell"
    @IBOutlet weak var viewSuper: UIView!
    @IBOutlet weak var lblDistanceNext: UILabel!
    @IBOutlet weak var lblStudentNumber: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        viewSuper.setCornerRadius(3, borderWidth: 0, borderColor: .clear)
    }
    func updateUI(studentNumber:String, distance:String) {
        self.lblStudentNumber.text = studentNumber
        self.lblDistanceNext.text = distance
    }
}
