//
//  ViewController.swift
//  Lodjinha
//
//  Created by Lucas Luz on 15/02/17.
//  Copyright © 2017 Lucas Luz. All rights reserved.
//

import UIKit


extension UIApplication {
    var statusBarView: UIView {
        return (value(forKey: "statusBar") as? UIView)!
    }
}

class ViewController: UIViewController {
    
    @IBOutlet var navBar: UINavigationBar!
    @IBOutlet var tabBar: UITabBar!
    @IBOutlet var homeTabBarButton: UITabBarItem!
    
    @IBOutlet var bannerImageView: UIImageView!
    @IBOutlet var bannerPgCtrl: UIPageControl!
    @IBOutlet var activityBannerLoading: UIActivityIndicatorView!
    
    @IBOutlet var categoriesScrollView: UIScrollView!
    @IBOutlet var activityCategoriesLoading: UIActivityIndicatorView!
    
    @IBOutlet var productsTableView: UITableView!
    
    // Banners
    var bannerImages = Array<UIImage>()
    var bannerLinks = Array<String>()
    var currentBannerIndex = 0
    
    // Categories
    var categoriesImages = Array<UIImage>()
    var categoriesLinks = Array<String>()
    var categoriesDescriptions = Array<String>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadHomeView();
    }
    
    public func loadHomeView() {
        // Set home button active
        homeTabBarButton.image = UIImage.init(named: "homeActive")
        
        // Set color of navigation bar
        navBar?.isTranslucent = false
        navBar?.isOpaque = true
        UIApplication.shared.statusBarView.backgroundColor = navBar?.backgroundColor
        
        // Set navigation bar logo
        //        navBar?.setBackgroundImage(UIImage.init(named: "logoNavbar"), for: .topAttached, barMetrics: .default)
        //        navBar?.sizeToFit()
        
        
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
//        rs.getJSONData(dataType: WebServicesEnum.produtosMaisVendidos.rawValue, structure: TopSeller.self, view: self)
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
            print("total cat: \(cat.data.count)")
            
            for c in cat.data {
                var b = UIImage()
                var l = String()
                var d = String()
                
                if let url = NSURL(string: c.urlImagem) {
                    if let data = NSData(contentsOf: url as URL) {
                        b = UIImage(data: data as Data)!
                        l = WebServicesEnum.produto.rawValue.appending("?offset=0&limit=10&cateogoriaId=\(c.id)")
                        d = c.descricao
                        
                        categoriesImages.append(b)
                        categoriesLinks.append(l)
                        categoriesDescriptions.append(d)
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
            ci.isUserInteractionEnabled = true
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
            print(index)
            print(cats.size)
        }
     }
    // Categories end
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        UIApplication.shared.statusBarStyle = UIStatusBarStyle.default
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}





