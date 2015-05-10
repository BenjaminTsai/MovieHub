//
//  BaseMovieCell.swift
//  MovieHub
//
//  Created by Benjamin Tsai on 5/10/15.
//  Copyright (c) 2015 Benjamin Tsai. All rights reserved.
//

import UIKit

class BaseMovieCell: UITableViewCell {
    
    @IBOutlet weak var thumbnailImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        self.selectionStyle = UITableViewCellSelectionStyle.None
    }
    
    override func setHighlighted(highlighted: Bool, animated: Bool) {
        if (highlighted) {
            self.backgroundColor = UIColor.blackColor()
        } else {
            self.backgroundColor = UIColor.clearColor()
        }
        
        super.setHighlighted(highlighted, animated: animated)
    }
    
}