//
//  ParentTrackingStudentCell.swift
//  MiltonWalking
//
//  Created by Jitendra Singh on 06/08/20.
//  Copyright © 2020 Appzoro. All rights reserved.
//

import UIKit

class ParentTrackingStudentCell: UITableViewCell {
    
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var btnSelection: UIButton!
    @IBOutlet weak var btnCall: UIButton!
    static let cellIdentifier = "ParentTrackingStudentCell"
    var tripData:TripMap?{
        didSet{
            self.updateUI()
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func updateUI()  {
        guard let tripData = self.tripData else { return }
        self.lblName.text = tripData.studentName
        self.btnSelection.isSelected = !(tripData.status == "NOT_PICKED")
    }
}
