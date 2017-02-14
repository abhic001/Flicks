//
//  MovieCell.swift
//  MovieViewer
//
//  Created by Abhijeet Chakrabarti on 2/6/17.
//  Copyright © 2017 Abhijeet Chakrabarti. All rights reserved.//
//

import UIKit

class MovieCell: UITableViewCell {
    
    @IBOutlet var titleLabel: UILabel!
    
    
    @IBOutlet var overviewCell: UILabel!
    
    @IBOutlet var posterView: UIImageView!
    
    
    @IBOutlet var ratingLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
