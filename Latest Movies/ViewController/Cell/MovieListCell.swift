//
//  MovieListCell.swift
//  Latest Movies
//
//  Created by Ravi Gangwar on 01/08/19.
//  Copyright © 2019 Ravi Gangwar. All rights reserved.
//

import UIKit

class MovieListCell: UITableViewCell {

    //MARK:-IBOUTLETS
    @IBOutlet weak var movieTitle: UILabel!
    @IBOutlet weak var movieThumImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    //MARK:-Method to populate data
    func populateDataWithModel(_ model:MovieListDBModel){
        
        self.movieThumImage.setImage(model.posterUrl)
        self.movieTitle.text = model.title
        
    }

}
