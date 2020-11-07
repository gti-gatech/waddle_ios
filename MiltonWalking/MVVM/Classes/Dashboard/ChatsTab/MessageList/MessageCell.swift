//
//  MessageCell.swift
//  MiltonWalking
//
//  Created by Krishna Datt Shukla on 14/08/20.
//  Copyright © 2020 Appzoro. All rights reserved.
//

import UIKit

class MessageCell: UITableViewCell {
    
    @IBOutlet weak var viewContainer: UIView!
    @IBOutlet weak var labelMessage: UILabel!
    @IBOutlet weak var labelTime: UILabel!

    lazy var dateFormatterServer: DateFormatter = {
        let df = DateFormatter()
        df.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
//        df.timeZone = TimeZone(abbreviation: "GMT-4")
        return df
    }()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        viewContainer.setCornerRadius(5.0, borderWidth: 0, borderColor: .clear)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func setupCellWith(message: MessageList) {
        labelMessage.text = message.message
        var strDate = message.createdOn
        if message.createdOn.contains("."){
            strDate = String(strDate.split(separator: ".").first ?? "")
        }
        guard let date = dateFormatterServer.date(from: strDate) else {
            labelTime.text = ""
            return
        }
        let name = (message.senderName.split(separator: " ").first) ?? ""
        if Date().isSameAs(date) {
            let df = DateFormatter()
            df.dateFormat = "HH:mm a"
            labelTime.text =  name + " " + df.string(from: date)
        } else {
            let df = DateFormatter()
            df.dateFormat = "MM/dd/yyyy"
            labelTime.text = name + " " + df.string(from: date)
        }
    }
}
