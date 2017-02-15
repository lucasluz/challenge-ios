//
//  ViewController.swift
//  Lodjinha
//
//  Created by Lucas Luz on 15/02/17.
//  Copyright © 2017 Lucas Luz. All rights reserved.
//

import UIKit


extension UIApplication {
    var statusBarView: UIView {
        return (value(forKey: "statusBar") as? UIView)!
    }
}

class ViewController: UIViewController {
    
    @IBOutlet var navBar: UINavigationBar!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set color of navigation bar
        navBar?.isTranslucent = false
        navBar?.isOpaque = true
        UIApplication.shared.statusBarView.backgroundColor = navBar?.backgroundColor
        
        // Set navigation bar logo
//        navBar?.setBackgroundImage(UIImage.init(named: "logoNavbar"), for: .topAttached, barMetrics: .default)
//        navBar?.sizeToFit()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        UIApplication.shared.statusBarStyle = UIStatusBarStyle.default
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}





