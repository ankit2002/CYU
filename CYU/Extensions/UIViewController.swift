//
//  NavBarExtension.swift
//  CYU
//
//  Created by Ankit Mishra on 07/07/17.
//  Copyright © 2017 Ankit Mishra. All rights reserved.
//

import UIKit

extension UIViewController {
    
    // Doing for the Left bar only and removing Right Bar
    
    // To Set
    func setNavigationBarItem() {
        self.addLeftBarButtonWithImage(UIImage(named: "menu_btn")!)
        self.slideMenuController()?.removeLeftGestures()
        self.slideMenuController()?.addLeftGestures()
    }
    
    
    // To remove
    func removeNavigationBarItem() {
        self.navigationItem.leftBarButtonItem = nil
        self.slideMenuController()?.removeLeftGestures()
    }
    
}
