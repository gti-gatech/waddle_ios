//
//  SideMenuTableViewCell.swift
//  MiltonWalking
//
//  Created by Jitendra Singh on 10/07/20.
//  Copyright © 2020 Appzoro. All rights reserved.
//

import UIKit

class SideMenuTableViewCell: UITableViewCell {
    @IBOutlet weak var imgView: UIImageView!
    
    @IBOutlet weak var lblTitle: UILabel!
    
    static let cellIdentifier = "SideMenuTableViewCell"
    var data:SideMenuField?{
        didSet{
            self.setData()
        }
    }
    func setData() {
        guard let data = self.data else { return }
        self.imgView.image = data.icon
        self.lblTitle.text = data.title
    }
}
