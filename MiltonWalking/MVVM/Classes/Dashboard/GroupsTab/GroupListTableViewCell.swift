//
//  GroupListTableViewCell.swift
//  MiltonWalking
//
//  Created by Jitendra Singh on 17/07/20.
//  Copyright © 2020 Appzoro. All rights reserved.
//

import UIKit

class GroupListTableViewCell: UITableViewCell {
    
    @IBOutlet weak var imgvParent: UIImageView!
    @IBOutlet weak var lblStudent: UILabel!
    @IBOutlet weak var lblDistance: UILabel!
    @IBOutlet weak var lblUpcomingDate: UILabel!
    @IBOutlet weak var constraintHSuperviser: NSLayoutConstraint!
    @IBOutlet weak var lblWalkTime: UILabel!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var btnCellMenu: UIButton!
    @IBOutlet weak var viewContainer: UIView!
    @IBOutlet weak var stackViewSupervisor: UIStackView!

    static let cellIdentifier = "GroupListTableViewCell"
    override func awakeFromNib() {
        super.awakeFromNib()
        viewContainer.addCornerRadiusWithShadow(color: #colorLiteral(red: 0.768627451, green: 0.768627451, blue: 0.768627451, alpha: 1), borderColor: .clear, cornerRadius: 10)
        imgvParent.setCornerRadius(16, borderWidth: 0, borderColor: .clear)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
