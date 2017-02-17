//
//  WebServicesEnum.swift
//  Lodjinha
//
//  Created by Lucas Luz on 16/02/17.
//  Copyright © 2017 Lucas Luz. All rights reserved.
//

import Foundation

enum WebServicesEnum: String {
    case urlBase = "https://alodjinha.herokuapp.com/"
    case banner = "banner"
    case categoria = "categoria"
    case produto = "produto"
    case produtosMaisVendidos = "produto/maisvendidos"
    case getProduto = "produto/1"
    case postProduto = "produto/2"
}
