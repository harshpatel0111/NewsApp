//
//  Copyright © 2020 Harsh patel. All rights reserved.
//

import UIKit

let imageCache = NSCache<AnyObject, AnyObject>()

extension UIImageView {
    
    func loadImage(urlString: String) {
        var imageUrlString: String?
        if  let url = URL(string: urlString) {
            imageUrlString = urlString
            image = nil
            
            if let imageFromCache = imageCache.object(forKey: urlString as NSString) as? UIImage {
                self.image = imageFromCache
                return
            }
            URLSession.shared.dataTask(with: url) { data, response, error in
                guard let data = data, error == nil else { return }
                if (error != nil)  {
                    print("error")
                    return
                }
                
                DispatchQueue.main.async() {
                    if let imageToCache = UIImage(data: data) {
                        if imageUrlString == urlString {
                            
                            self.image = imageToCache
                    
                        }
                        imageCache.setObject(imageToCache, forKey: urlString as AnyObject)
                    }
                }
            }
            .resume()
        }
    }
}
