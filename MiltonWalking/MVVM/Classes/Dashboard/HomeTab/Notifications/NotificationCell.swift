//
//  NotificationCell.swift
//  MiltonWalking
//
//  Created by Krishna Datt Shukla on 13/07/20.
//  Copyright © 2020 Appzoro. All rights reserved.
//

import UIKit

class NotificationCell: UITableViewCell {
    
    @IBOutlet weak var viewContainer: UIView!
    @IBOutlet weak var innerView: UIView!
    @IBOutlet weak var imageViewUser: UIImageView!
    @IBOutlet weak var labelTitle: UILabel!
    @IBOutlet weak var labelTime: UILabel!


    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        imageViewUser.setCornerRadius(23.0, borderWidth: 0, borderColor: .clear)
        viewContainer.dropShadow()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
