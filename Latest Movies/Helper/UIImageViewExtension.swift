//
//  UIImageViewExtension.swift
//  veme
//
//  Created by Ravi Gangwar on 31/07/19.
//  Copyright © 2019 Ravi Gangwar. All rights reserved.
//

import Foundation
import UIKit
import Kingfisher

extension UIImageView{
    
    static let dummyImageView = UIImageView()
    class func setImage(_ imageUrl: String?) {
        
        UIImageView.dummyImageView.setImage(imageUrl, placeholder: nil, showIndicator: false)
    }
    
    func setImage(_ imageUrl: String?, placeholder: UIImage? = nil, showIndicator:Bool = true) {
        
        self.image = placeholder
        if let url = URL(string: imageUrl ?? "abc") {
            
            if showIndicator{
                let imgView = self
                imgView.kf.indicatorType = .activity
            }
            _ = self.kf.setImage(with: url, placeholder: placeholder)
        }
    }
}
