//
//  ChatCell.swift
//  MiltonWalking
//
//  Created by Krishna Datt Shukla on 11/08/20.
//  Copyright © 2020 Appzoro. All rights reserved.
//

import UIKit

class ChatCell: UITableViewCell {
    
    @IBOutlet weak var viewContainer: UIView!
    @IBOutlet weak var viewOnline: UIView!
    @IBOutlet weak var imageViewUser: UIImageView!
    @IBOutlet weak var labelName: UILabel!
    @IBOutlet weak var labelMessage: UILabel!
    @IBOutlet weak var labelUnreadCount: UILabel!
    @IBOutlet weak var labelTime: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        imageViewUser.setCornerRadius(imageViewUser.frame.size.height/2, borderWidth: 0, borderColor: .clear)
        viewOnline.setCornerRadius(viewOnline.frame.size.height/2, borderWidth: 2, borderColor: .white)
        labelUnreadCount.setCornerRadius(labelUnreadCount.frame.size.height/2, borderWidth: 0, borderColor: .clear)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
