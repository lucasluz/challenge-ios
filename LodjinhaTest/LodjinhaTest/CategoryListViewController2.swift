//
//  CategoryListViewController.swift
//  LodjinhaTest
//
//  Created by Lucas Luz on 17/02/17.
//  Copyright © 2017 Lucas Luz. All rights reserved.
//

import Foundation
import UIKit

class CategoryListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var pcTmp = ProductsByCategoryStruct()
//    var delegate = FirstViewController!.self
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        navBar.backItem?.setHidesBackButton(false, animated: false)
//        navBar.backItem?.setLeftBarButton(backButton, animated: false)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return pcTmp.data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let element = pcTmp.data.first
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "ElementCell")
        cell.textLabel?.text = element?.nome
        cell.detailTextLabel?.text = "\(element?.precoDe)"
        
        return cell
    }
    
}
