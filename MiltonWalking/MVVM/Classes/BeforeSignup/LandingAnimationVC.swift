//
//  LandingAnimationVC.swift
//  MiltonWalking
//
//  Created by Jitendra Singh on 01/07/20.
//  Copyright © 2020 Appzoro. All rights reserved.
//

import UIKit
import Kingfisher

class LandingAnimationVC: UIViewController {

    @IBOutlet weak var imageViewAnimation: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        let path = Bundle.main.url(forResource: "Landing", withExtension: "gif")!
        let resource = LocalFileImageDataProvider(fileURL: path)
        imageViewAnimation.kf.setImage(with: resource)
         Timer.scheduledTimer(withTimeInterval: 2, repeats: false) { timer in
            self.checkIfUserLoggedIn()
         }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        navigationController?.isNavigationBarHidden = true
    }
    
    func checkIfUserLoggedIn() {
        if let _ = CommonFunctions.getUserDetailFromUserDefault() {
            setupTabBarAsRoot()
        } else {
            self.navigationController?.pushViewController(LoginSignUpVC.instantiate(fromStoryboard: .main), animated: false)
        }
    }
    
    func setupTabBarAsRoot() {
        let tabBar : CustomTabBarController = storyboardDashBoard.instantiateViewController(withIdentifier: "CustomTabBarController") as! CustomTabBarController
        AppDelegate.sharedInstance.window?.rootViewController = tabBar
        AppDelegate.sharedInstance.window?.makeKeyAndVisible()
    }
    
    func setupLoginAsRoot() {
        let login : LoginSignUpVC = storyboardMain.instantiateViewController(withIdentifier: "LoginSignUpVC") as! LoginSignUpVC
        
        let nav = UINavigationController(rootViewController: login)
        AppDelegate.sharedInstance.window?.rootViewController = nav
        AppDelegate.sharedInstance.window?.makeKeyAndVisible()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
}

