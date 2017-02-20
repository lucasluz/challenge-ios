//
//  CategoryListWrapperViewController.swift
//  LodjinhaTest
//
//  Created by Lucas Luz on 19/02/17.
//  Copyright © 2017 Lucas Luz. All rights reserved.
//

import UIKit

class ProductsByCategoryViewCell: UITableViewCell {
    @IBOutlet var productImage: UIImageView!
    @IBOutlet var productName: UILabel!
    @IBOutlet var productOldPrice: UILabel!
    @IBOutlet var productNewPrice: UILabel!
    var descricao : String!
    var categoria : String!
    var id: Int = 0
}

class CategoryListWrapperViewController: UIViewController, ViewControllerProtocol, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet var productsListTableView: UITableView!
    @IBOutlet var navBar: UINavigationBar!
    
    @IBAction func backButton(_ sender: UIBarButtonItem) {
        navigationController?.popViewController(animated: true)
        dismiss(animated: true, completion: nil)
    }
    
    var offset : Int = 0
    let limit : Int = 20
    var categoryId : Int = 1
    var categoryName = String()
    var productsCount : Int = 0
    var pcTmp: ProductsByCategoryStruct!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        productsListTableView.delegate = self
        productsListTableView.dataSource = self

        loadProducts();
    }
    
    public func loadProducts() {
        // create Request for all webservices
        let rs = RequestService()

        // Request top sellers
        let url = WebServicesEnum.produto.rawValue.appending("?offset=\(offset)&limit=\(limit)&categoriaId=\(categoryId)")
        rs.getJSONData(dataType: url, structure: ProductsByCategoryStruct.self, view: self)
    }
    
    public func putProductsByCategory(pc: ProductsByCategoryStruct) {
        if(pc.data.count > 0) {
            pcTmp = pc
            productsCount = pc.data.count
            
            productsListTableView.reloadData()
            productsListTableView.layoutIfNeeded()
            productsListTableView.setNeedsLayout()
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        print("prepare segue: \(segue.identifier)")
        
        if(segue.identifier == "showProductSegue") {
            let nextView = segue.destination as? ProductViewController
            let indexPath = self.productsListTableView.indexPathForSelectedRow
            let selectedProduct = self.productsListTableView.cellForRow(at: indexPath!)
            nextView?.productCategoryCell = selectedProduct as! ProductsByCategoryViewCell
        }
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return productsCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: "productsReusableCell", for: indexPath) as! ProductsByCategoryViewCell
        
        let pimage = downloadImage(urlRequested: pcTmp.data[indexPath.row].urlImagem)
        cell.productImage?.image = pimage
        
        let tmp : ProductsByCategoryStruct.Fields = pcTmp.data[indexPath.row]
        
        cell.productName?.text = tmp.nome
        cell.productOldPrice?.text = "De: \(tmp.precoDe)"
        cell.productNewPrice?.text = "Por: \(tmp.precoPor)"
        cell.id = tmp.id
        cell.descricao = tmp.descricao
        cell.categoria = ""
        
        for c in tmp.categorias {
            if (c.key as! String) == "categoria" {
                cell.categoria = (c.value as! String)
                break
            }
        }
        
        cell.isUserInteractionEnabled = true
        
        return cell
    }
    
    func downloadImage(urlRequested: String) -> UIImage {
        if let url = NSURL(string: urlRequested) {
            if let data = NSData(contentsOf: url as URL) {
                return UIImage(data: data as Data)!
            }
        }
        
        return UIImage.init()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100.0;
    }
    
    // Do nothing
    public func putBanners(bs: BannerStruct) {}
    
    public func putCategories(cat: CategoryStruct) {}
    
    public func putTopSellers(ts: TopSeller) {}
    
    public func putProduct(ps: ProductStruct) {}
    
    public func postProduct(re: ReservaStruct) {}

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
