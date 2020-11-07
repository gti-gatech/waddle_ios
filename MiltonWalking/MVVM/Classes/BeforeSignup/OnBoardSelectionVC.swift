//
//  OnBoardSelectionVC.swift
//  MiltonWalking
//
//  Created by Jitendra Singh on 06/07/20.
//  Copyright © 2020 Appzoro. All rights reserved.
//

import UIKit

class OnBoardSelectionVC: UIViewController {
    
    @IBOutlet weak var btnSkip: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        btnSkip.setCornerRadius(20, borderWidth: 1, borderColor: #colorLiteral(red: 0.4392156863, green: 0.4392156863, blue: 0.4392156863, alpha: 1))
        CommonFunctions.setLeftBarButtonItemWith(image: #imageLiteral(resourceName: "back"), action: #selector(backButtonAction), view: self)
    }
    
    @IBAction func backButtonAction() {
        navigationController?.popViewController(animated: true)
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupNavigation(isToHide: true)
    }
    
    @IBAction func btnSkipClicked(_ sender: Any) {
        setupNavigation(isToHide: true)
        AppDelegate.sharedInstance.setupTabBarAsRoot()
    }
    
    func setupNavigation(isToHide:Bool) {
        self.navigationController?.setNavigationBarHidden(isToHide, animated: true)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        setupNavigation(isToHide: false)
    }
}
