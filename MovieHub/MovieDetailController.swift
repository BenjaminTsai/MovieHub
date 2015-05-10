//
//  MovieDetailController.swift
//  MovieHub
//
//  Created by Benjamin Tsai on 5/5/15.
//  Copyright (c) 2015 Benjamin Tsai. All rights reserved.
//

import Foundation
import UIKit

class MovieDetailController: UIViewController, UITableViewDataSource {
   
    @IBOutlet weak var moveNav: UINavigationItem!
    @IBOutlet weak var moviePoster: UIImageView!
    @IBOutlet weak var tableView: UITableView!

    private let controllerHelper = MovieControllerHelper()
    var detail: NSDictionary = NSDictionary()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.dataSource = self
        
        let thumbnailUrl = (detail.valueForKey("posters") as! NSDictionary).valueForKey("original") as! String
        let range = thumbnailUrl.rangeOfString(".*cloudfront.net/", options: .RegularExpressionSearch)
        let originalUrl = range != nil ? thumbnailUrl.stringByReplacingCharactersInRange(range!, withString: "https://content6.flixster.com/") : thumbnailUrl
        
        let title = detail.valueForKey("title") as! String
        moveNav.title = title
        
        controllerHelper.progressiveLoadLargeImage(thumbnailUrl, originalUrl: originalUrl, imageView: moviePoster)
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("MovieDetailCell", forIndexPath: indexPath) as! MovieDetailCell
        
        let title = detail.valueForKey("title") as! String
        let synopsis = detail.valueForKey("synopsis") as! String
        let audienceScore = (detail.valueForKey("ratings") as! NSDictionary).valueForKey("audience_score") as! Int
        let criticsScore = (detail.valueForKey("ratings") as! NSDictionary).valueForKey("critics_score") as! Int
        
        cell.titleLabel.text = title
        cell.summaryLabel.text = "Audience Score: " + String(audienceScore) + " Critics Score: " + String(criticsScore) + "\n\n" + synopsis
        cell.summaryLabel.sizeToFit()
        cell.sizeToFit()
        
        return cell
    }
    
}