//
//  CategoriesStruct.swift
//  Lodjinha
//
//  Created by Lucas Luz on 17/02/17.
//  Copyright © 2017 Lucas Luz. All rights reserved.
//

import Foundation

struct CategoryStruct {
    var data = Array<Fields>()
    
    struct Fields
    {
        var id : Int = 0
        var descricao : String
        var urlImagem : String
    
        init(dict: NSDictionary) {
            id = dict.value(forKey: "id") as! Int
            descricao = dict.value(forKey: "descricao") as! String
            urlImagem = dict.value(forKey: "urlImagem") as! String
        }
    }

}
