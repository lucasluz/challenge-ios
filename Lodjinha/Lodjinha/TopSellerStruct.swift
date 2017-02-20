//
//  TopSellerStruct.swift
//  Lodjinha
//
//  Created by Lucas Luz on 17/02/17.
//  Copyright © 2017 Lucas Luz. All rights reserved.
//

import Foundation

struct TopSeller {
    var data = Array<Fields>()
    
    struct Fields
    {
        var id : Int
        var nome : String
        var urlImagem : String
        var descricao : String
        var precoDe : Double
        var precoPor : Double
        var categorias : NSDictionary
        
        init(dict: NSDictionary) {
            id = dict.value(forKey: "id") as! Int
            nome = dict.value(forKey: "nome") as! String
            urlImagem = dict.value(forKey: "urlImagem") as! String
            descricao = dict.value(forKey: "descricao") as! String
            precoDe = dict.value(forKey: "precoDe") as! Double
            precoPor = dict.value(forKey: "precoPor") as! Double
            categorias = dict.value(forKey: "categoria") as! NSDictionary
        }
    }
    
}
