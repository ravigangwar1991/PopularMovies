//
//  MovieInfoCell.swift
//  Latest Movies
//
//  Created by Ravi Gangwar on 01/08/19.
//  Copyright © 2019 Ravi Gangwar. All rights reserved.
//

import UIKit

class MovieInfoCell: UITableViewCell {
    //MARK:-IBOUTLETS

    @IBOutlet weak var headerLabel: UILabel!
    @IBOutlet weak var infoLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    func populateCell(_ title:String,_ value:String){
        self.headerLabel.text = title
        self.infoLabel.text = value
    }

}
