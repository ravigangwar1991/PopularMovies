//
//  PaginationCell.swift
//  Latest Movies
//
//  Created by Ravi Gangwar on 02/08/19.
//  Copyright © 2019 Ravi Gangwar. All rights reserved.
//

import UIKit

class PaginationCell: UITableViewCell {
    
    //MARK:-IBOUTLETS
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
