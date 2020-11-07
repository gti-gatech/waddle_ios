//
//  SchecduleSuccessPopUpVC.swift
//  MiltonWalking
//
//  Created by Jitendra Singh on 11/09/20.
//  Copyright © 2020 Appzoro. All rights reserved.
//

import UIKit

class SchecduleSuccessPopUpVC: UIViewController {
    
    var btnDoneClicked:(() -> Void)?
    var supervising = 0
    var alreadySupervised = 0
    var message = ""
    @IBOutlet weak var btnDone: UIButton!
        @IBOutlet weak var viewSuper: UIView!
    @IBOutlet weak var lblsupervising: UILabel!
    @IBOutlet weak var lblAlreadySupervised: UILabel!
    @IBOutlet weak var lblMessage: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.btnDone.setCornerRadius(3, borderWidth: 0.3, borderColor: .clear)
               self.viewSuper.setCornerRadius(15, borderWidth: 0.3, borderColor: .clear)
//        self.lblsupervising.text = "\(supervising)"
//        self.lblAlreadySupervised.text = "\(alreadySupervised)"
        self.lblMessage.text = message
    }
    
    @IBAction func btnDoneClicked(_ sender: Any) {
        self.btnDoneClicked?()
        self.dismiss(animated: true, completion: nil)
    }
}
