//
//  DvdstViewController.swift
//  MovieHub
//
//  Created by Benjamin Tsai on 5/8/15.
//  Copyright (c) 2015 Benjamin Tsai. All rights reserved.
//

import UIKit
import SVProgressHUD

class DvdsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate {

    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!

    let controllerHelper = MovieControllerHelper()
    var refreshControl: UIRefreshControl!
    var errorView: UIView? = nil
    
    var allDvds: [NSDictionary] = NSArray() as! [NSDictionary]
    var dvds: [NSDictionary] = NSArray() as! [NSDictionary]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchBar.delegate = self
        
        tableView.delegate = self
        tableView.dataSource = self
        
        refreshControl = UIRefreshControl()
        refreshControl.tintColor = UIColor.whiteColor()
        refreshControl.addTarget(self, action: "onRefresh", forControlEvents: UIControlEvents.ValueChanged)
        
        tableView.insertSubview(refreshControl, atIndex: 0)
        
        SVProgressHUD.show()
        loadDvds({
            SVProgressHUD.dismiss()
        })
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        super.prepareForSegue(segue, sender: sender)
        
        if segue.identifier == "dvdDetailSegue" {
            let detailController = segue.destinationViewController as! MovieDetailController
            let row = tableView.indexPathForSelectedRow()!.item
            detailController.detail = dvds[row]
        } else {
            NSLog("Unknown segue %@", segue)
        }
    }
    
    // TABLE VIEW
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dvds.count
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("DvdCell", forIndexPath: indexPath) as! BaseMovieCell
        
        let row = indexPath.row
        let data = dvds[row]
        
        let title = data.valueForKey("title") as! String
        let thumbnailUrl = (data.valueForKey("posters") as! NSDictionary).valueForKey("thumbnail") as! String
        
        cell.titleLabel.text = title
        
        controllerHelper.loadImage(thumbnailUrl, imageView: cell.thumbnailImageView)
        
        return cell
    }
    
    // SEARCH BAR
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        NSLog("search!")
    }
    
    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        NSLog("search canceled!")
        searchBar.text = ""
        searchBar.endEditing(true)
        
        dvds = allDvds
        tableView.reloadData()
    }
    
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        NSLog("search bar text changed: " + searchText)
        
        if searchText.isEmpty {
            dvds = allDvds
            tableView.reloadData()
            return
        }
        
        dvds = NSArray() as! [NSDictionary]
        for item in allDvds {
            let title = item.valueForKey("title") as! String
            NSLog("%@", title)
            
            let range = title.rangeOfString(searchText)
            if range != nil {
                NSLog("match")
                dvds.append(item)
            }
        }
        tableView.reloadData()
    }
    
    // Other stuff
    
    func onRefresh() {
        loadDvds({
            self.refreshControl.endRefreshing()
        })
    }
    
    func loadDvds(onLoad:()->()) {
        errorView?.removeFromSuperview()
        errorView = nil
        
        controllerHelper.loadData("https://gist.githubusercontent.com/timothy1ee/e41513a57049e21bc6cf/raw/b490e79be2d21818f28614ec933d5d8f467f0a66/gistfile1.json",
            onError: {
                self.errorView = self.controllerHelper.makeErrorView("Network Error", view: self.view)
                self.view.addSubview(self.errorView!)

                onLoad()
            },
            onSuccess: { (data: [NSDictionary]) in
                self.dvds = data
                self.allDvds = data
                self.tableView.reloadData()
                
                onLoad()
            }
        )
    }
}
