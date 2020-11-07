//
//  PrentSelectStopCell.swift
//  MiltonWalking
//
//  Created by Jitendra Singh on 14/07/20.
//  Copyright © 2020 Appzoro. All rights reserved.
//

import UIKit

class PrentSelectStopCell: UITableViewCell {
    
    @IBOutlet weak var lblTitle: UILabel!
    static let cellIdenifier = "PrentSelectStopCell"
    var parentData:ParentDetailField?{
        didSet{
            self.setData()
        }
    }
    func setData() {
        guard let name = (self.parentData?.value as? SelectStopMapDM)?.name, !name.isEmpty else { return  }
        self.lblTitle.text = name
    }
}
