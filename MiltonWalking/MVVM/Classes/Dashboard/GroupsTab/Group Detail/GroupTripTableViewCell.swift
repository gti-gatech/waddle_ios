//
//  GroupTripTableViewCell.swift
//  MiltonWalking
//
//  Created by Jitendra Singh on 29/07/20.
//  Copyright © 2020 Appzoro. All rights reserved.
//

import UIKit

class GroupTripTableViewCell: UITableViewCell {

    @IBOutlet weak var btnCellMenu: UIButton!
    @IBOutlet weak var lblPickUpStop: UILabel!
    @IBOutlet weak var stackViewISSuperviser: UIStackView!
    @IBOutlet weak var lblSuperviserNAme: UILabel!
    @IBOutlet weak var lblGroupName: UILabel!
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var viewContainer: UIView!
    
    lazy var dateFormatterServer: DateFormatter = {
        let df = DateFormatter()
        df.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        return df
    }()
    
    @IBOutlet weak var btnStart: UIButton!
    static let cellIdentifier = "GroupTripTableViewCell"
    var trips:Trip?{
        didSet{
            self.updateUI()
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        viewContainer.addCornerRadiusWithShadow(color: #colorLiteral(red: 0.768627451, green: 0.768627451, blue: 0.768627451, alpha: 1), borderColor: .clear, cornerRadius: 10)
        self.btnStart.addCornerRadiusWithShadow(color: #colorLiteral(red: 0.768627451, green: 0.768627451, blue: 0.768627451, alpha: 1), borderColor: .clear, cornerRadius: 16)
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func updateUI() {
        guard let trips = self.trips else { return }
        self.lblDate.text = "Date: " + String(trips.dueOn.split(separator: "T").first ?? "").convertDateString(fromFormat: "yyyy-MM-dd", toFormat: "MM/dd/yyyy")
        self.lblGroupName.text = trips.groupName
        self.lblSuperviserNAme.text = "Supervisor: " + (trips.supervisorName ?? "")
        self.lblPickUpStop.text = "Pickup stop: " + (trips.pickupStopName ?? "")
        self.stackViewISSuperviser.isHidden = trips.supervisorStar != 1
        self.btnStart.isHidden = true
        
        guard let dueDate = dateFormatterServer.date(from: trips.dueOn) else {
            return
        }
        let parentId = CommonFunctions.getUserDetailFromUserDefault()?.parentData.parentID
        if trips.startTripFlag == 1 && trips.supervisorID == parentId{
            btnStart.isHidden = false
            btnStart.setTitle("START TRIP", for: .normal)
            btnStart.isSelected = true
        }else if trips.status == .tripStarted && trips.supervisorID == parentId{
            btnStart.isHidden = false
            btnStart.isSelected = false
            btnStart.setTitle("COMPLETE", for: .normal)
        }
    }

}
