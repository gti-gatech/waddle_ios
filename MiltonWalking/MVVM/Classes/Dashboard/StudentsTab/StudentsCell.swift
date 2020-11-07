//
//  StudentsCell.swift
//  MiltonWalking
//
//  Created by Krishna Datt Shukla on 18/07/20.
//  Copyright © 2020 Appzoro. All rights reserved.
//

import UIKit

class StudentsCell: UICollectionViewCell {
    @IBOutlet weak var viewContainer: UIView!
    @IBOutlet weak var viewGradient: UIView!
    @IBOutlet weak var viewImage: UIView!
    @IBOutlet weak var imageViewUser: UIImageView!
    @IBOutlet weak var labelName: UILabel!
    @IBOutlet weak var labelPickup: UILabel!
    @IBOutlet weak var labelYear: UILabel!


    override func awakeFromNib() {
        viewContainer.setCornerRadius(10.0, borderWidth: 0.0, borderColor: .clear)
        viewImage.setCornerRadius(29.0, borderWidth: 5.0, borderColor: .white)
        imageViewUser.setCornerRadius(26.5, borderWidth: 0.0, borderColor: .clear)
        viewGradient.createGradientLayerWith(colors: [COLOR_LIGHT_ORANGE.cgColor, COLOR_PRIMARY_ORANGE.cgColor])
    }
    
    
}
