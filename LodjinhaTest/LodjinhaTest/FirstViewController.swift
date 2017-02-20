//
//  FirstViewController.swift
//  LodjinhaTest
//
//  Created by Lucas Luz on 17/02/17.
//  Copyright © 2017 Lucas Luz. All rights reserved.
//

import UIKit

extension UIApplication {
    var statusBarView: UIView {
        return (value(forKey: "statusBar") as? UIView)!
    }
}

class TopSellersViewCell: UITableViewCell {
    @IBOutlet var productImage: UIImageView!
    @IBOutlet var productName: UILabel!
    @IBOutlet var productOldPrice: UILabel!
    @IBOutlet var productNewPrice: UILabel!
    var descricao : String!
    var categoria : String!
    var id: Int = 0
}

class DummyCatViewController: UIView {
    var id : Int = 0
}

class FirstViewController: UIViewController, ViewControllerProtocol, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet var navBar: UINavigationBar!
    @IBOutlet var bannerImageView: UIImageView!
    @IBOutlet var bannerPgCtrl: UIPageControl!
    @IBOutlet var activityBannerLoading: UIActivityIndicatorView!
    
    @IBOutlet var categoriesScrollView: UIScrollView!
    @IBOutlet var activityCategoriesLoading: UIActivityIndicatorView!
    public var categoryIdTapped = 0
    
    var valuesToPassProduct = Array<String>()
