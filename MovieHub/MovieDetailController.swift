//
//  MovieDetailController.swift
//  MovieHub
//
//  Created by Benjamin Tsai on 5/5/15.
//  Copyright (c) 2015 Benjamin Tsai. All rights reserved.
//

import Foundation
import UIKit

class MovieDetailController: UIViewController {
   
    @IBOutlet weak var moveNav: UINavigationItem!
    @IBOutlet weak var moviePoster: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var summaryLabel: UILabel!

    let controllerHelper = MovieControllerHelper()
    var detail: NSDictionary = NSDictionary()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let title = detail.valueForKey("title") as! String
        let synopsis = detail.valueForKey("synopsis") as! String
        let thumbnailUrl = (detail.valueForKey("posters") as! NSDictionary).valueForKey("original") as! String
        let audienceScore = (detail.valueForKey("ratings") as! NSDictionary).valueForKey("audience_score") as! Int
        let criticsScore = (detail.valueForKey("ratings") as! NSDictionary).valueForKey("critics_score") as! Int
        
        moveNav.title = title
        titleLabel.text = title
        summaryLabel.text = "Audience Score: " + String(audienceScore) + " Critics Score: " + String(criticsScore) + "\n" + synopsis
        
        var range = thumbnailUrl.rangeOfString(".*cloudfront.net/", options: .RegularExpressionSearch)
        let originalUrl = range != nil ? thumbnailUrl.stringByReplacingCharactersInRange(range!, withString: "https://content6.flixster.com/") : thumbnailUrl
        
        controllerHelper.progressiveLoadLargeImage(thumbnailUrl, originalUrl: originalUrl, imageView: moviePoster)
    }
    
}