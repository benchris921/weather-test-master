//
//  UIImageViewExtension.swift
//  apartment-rental
//
//  Created by Software Engineer on 1/15/19.
//  Copyright © 2019 Benjamin Chris. All rights reserved.
//

import UIKit

extension UIImageView {
    
    public func imageFromURL(urlString: String) {
        
        if let image = ImageCacheManager.manager.cachedImage(for: urlString) {
            self.image = image
        } else {
            
            if let imageData = UserDefaults.standard.data(forKey: "img:\(urlString)") {
                if let image = UIImage(data: imageData) {
                    self.image = image
                    return
                }
            }
            
            let activityIndicator = UIActivityIndicatorView(style: .gray)
            activityIndicator.frame = CGRect.init(x: 0, y: 0, width: self.frame.size.width, height: self.frame.size.height)
            activityIndicator.startAnimating()
            if self.image == nil {
                self.addSubview(activityIndicator)
            }
            
            URLSession.shared.dataTask(with: NSURL(string: urlString)! as URL, completionHandler: { (data, response, error) -> Void in
                
                if error != nil {
                    print(error ?? "No Error")
                    return
                }
                
                DispatchQueue.main.async(execute: { () -> Void in
                    
                    activityIndicator.removeFromSuperview()
                    
                    if let image = UIImage(data: data!) {
                        self.image = image
                        UserDefaults.standard.set(data!, forKey: "img:\(urlString)")
                        UserDefaults.standard.synchronize()
                        ImageCacheManager.manager.saveToCache(urlString, image)
                    }
                    
                })
                
            }).resume()
        }
    }
    
}
