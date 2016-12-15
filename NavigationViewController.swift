//
//  NavigationViewController.swift
//  HourLogger
//
//  Created by Jace McPherson on 5/21/16.
//  Copyright © 2016 jacemcpherson. All rights reserved.
//

import Foundation
import UIKit

class NavigationController : UINavigationController {
    override func viewDidLoad() {
        navigationBar.barTintColor = UIColor.init(red: 0.0, green: 0.4453, blue: 0.734, alpha: 1.0)
        navigationBar.titleTextAttributes = [NSForegroundColorAttributeName : UIColor.whiteColor()]
        navigationBar.tintColor = UIColor.whiteColor()
        setNeedsStatusBarAppearanceUpdate()
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent
    }
}