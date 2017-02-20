//
//  RequestService.swift
//  Lodjinha
//
//  Created by Lucas Luz on 15/02/17.
//  Copyright © 2017 Lucas Luz. All rights reserved.
//

import Foundation
import UIKit

class RequestService {
    
    func getJSONData(dataType: String, structure: Any, view: ViewControllerProtocol) -> Void {
        let queue = DispatchQueue.global(qos: .background)
        var time:DispatchTime! {
            return DispatchTime.now() + 1.0
        }
        
        let sessionConfiguration = URLSessionConfiguration.default
        let session = URLSession(configuration: sessionConfiguration)
        
        queue.async {
            // start queue
            
            if let url = URL(string: WebServicesEnum.urlBase.rawValue.appending(dataType)) {
                let task = session.dataTask(with: url, completionHandler: {
                    data, response, error in
                    
                    if let e = error {
                        print("Error let task:  \(e.localizedDescription)")
                        return
                    }
                    
                    if let d = data, let dataStr = String(data: d, encoding: .utf8) {
                        // Got data
                        
                        if let json = self.self.parseJSON(from: d, s: structure) {
                            
                            switch structure {
                                case is BannerStruct.Type:
                                    DispatchQueue.main.asyncAfter(deadline: time, execute: {
                                        view.putBanners(bs: json as! BannerStruct)
                                    })
                                    
                                    break
                                    
                                case is CategoryStruct.Type:
                                    DispatchQueue.main.asyncAfter(deadline: time, execute: {
                                        view.putCategories(cat: json as! CategoryStruct)
                                    })
                                    break
                                
                                case is TopSeller.Type:
                                    DispatchQueue.main.asyncAfter(deadline: time, execute: {
                                        view.putTopSellers(ts: json as! TopSeller)
                                    })
                                    break
                                
                                case is ProductsByCategoryStruct.Type:
                                    DispatchQueue.main.asyncAfter(deadline: time, execute: {
                                        view.putProductsByCategory(pc: json as! ProductsByCategoryStruct)
                                    })
                                break
                                
                                case is ProductStruct.Type:
                                    DispatchQueue.main.asyncAfter(deadline: time, execute: {
                                        view.putProduct(ps: json as! ProductStruct)
                                    })
                                    break
                                
                                default: break
                            }

                        } else {
                            print("ERRO JSON: \(dataStr)")
                            print("Error parsing json")
                        }
                    } else {
                        print("\(queue.label): No data")
                    }
                    
                })
                
                task.resume()

                
            } else {
                print("\(queue.label): URL error")
            }
        }
    }
    
    func postJSONData(dataType: String, structure: Any, view: ViewControllerProtocol) -> Void {
        var request = URLRequest(url: URL(string: dataType)!)
        request.httpMethod = "POST"
        request.httpBody = "".data(using: .utf8)
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                print("error=\(error)")
                return
            }
            
            if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200
            {
                print("statusCode code \(httpStatus.statusCode)")
                print("response = \(response)")
            }
            
            let responseString = String(data: data, encoding: .utf8)
            print("responseString = \(responseString)")
            
            if("\(responseString)".contains("success")) {
                let result = ReservaStruct()
                view.postProduct(re: result)
            }
            
        }
        task.resume()
    }

    
    func parseJSON(from data: Data, s: Any) -> Any? {
        do {
            let json = try JSONSerialization.jsonObject(with: data) as! [String: Any]
            
            switch s {
                case is BannerStruct.Type:
                    return self.getBanners(jsonArray: json)
                
                case is CategoryStruct.Type:
                    return self.getCategories(jsonArray: json)
                
                case is TopSeller.Type:
                    return self.getTopSellers(jsonArray: json)
                
                case is ProductsByCategoryStruct.Type:
                    return self.getProductsByCategory(jsonArray: json)
                
                case is ProductStruct.Type:
                    return self.getProduct(jsonArray: json)
                
                case is ReservaStruct.Type:
                    return self.getReserva(jsonArray: json)
                
                default:
                print("service undefined")
                return nil
            }
        }catch{
            print("Error JSONSerialization")
            return nil
        }
    }
    
    
    func getBanners(jsonArray: [String: Any]) -> BannerStruct? {
        var bs = BannerStruct()
        
        for f in jsonArray["data"] as! NSArray {
            let bsFields = BannerStruct.Fields.init(dict: f as! NSDictionary)
            bs.data.append(bsFields)
        }
        
        return bs
    }
    
    func getCategories(jsonArray: [String: Any]) -> CategoryStruct? {
        var cat = CategoryStruct()
        
        for f in jsonArray["data"] as! NSArray {
            let catFields = CategoryStruct.Fields.init(dict: f as! NSDictionary)
            cat.data.append(catFields)
        }
        
        return cat
    }
    
    func getTopSellers(jsonArray: [String: Any]) -> TopSeller? {
        var ts = TopSeller()
        
        for f in jsonArray["data"] as! NSArray {
            let tsFields = TopSeller.Fields.init(dict: f as! NSDictionary)
            ts.data.append(tsFields)
        }
        
        return ts
    }
    
    func getProductsByCategory(jsonArray: [String: Any]) -> ProductsByCategoryStruct? {
        var pc = ProductsByCategoryStruct()
        
        for f in jsonArray["data"] as! NSArray {
            let pcFields = ProductsByCategoryStruct.Fields.init(dict: f as! NSDictionary)
            pc.data.append(pcFields)
        }
        
        return pc
    }
    
    func getProduct(jsonArray: [String: Any]) -> ProductStruct? {
        var ps = ProductStruct()
        
        for f in jsonArray["data"] as! NSArray {
            let psFields = ProductStruct.Fields.init(dict: f as! NSDictionary)
            ps.data.append(psFields)
        }
        
        return ps
    }
    
    func getReserva(jsonArray: [String: Any]) -> ReservaStruct? {
        var re = ReservaStruct()
        
        re.response = jsonArray["result"] as! String
        
        return re
    }
    
}
