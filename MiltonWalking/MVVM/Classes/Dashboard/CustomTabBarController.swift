//
//  CustomTabBarController.swift
//  MiltonWalking
//
//  Created by Krishna Datt Shukla on 09/07/20.
//  Copyright © 2020 Appzoro. All rights reserved.
//

import UIKit

class CustomTabBarController: UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
    }
}

extension CustomTabBarController:UITabBarControllerDelegate{
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
//        if (viewController as? UINavigationController)?.viewControllers.first?.isKind(of: ChatsVC.self) ?? false{
//            return false
//        }
        return true
    }
}
