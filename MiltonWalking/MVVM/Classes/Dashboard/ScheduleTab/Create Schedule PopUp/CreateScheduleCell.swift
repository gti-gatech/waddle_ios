//
//  CreateScheduleCell.swift
//  MiltonWalking
//
//  Created by Jitendra Singh on 20/07/20.
//  Copyright © 2020 Appzoro. All rights reserved.
//

import UIKit

class CreateScheduleCell: UICollectionViewCell {
    
    @IBOutlet weak var lblTitle: UILabel!
    static let cellIdentifier = "CreateScheduleCell"
    
    func setUI(title:String, isSelected:Bool)  {
        self.lblTitle.text = title
        if isSelected{
            self.lblTitle.font = UIFont(name: "HelveticaNeue-Medium", size: 14)
            self.lblTitle.textColor = UIColor.white
            self.lblTitle.backgroundColor = UIColor(red: 242/255, green: 102/255, blue: 39/255, alpha: 1)
        }else{
            self.lblTitle.font = UIFont(name: "HelveticaNeue-Light", size: 14)
            self.lblTitle.textColor = UIColor(red: 242/255, green: 102/255, blue: 39/255, alpha: 0.7)
            self.lblTitle.backgroundColor = UIColor.white
        }
    }
}
