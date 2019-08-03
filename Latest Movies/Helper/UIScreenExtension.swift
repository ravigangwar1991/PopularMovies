//
//  UIScreenExtension.swift
//  veme
//
//  Created by Ravi Gangwar on 31/07/19.
//  Copyright © 2019 Ravi Gangwar. All rights reserved.
//

import Foundation
import UIKit

extension UIScreen{
    
    class func resignKeyBoard() {
        
        let appWindow = UIApplication.shared.windows.sorted { (window1, window2) -> Bool in
            let diffeence = window1.windowLevel - window2.windowLevel > 0
            return  Bool(diffeence)
            }.last
        UIApplication.shared.keyWindow?.endEditing(true)
        appWindow?.endEditing(true)
    }
    static let width = UIScreen.main.bounds.size.width
    static let height = UIScreen.main.bounds.size.height
    static let size = UIScreen.main.bounds.size
}
