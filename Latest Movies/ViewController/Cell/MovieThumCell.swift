//
//  MovieThumCell.swift
//  Latest Movies
//
//  Created by Ravi Gangwar on 01/08/19.
//  Copyright © 2019 Ravi Gangwar. All rights reserved.
//

import UIKit

class MovieThumCell: UITableViewCell {

    //MARK:-IBOUTLETS
    @IBOutlet weak var thumbImageView: UIImageView!
    @IBOutlet weak var watchTrailerBtn: UIButton!
    @IBOutlet weak var movieTitleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    //MARK:-Method to populate data

    func populateDataWithModel(_ model:MovieDetailsDBModel){
        
        self.thumbImageView.setImage(model.posterUrl)
        self.movieTitleLabel.text = model.title
        
    }

}
