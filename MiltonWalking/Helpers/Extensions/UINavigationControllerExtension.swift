//
//  UINavigationControllerExtension.swift
//  MiltonWalking
//
//  Created by Jitendra Singh on 03/07/20.
//  Copyright © 2020 Appzoro. All rights reserved.
//

import UIKit

extension UINavigationController {
    
    func setTransparentNavigationBar() {
        navigationBar.setBackgroundImage(UIImage(), for: .default) //UIImage.init(named: "transparent.png")
        navigationBar.shadowImage = UIImage()
        navigationBar.isTranslucent = true
        view.backgroundColor = .clear
        let attributes = [NSAttributedString.Key.font: UIFont(name: "HelveticaNeue-Light", size: 18)!, NSAttributedString.Key.foregroundColor : UIColor(red: 22/255, green: 31/255, blue: 61/255, alpha: 1)]
        UINavigationBar.appearance().titleTextAttributes = attributes
    }
    
    func backToNormalNavigationBar() {
        self.navigationController?.navigationBar.setBackgroundImage(nil, for: UIBarMetrics.default)
        navigationBar.shadowImage = UIImage()
        navigationBar.isTranslucent = false
    }
    
    func setupNavigationController() {
        navigationBar.shadowImage = UIImage()
        navigationBar.setBackgroundImage(UIImage(), for: .default) //UIImage.init(named: "transparent.png")
    }
}
