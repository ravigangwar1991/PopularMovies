//
//  UITableViewExtension.swift
//  Latest Movies
//
//  Created by Ravi Gangwar on 31/07/19.
//  Copyright © 2019 Ravi Gangwar. All rights reserved.
//

import Foundation
import UIKit

extension UITableView {
    
    func registerCell(nibName:String, bundle:Bundle? = nil, forCellWithReuseIdentifier:String? = nil){
        
        let cellWithReuseIdentifier = forCellWithReuseIdentifier ?? nibName
        self.register(UINib(nibName: nibName , bundle: bundle), forCellReuseIdentifier: cellWithReuseIdentifier)
    }
}
    
extension UITableViewCell{
        
        class var nibName : String {
            return "\(self)"
        }
}