//    var nextViewController : UIViewController!
    
    // Banners
    var bannerImages = Array<UIImage>()
    var bannerLinks = Array<String>()
    var currentBannerIndex = 0
    
    // Categories
    var categoriesImages = Array<UIImage>()
    var categoriesLinks = Array<String>()
    var categoriesDescriptions = Array<String>()
    var categoriesIds = Array<Int>()
    
    // Top Sellers
    @IBOutlet var topSellersTableView: UITableView!
    
    var topSellersCount: Int = 0
    var tsTmp = TopSeller()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set color of navigation bar
        navBar?.isTranslucent = false
        navBar?.isOpaque = true
        UIApplication.shared.statusBarView.backgroundColor = navBar?.backgroundColor
        
        topSellersTableView.delegate = self
        topSellersTableView.dataSource = self
        
        loadHomeView()
    }
    
    public func loadHomeView() {
        // create Request for all webservices
        let rs = RequestService()
        
        // Activate spinners
        activityBannerLoading.isHidden = false
        activityBannerLoading.hidesWhenStopped = true
        activityBannerLoading.startAnimating()
        
        activityCategoriesLoading.isHidden = false
        activityCategoriesLoading.hidesWhenStopped = true
        activityCategoriesLoading.startAnimating()
        
        // Request banners
        rs.getJSONData(dataType: WebServicesEnum.banner.rawValue, structure: BannerStruct.self, view: self)
        
        // Request categories
        rs.getJSONData(dataType: WebServicesEnum.categoria.rawValue, structure: CategoryStruct.self, view: self)
        
        // Request top sellers
        rs.getJSONData(dataType: WebServicesEnum.produtosMaisVendidos.rawValue, structure: TopSeller.self, view: self)
    }
    
    // Banners start
    public func putBanners(bs: BannerStruct) {
        if(bs.data.count > 0) {
            // Set banner page controller
            bannerPgCtrl.isHidden = false
            bannerPgCtrl.numberOfPages = bs.data.count
            bannerPgCtrl.currentPage = currentBannerIndex
            
            for img in bs.data {
                var b = UIImage()
                var l = String()
                
                if let url = NSURL(string: img.urlImagem) {
                    if let data = NSData(contentsOf: url as URL) {
                        b = UIImage(data: data as Data)!
                        l = img.linkUrl
                        
                        bannerImages.append(b)
                        bannerLinks.append(l)
                    }
                }
            }
            
            activityBannerLoading.stopAnimating()
            
            // set image and tap/swipe recognizer
            let tapBannerGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(bannerTapped(tapGestureRecognizer:)))
            bannerImageView.isUserInteractionEnabled = true
            bannerImageView.addGestureRecognizer(tapBannerGestureRecognizer)
            bannerImageView.image = bannerImages[currentBannerIndex]
            
            let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(bannerSwiped(gesture:)))
            swipeRight.direction = UISwipeGestureRecognizerDirection.right
            bannerImageView.addGestureRecognizer(swipeRight);
            
            let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(bannerSwiped(gesture:)))
            swipeLeft.direction = UISwipeGestureRecognizerDirection.left
            bannerImageView.addGestureRecognizer(swipeLeft);
        }
    }
    
    // open banner link
    func bannerTapped(tapGestureRecognizer: UITapGestureRecognizer) {
        let url = URL(string: bannerLinks[currentBannerIndex])
        if #available(iOS 10.0, *) {
            UIApplication.shared.open(url!, options: [:], completionHandler: nil)
        } else {
            UIApplication.shared.openURL(url!)
        }
        
    }
    
    func bannerSwiped(gesture: UIGestureRecognizer) {
        if let swipeGesture = gesture as? UISwipeGestureRecognizer{
            switch swipeGesture.direction {
            case UISwipeGestureRecognizerDirection.right:
                if(currentBannerIndex < bannerImages.count - 1) {
                    currentBannerIndex += 1
                    bannerImageView.image = bannerImages[currentBannerIndex]
                    bannerPgCtrl.currentPage = currentBannerIndex
                }
                
                break
            case UISwipeGestureRecognizerDirection.left:
                if(currentBannerIndex > 0) {
                    currentBannerIndex -= 1
                    bannerImageView.image = bannerImages[currentBannerIndex]
                    bannerPgCtrl.currentPage = currentBannerIndex
                }
                
                break
            default:
                return
            }
        }
    }
    // Banners end
    
    // Categories start
    public func putCategories(cat: CategoryStruct) {
        
        if(cat.data.count > 0) {
            for c in cat.data {
                var b = UIImage()
                var l = String()
                var d = String()
                var i = Int()
                
                if let url = NSURL(string: c.urlImagem) {
                    if let data = NSData(contentsOf: url as URL) {
                        b = UIImage(data: data as Data)!
                        l = WebServicesEnum.produto.rawValue.appending("\(c.id)")
                        d = c.descricao
                        i = c.id
                        
                        categoriesImages.append(b)
                        categoriesLinks.append(l)
                        categoriesDescriptions.append(d)
                        categoriesIds.append(i)
                    }
                }
            }
            
            drawCategories()
            activityCategoriesLoading.stopAnimating()
        }
    }
    
    func drawCategories() {
        var index = 0
        
        let imageWidth: CGFloat = 75
        let imageHeight: CGFloat = 75
        let yPosition:CGFloat = 10
        var xPosition:CGFloat = 20
        var scrollViewContentSize:CGFloat = 0
        
        for cats in categoriesImages {
            let ci = UIImageView()

            let tapCategoryGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(categoryTapped(gesture:)))
            ci.isUserInteractionEnabled = true
            ci.addGestureRecognizer(tapCategoryGestureRecognizer)
            
            let tmpUI = DummyCatViewController()
            tmpUI.id = categoriesIds[index];
            ci.addSubview(tmpUI)
            
            ci.image = cats
            ci.contentMode = UIViewContentMode.scaleAspectFit
            
            ci.frame.size.width = imageWidth
            ci.frame.size.height = imageHeight
            ci.center = self.view.center
            ci.frame.origin.y = yPosition
            ci.frame.origin.x = xPosition
            
            categoriesScrollView.addSubview(ci)
            
            let label = UILabel()
            label.text = categoriesDescriptions[index]
            label.textColor = .black
            label.contentMode = UIViewContentMode.scaleAspectFit
            label.frame.size.width = imageWidth
            label.frame.size.height = 30
            label.numberOfLines = 2
            label.adjustsFontSizeToFitWidth = true
            label.textAlignment = .center
            label.baselineAdjustment = .alignBaselines
            label.frame.origin.y = yPosition + imageHeight
            label.frame.origin.x = xPosition
            label.layoutIfNeeded()
            categoriesScrollView.addSubview(label)
            
            let spacer:CGFloat = 20
            xPosition += imageWidth + spacer
            scrollViewContentSize += imageWidth + spacer
            
            categoriesScrollView.contentSize = CGSize(width: scrollViewContentSize, height: imageHeight)
            
            index += 1
        }
    }
    
    public func putProduct(ps: ProductStruct) {
        // Do nothing
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        print("prepare segue: \(segue.identifier)")
        
        if(segue.identifier == "listCategoriesWrapperSegue") {
            let nextView = segue.destination as? CategoryListWrapperViewController
            nextView?.categoryId = categoryIdTapped

        } else if(segue.identifier == "showProductSegue") {
            let nextView = segue.destination as? ProductViewController
            let indexPath = self.topSellersTableView.indexPathForSelectedRow
            let selectedProduct = self.topSellersTableView.cellForRow(at: indexPath!)
            nextView?.productCell = selectedProduct as! TopSellersViewCell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "showProductSegue", sender: self)
    }
    
    func categoryTapped(gesture: UIGestureRecognizer) {
        let imgs = gesture.view as! UIImageView

        for u in imgs.subviews {
            if (u.isKind(of: DummyCatViewController.self)) {
                let uTmp = u as! DummyCatViewController
                categoryIdTapped = uTmp.id
            }
        }
        print("category tapped ")
        self.performSegue(withIdentifier: "listCategoriesWrapperSegue", sender: self)
    }
    
    
    // Categories end
    

    // Top Sellers start
    public func putTopSellers(ts: TopSeller) {
        if(ts.data.count > 0) {
            tsTmp = ts
            topSellersCount = ts.data.count
            
            topSellersTableView.reloadData()
            topSellersTableView.layoutIfNeeded()
        }
    }
    
    // Products by Category
    public func putProductsByCategory(pc: ProductsByCategoryStruct) {}
    
    public func postProduct(re: ReservaStruct) {}
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return topSellersCount;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        print("aqui")
        let cell = tableView.dequeueReusableCell(withIdentifier: "topSellersReusableCell", for: indexPath) as! TopSellersViewCell
        
        let pimage = downloadImage(urlRequested: tsTmp.data[indexPath.row].urlImagem)
        cell.productImage?.image = pimage
        
        let tmp : TopSeller.Fields = tsTmp.data[indexPath.row]
        
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
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100.0;
    }
    // Top Sellers end
    
    func downloadImage(urlRequested: String) -> UIImage {
        if let url = NSURL(string: urlRequested) {
            if let data = NSData(contentsOf: url as URL) {
                return UIImage(data: data as Data)!
            }
        }
        
        return UIImage.init()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
//        UIApplication.shared.statusBarStyle = UIStatusBarStyle.default
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
