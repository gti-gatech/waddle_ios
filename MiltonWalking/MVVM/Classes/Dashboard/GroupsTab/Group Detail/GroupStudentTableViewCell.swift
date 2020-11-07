//
//  GroupStudentTableViewCell.swift
//  MiltonWalking
//
//  Created by Jitendra Singh on 29/07/20.
//  Copyright © 2020 Appzoro. All rights reserved.
//

import UIKit

class GroupStudentTableViewCell: UITableViewCell {

    static let cellIdentifier = "GroupStudentTableViewCell"
    @IBOutlet weak var lblStop: UILabel!
    @IBOutlet weak var lblGrade: UILabel!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var viewContainer: UIView!
    var studentData: GroupStudent? {
        didSet{
            self.updateUI()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        viewContainer.addCornerRadiusWithShadow(color: #colorLiteral(red: 0.768627451, green: 0.768627451, blue: 0.768627451, alpha: 1), borderColor: .clear, cornerRadius: 10)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func updateUI() {
        guard let studentData = self.studentData else { return }
        self.lblName.text = studentData.fullName
        self.lblGrade.text = "Grade: " + studentData.grade
        self.lblStop.text = "Default Stop: " + (studentData.stopName ?? "")
    }
}
