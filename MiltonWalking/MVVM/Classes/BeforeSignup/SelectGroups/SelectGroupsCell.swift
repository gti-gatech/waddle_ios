//
//  SelectGroupsCell.swift
//  MiltonWalking
//
//  Created by Krishna Datt Shukla on 07/07/20.
//  Copyright © 2020 Appzoro. All rights reserved.
//

import UIKit
import Kingfisher
class SelectGroupsCell: UITableViewCell {
    
    @IBOutlet weak var viewContainer: UIView!
    @IBOutlet weak var imageViewUser: UIImageView!
    @IBOutlet weak var labelGroupName: UILabel!
    @IBOutlet weak var labelTime: UILabel!
    @IBOutlet weak var labelNumberOfStudents: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        imageViewUser.setCornerRadius(17, borderWidth: 0, borderColor: .clear)
        viewContainer.addCornerRadiusWithShadow(color: #colorLiteral(red: 0.768627451, green: 0.768627451, blue: 0.768627451, alpha: 1), borderColor: .clear, cornerRadius: 10)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func setupCellWith(_ group: GrouopsDM) {
        self.imageViewUser?.kf.setImage(with: URL(string: imageBucket + group.image), placeholder: UIImage(named: "user_profile"))
        self.labelGroupName.text = group.groupName
        self.labelNumberOfStudents.text = "Students: \(group.totalStudents)"
        self.labelTime.text = self.chnageDateFormate(strDate: group.createdOn.components(separatedBy: ".").first ?? "")
    }
    func chnageDateFormate(strDate:String)  -> String{

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        let myDate = dateFormatter.date(from: strDate)!
        dateFormatter.dateFormat = "MM/dd/yyyy"
        return dateFormatter.string(from: myDate)
    }
}
