//
//  ParentViewTableViewCell.swift
//  MiltonWalking
//
//  Created by Jitendra Singh on 28/08/20.
//  Copyright © 2020 Appzoro. All rights reserved.
//

import UIKit

class ParentViewTableViewCell: UITableViewCell {
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var viewCircle: UIView!
    @IBOutlet weak var viewSuper: UIView!
    static let cellIdentifier = "ParentViewTableViewCell"
    
    
    @IBOutlet weak var lblTime: UILabel!
    @IBOutlet weak var lblDistance: UILabel!

    
    override func awakeFromNib() {
        super.awakeFromNib()
        viewCircle.setCornerRadius(6.5, borderWidth: 0, borderColor: .clear)
    }
   

    func updateUI(studentName:String, stopName:String, distance:String, time:String, status:Bool)  {
        self.lblName.text = studentName
        viewCircle.backgroundColor = status ? UIColor.green : UIColor.white
        self.lblTime.text = stopName
    }
}
