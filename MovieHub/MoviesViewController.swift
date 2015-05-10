//
//  ViewController.swift
//  MovieHub
//
//  Created by Benjamin Tsai on 5/5/15.
//  Copyright (c) 2015 Benjamin Tsai. All rights reserved.
//

import UIKit
import Foundation
import SVProgressHUD

class MoviesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UICollectionViewDataSource {

    @IBOutlet weak var navBarThing: UINavigationItem!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var collectionView: UICollectionView!

    private let controllerHelper = MovieControllerHelper()
    private var tableRefreshControl: UIRefreshControl!
    private var gridRefreshControl: UIRefreshControl!
    private var errorView: UIView? = nil
    private var movies = NSArray()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        collectionView.hidden = true
        collectionView.dataSource = self
        
        tableRefreshControl = UIRefreshControl()
        tableRefreshControl.tintColor = UIColor.whiteColor()
        tableRefreshControl.addTarget(self, action: "onRefresh", forControlEvents: UIControlEvents.ValueChanged)

        gridRefreshControl = UIRefreshControl()
        gridRefreshControl.tintColor = UIColor.whiteColor()
        gridRefreshControl.addTarget(self, action: "onRefresh", forControlEvents: UIControlEvents.ValueChanged)
        
        tableView.insertSubview(tableRefreshControl, atIndex: 0)
        collectionView.insertSubview(gridRefreshControl, atIndex: 0)
        
        SVProgressHUD.show()
        loadMovies({
            SVProgressHUD.dismiss()
        })
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        super.prepareForSegue(segue, sender: sender)
        
        if segue.identifier == "movieDetailSegue" {
            let detailController = segue.destinationViewController as! MovieDetailController
            let row = tableView.indexPathForSelectedRow()!.item
            detailController.detail = movies.objectAtIndex(row) as! NSDictionary
        } else if segue.identifier == "movieGridDetailSegue" {
            let detailController = segue.destinationViewController as! MovieDetailController
            let cellIndexPath = (collectionView.indexPathsForSelectedItems()[0] as! NSIndexPath)
            detailController.detail = movies.objectAtIndex(cellIndexPath.item) as! NSDictionary
        } else {
            NSLog("Unknown segue %@", segue)
        }
    }
    
    // TABLE VIEW
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movies.count
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("MovieCell", forIndexPath: indexPath) as! BaseMovieCell
        
        let row = indexPath.row
        let data = (movies.objectAtIndex(row) as! NSDictionary)
        
        let title = data.valueForKey("title") as! String
        let thumbnailUrl = (data.valueForKey("posters") as! NSDictionary).valueForKey("thumbnail") as! String
        
        cell.titleLabel.text = title
        
        controllerHelper.loadImage(thumbnailUrl, imageView: cell.thumbnailImageView)
        
        return cell
    }
    
    // COLLECTION VIEW
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return movies.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("MovieGridCell", forIndexPath: indexPath) as! MovieGridCell
        
        let row = indexPath.row
        let data = (movies.objectAtIndex(row) as! NSDictionary)
        
        let title = data.valueForKey("title") as! String
        let thumbnailUrl = (data.valueForKey("posters") as! NSDictionary).valueForKey("thumbnail") as! String
        
        cell.label.text = title
        
        controllerHelper.loadImage(thumbnailUrl, imageView: cell.imageView)
        
        return cell
    }
    
    // Other stuff
    
    @IBAction func didClickListGridToggle(sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            tableView.hidden = false
            collectionView.hidden = true
        case 1:
            tableView.hidden = true
            collectionView.hidden = false
        default:
            NSLog("Unexpected selected list grid segment index " + String(sender.selectedSegmentIndex))
        }
        
    }
    
    private func onRefresh() {
        loadMovies({
            self.tableRefreshControl.endRefreshing()
            self.gridRefreshControl.endRefreshing()
        })
    }
    
    private func loadMovies(onLoad:()->()) {
        errorView?.removeFromSuperview()
        errorView = nil
        
        controllerHelper.loadData("https://gist.githubusercontent.com/timothy1ee/d1778ca5b944ed974db0/raw/489d812c7ceeec0ac15ab77bf7c47849f2d1eb2b/gistfile1.json",
            onError: {
                self.errorView = self.controllerHelper.makeErrorView("Network Error", view: self.view)
                self.view.addSubview(self.errorView!)
                
                onLoad()
            },
            onSuccess: { (data: [NSDictionary]) in
                self.movies = data
                self.tableView.reloadData()
                self.collectionView.reloadData()

                onLoad()
            }
        )
    }

}

