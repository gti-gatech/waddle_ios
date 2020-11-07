//
//  ChatInputView.swift
//  MiltonWalking
//
//  Created by Krishna Datt Shukla on 14/08/20.
//  Copyright © 2020 Appzoro. All rights reserved.
//

import UIKit

class ChatInputView: UIView {
    
    // this is needed so that the inputAccesoryView is properly sized from the auto layout constraints
    // actual value is not important
    
    override var intrinsicContentSize: CGSize {
        return CGSize.zero
    }
    
    override func didMoveToWindow() {
        super.didMoveToWindow()
        if #available(iOS 11.0, *) {
            if UIScreen.main.bounds.height > 800 {
                if let window = self.window {
                    self.bottomAnchor.constraint(lessThanOrEqualToSystemSpacingBelow: window.safeAreaLayoutGuide.bottomAnchor, multiplier: 1.0).isActive = true
                }
            }
        }
    }
}
