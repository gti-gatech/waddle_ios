//
//  SelectStudentsCell.swift
//  MiltonWalking
//
//  Created by Krishna Datt Shukla on 07/07/20.
//  Copyright © 2020 Appzoro. All rights reserved.
//

import UIKit

class SelectStudentsCell: UITableViewCell {
    
    @IBOutlet weak var viewContainer: UIView!
    @IBOutlet weak var lblStudentName: UILabel!
    @IBOutlet weak var lblSchoolName: UILabel!
    @IBOutlet weak var btnStatus: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        viewContainer.addCornerRadiusWithShadow(color: #colorLiteral(red: 0.768627451, green: 0.768627451, blue: 0.768627451, alpha: 1), borderColor: .clear, cornerRadius: 10)
    }

    func setupCellWith(_ students: StudentDM, selectionStatus:Bool) {
        self.lblStudentName.text = students.fullName
        self.lblSchoolName.text = students.grade
        self.btnStatus.isSelected = selectionStatus
    }
    
}
