//
//  BannerStruct.swift
//  Lodjinha
//
//  Created by Lucas Luz on 16/02/17.
//  Copyright © 2017 Lucas Luz. All rights reserved.
//

import Foundation

struct BannerStruct {
    var data = Array<Fields>()
    
    struct Fields
    {
        var id : Int = 0
        var urlImagem : String
        var linkUrl : String
        
        init(dict: NSDictionary) {
            id = dict.value(forKey: "id") as! Int
            urlImagem = dict.value(forKey: "urlImagem") as! String
            linkUrl = dict.value(forKey: "linkUrl") as! String
        }
    }
}
