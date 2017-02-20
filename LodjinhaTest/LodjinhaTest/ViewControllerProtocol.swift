//
//  FirstViewController.swift
//  LodjinhaTest
//
//  Created by Lucas Luz on 17/02/17.
//  Copyright © 2017 Lucas Luz. All rights reserved.
//

import Foundation


protocol ViewControllerProtocol {
    
    func putBanners(bs: BannerStruct) -> Void
    
    func putCategories(cat: CategoryStruct) -> Void
    
    func putTopSellers(ts: TopSeller) -> Void
    
    func putProductsByCategory(pc : ProductsByCategoryStruct) -> Void
    
    func putProduct(ps : ProductStruct) -> Void
    
    func postProduct(re : ReservaStruct) -> Void
    
}
