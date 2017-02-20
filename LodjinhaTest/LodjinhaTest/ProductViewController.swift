//
//  ProductViewController.swift
//  LodjinhaTest
//
//  Created by Lucas Luz on 19/02/17.
//  Copyright © 2017 Lucas Luz. All rights reserved.
//

import UIKit

class ProductViewController: UIViewController, ViewControllerProtocol {

    @IBOutlet var navBar: UINavigationBar!
    @IBOutlet var productImage: UIImageView!
    @IBOutlet var productName: UILabel!
    @IBOutlet var productPrecoDe: UILabel!
    @IBOutlet var productPrecoPor: UILabel!
    @IBOutlet var productDescription: UITextView!
    var productId: Int!
    
    @IBAction func backButton(_ sender: UIBarButtonItem) {
        navigationController?.popViewController(animated: true)
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func btReservar(_ sender: UIButton) {
//        let dialog = UIAlertAction(title: "Produto reservado com sucesso", style: UIAlertActionStyle.default, handler: nil)
        
//        self.presentedViewController.
//        presentedViewController(dialog, true, nil)
        // create Request for all webservices
//        let rs = RequestService()
        
        // Post
//        let url = WebServicesEnum.produto.rawValue.appending("/\(productId)")
//        rs.getJSONData(dataType: url, structure: ReservaStruct.self, view: self)
    }
    
    public func postProduct(re: ReservaStruct) {
        if(re.response == "success") {
            let dialog = UIAlertAction(title: "Produto reservado com sucesso", style: UIAlertActionStyle.default, handler: nil)
        } else {
            let dialog = UIAlertAction(title: "Erro ao reservar produto", style: UIAlertActionStyle.default, handler: nil)
        }
    }
    
    
    var valuesToReceiveProduct = Array<String>()
    var productCell : TopSellersViewCell!
    var productCategoryCell : ProductsByCategoryViewCell!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        productName.text = productCell != nil ? productCell.productName.text : productCategoryCell.productName.text
        
        productPrecoDe.text = "De: \(productCell != nil ? productCell.productOldPrice.text! : productCategoryCell.productOldPrice.text!)"
        
        productPrecoPor.text = "Por: \(productCell != nil ? productCell.productNewPrice.text! : productCategoryCell.productNewPrice.text!)"
        
        productDescription.text = (productCell != nil) ? productCell.descricao : productCategoryCell.descricao
            
        productImage.image = (productCell != nil) ? productCell.productImage.image : productCategoryCell.productImage.image
        
        productId = (productCell != nil) ? productCell.id : productCategoryCell.id

    }
    
    func downloadImage(urlRequested: String) -> UIImage {
        if let url = NSURL(string: urlRequested) {
            if let data = NSData(contentsOf: url as URL) {
                return UIImage(data: data as Data)!
            }
        }
        
        return UIImage.init()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    public func putProduct(ps: ProductStruct) {
        
    }
    
    // Do nothing
    public func putBanners(bs: BannerStruct) {}
    
    public func putCategories(cat: CategoryStruct) {}
    
    public func putTopSellers(ts: TopSeller) {}
    
    public func putProductsByCategory(pc: ProductsByCategoryStruct) {}

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
