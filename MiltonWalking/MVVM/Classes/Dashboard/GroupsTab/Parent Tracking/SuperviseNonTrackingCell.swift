//
//  SuperviseNonTrackingCell.swift
//  MiltonWalking
//
//  Created by Jitendra Singh on 01/09/20.
//  Copyright © 2020 Appzoro. All rights reserved.
//

import UIKit

class SuperviseNonTrackingCell: UITableViewCell {
    static let cellIdentifier = "SuperviseNonTrackingCell"
    
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblStop: UILabel!
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
        lblStop.text = tripData.stopName
    }
    
}
