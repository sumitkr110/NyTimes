//
//  Extensions.swift
//  NyTimes
//
//  Created by Sumit Kumar on 17/08/20.
//  Copyright © 2020 sumitkr110. All rights reserved.
//

import Foundation
import UIKit

extension UIImageView {
    func downloaded(from url: URL) {  // for swift 4.2 syntax just use ===> mode: UIView.ContentMode
        let cache = URLCache.shared
        let request = URLRequest.init(url: url)
        
        DispatchQueue.global(qos: .userInitiated).async {
            if let data = cache.cachedResponse(for: request)?.data, let image = UIImage.init(data: data) {
                DispatchQueue.main.async {
                    self.image = image
                }
            } else {
                URLSession.shared.dataTask(with: request) { (data, response, error) in
                    if let data = data, let image = UIImage.init(data: data) {
                        let cachedData = CachedURLResponse.init(response: response!, data: data)
                        cache.storeCachedResponse(cachedData, for: request)
                        DispatchQueue.main.async {
                            self.image = image
                        }
                    }
                }.resume()
            }
        }
    }
}

extension UIView{
    func activityStartAnimating(activityColor: UIColor, backgroundColor: UIColor) {
        let backgroundView = UIView()
        backgroundView.frame = CGRect.init(x: 0, y: 0, width: self.bounds.width, height: self.bounds.height)
        backgroundView.backgroundColor = backgroundColor
        backgroundView.tag = activityBackgroundViewTag
        var activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView()
        activityIndicator = UIActivityIndicatorView(frame: CGRect.init(x: 0, y: 0, width: 50, height: 50))
        activityIndicator.center = self.center
        activityIndicator.hidesWhenStopped = true
        activityIndicator.style = UIActivityIndicatorView.Style.large
        activityIndicator.color = activityColor
        activityIndicator.startAnimating()
        self.isUserInteractionEnabled = false
        
        backgroundView.addSubview(activityIndicator)
        
        self.addSubview(backgroundView)
    }
    
    func activityStopAnimating() {
        if let background = viewWithTag(activityBackgroundViewTag){
            background.removeFromSuperview()
        }
        self.isUserInteractionEnabled = true
    }
}

extension UITableViewCell {
    /// Generated cell identifier derived from class name
    public static func cellIdentifier() -> String {
        return String(describing: self)
    }
}

extension Date {
    func string(format: String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        return formatter.string(from: self)
    }
}
