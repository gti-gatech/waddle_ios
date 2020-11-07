//
//  AllSetOnBoardVC.swift
//  MiltonWalking
//
//  Created by Jitendra Singh on 08/07/20.
//  Copyright © 2020 Appzoro. All rights reserved.
//

import UIKit

class AllSetOnBoardVC: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigation()
        navigationController?.interactivePopGestureRecognizer?.isEnabled = false
    }
    func setupNavigation() {
        CommonFunctions.setLeftBarButtonItemWith(image: #imageLiteral(resourceName: "back"), action: #selector(backButtonAction), view: self)
    }
    
    @IBAction func backButtonAction() {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func doneButtonAction() {
        AppDelegate.sharedInstance.setupTabBarAsRoot()
    }

}
