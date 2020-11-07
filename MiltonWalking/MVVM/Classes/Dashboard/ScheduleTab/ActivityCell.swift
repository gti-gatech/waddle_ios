//
//  ActivityCell.swift
//  MiltonWalking
//
//  Created by Krishna Datt Shukla on 16/07/20.
//  Copyright © 2020 Appzoro. All rights reserved.
//

import UIKit

class ActivityCell: UITableViewCell {

    @IBOutlet weak var viewContainer: UIView!
    @IBOutlet weak var labelTitle: UILabel!
    @IBOutlet weak var labelTime: UILabel!
    @IBOutlet weak var labelStudent: UILabel!
    @IBOutlet weak var labelSupervisor: UILabel!
    @IBOutlet weak var btnCellMenu: UIButton!
    @IBOutlet weak var stackViewSupervisor: UIStackView!
    @IBOutlet weak var buttonMenu: UIButton!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
