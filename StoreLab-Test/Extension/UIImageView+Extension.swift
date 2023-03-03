//
//  UIImageView+Extension.swift
//  StoreLab-Test
//
//  Created by Nikunj Gangani on 03/03/2023.
//

import Foundation
import UIKit

var imageCache = NSCache<AnyObject, AnyObject>()

extension UIImageView {
    
    /// This loadThumbnail function is used to download thumbnail image using urlString
    /// This method also using cache of loaded thumbnail using urlString as a key of cached thumbnail.
    func loadThumbnail(urlSting: String) {
        guard let url = URL(string: urlSting) else { return }
        image = nil
        
        if let imageFromCache = imageCache.object(forKey: urlSting as AnyObject) {
            image = imageFromCache as? UIImage
            return
        }
        ServiceManager().getWebService(url: url, params: [:]) { [weak self] (result) in
            guard let self = self else { return }
            switch result {
            case .success(let data):
                guard let imageToCache = UIImage(data: data) else { return }
                imageCache.setObject(imageToCache, forKey: urlSting as AnyObject)
                DispatchQueue.main.async {
                    self.image = UIImage(data: data)
                }
            case .failure(_):
                DispatchQueue.main.async {
                    self.image = UIImage(named: "placeholderImg")
                }
            }
        }
    }
}
