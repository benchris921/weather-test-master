//
//  ImageCacheManager.swift
//  apartment-rental
//
//  Created by Benjamin Chris on 1/15/19.
//  Copyright © 2019 Benjamin Chris. All rights reserved.
//

import UIKit

class ImageCacheManager: NSObject {
    
    static let manager = ImageCacheManager()
    
    var imageCache = [String: UIImage]()
    
    func saveToCache(_ url: String, _ image: UIImage) {
        self.imageCache[url] = image
    }
    
    func cachedImage(for url: String) -> UIImage? {
        return self.imageCache[url]
    }
}
