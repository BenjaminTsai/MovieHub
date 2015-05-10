//
//  MovieDetailCell.swift
//  MovieHub
//
//  Created by Benjamin Tsai on 5/10/15.
//  Copyright (c) 2015 Benjamin Tsai. All rights reserved.
//

import UIKit

class MovieDetailCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var summaryLabel: UILabel!

    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        self.selectionStyle = UITableViewCellSelectionStyle.None
    }
}