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
    
    @IBOutlet var productsTableView: UITableView!
    
    var bannerImages = Array<UIImage>()
    var bannerLinks = Array<String>()
    var currentImageIndex = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set home button active
        homeTabBarButton.image = UIImage.init(named: "homeActive")
        
        // Set color of navigation bar
        navBar?.isTranslucent = false
        navBar?.isOpaque = true
        UIApplication.shared.statusBarView.backgroundColor = navBar?.backgroundColor
        
        // Set navigation bar logo
//        navBar?.setBackgroundImage(UIImage.init(named: "logoNavbar"), for: .topAttached, barMetrics: .default)
//        navBar?.sizeToFit()
        

        // Request banners
        let rs = RequestService()
        rs.getJSONData(dataType: WebServicesEnum.banner.rawValue, structure: BannerStruct.self, view: self)
    }
    
    public func putBanners(bs: BannerStruct) {
        if(bs.data.count > 0) {
            // Set banner page controller
            bannerPgCtrl.isHidden = false
            bannerPgCtrl.numberOfPages = bs.data.count
            bannerPgCtrl.currentPage = currentImageIndex
            
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
            
            // set image and tap recognizer
            let tapBannerGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(bannerTapped(tapGestureRecognizer:)))
            bannerImageView.isUserInteractionEnabled = true
            bannerImageView.addGestureRecognizer(tapBannerGestureRecognizer)
            bannerImageView.image = bannerImages[currentImageIndex]
            
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
        let url = URL(string: bannerLinks[currentImageIndex])
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
                if(currentImageIndex < bannerImages.count - 1) {
                    currentImageIndex += 1
                    bannerImageView.image = bannerImages[currentImageIndex]
                    bannerPgCtrl.currentPage = currentImageIndex
                }
                
                break
            case UISwipeGestureRecognizerDirection.left:
                if(currentImageIndex > 0) {
                    currentImageIndex -= 1
                    bannerImageView.image = bannerImages[currentImageIndex]
                    bannerPgCtrl.currentPage = currentImageIndex
                }
                
                break
            default:
                return
            }
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        UIApplication.shared.statusBarStyle = UIStatusBarStyle.default
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}





