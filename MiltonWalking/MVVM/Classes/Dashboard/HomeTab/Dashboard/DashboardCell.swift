//
//  DashboardCell.swift
//  MiltonWalking
//
//  Created by Krishna Datt Shukla on 10/07/20.
//  Copyright © 2020 Appzoro. All rights reserved.
//

import UIKit

class DashboardCell: UITableViewCell {
    
    @IBOutlet weak var labelStudent: UILabel!
    @IBOutlet weak var labelDate: UILabel!
    @IBOutlet weak var labelStop: UILabel!
    @IBOutlet weak var labelSupervisor: UILabel!
    @IBOutlet weak var viewContainer: UIView!
    @IBOutlet weak var stackViewSupervisor: UIStackView!

    @IBOutlet weak var labelGroup: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        viewContainer.addCornerRadiusWithShadow(color: #colorLiteral(red: 0.768627451, green: 0.768627451, blue: 0.768627451, alpha: 1), borderColor: .clear, cornerRadius: 10)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
