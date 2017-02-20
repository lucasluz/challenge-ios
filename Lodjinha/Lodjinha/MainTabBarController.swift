//
//  MainTabBarController.swift
//  Lodjinha
//
//  Created by Lucas Luz on 17/02/17.
//  Copyright © 2017 Lucas Luz. All rights reserved.
//

import Foundation
import UIKit

class MainTabBarController: UITabBarController, UITabBarControllerDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tabBarController?.delegate = UIApplication.shared.delegate as? UITabBarControllerDelegate
    }
    
}
