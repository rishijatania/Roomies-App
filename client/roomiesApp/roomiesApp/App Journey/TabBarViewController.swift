//
//  TabBarViewController.swift
//  roomiesApp
//
//  Created by Rishi Jatania on 4/20/20.
//  Copyright © 2020 Rishi Jatania. All rights reserved.
//

import UIKit
import SwipeableTabBarController
class TabBarViewController: SwipeableTabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.swipeAnimatedTransitioning?.animationType = SwipeAnimationType.push
        isCyclingEnabled = true
        minimumNumberOfTouches = 3
    }
}
