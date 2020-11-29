//
//  AccountTabViewController.swift
//  roomiesApp
//
//  Created by Rishi Jatania on 4/22/20.
//  Copyright © 2020 Rishi Jatania. All rights reserved.
//

import UIKit
import SwipeableTabBarController
class AccountTabViewController: SwipeableTabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.swipeAnimatedTransitioning?.animationType = SwipeAnimationType.push
        isCyclingEnabled = true
        minimumNumberOfTouches = 1
        // Do any additional setup after loading the view.
    }
}
