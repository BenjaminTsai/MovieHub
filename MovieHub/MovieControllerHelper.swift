//
//  MovieControllerHelper.swift
//  MovieHub
//
//  Created by Benjamin Tsai on 5/9/15.
//  Copyright (c) 2015 Benjamin Tsai. All rights reserved.
//

import UIKit

class MovieControllerHelper {
    
    func loadImage(url: String, imageView: UIImageView, fadeIn: Bool = true, resetImage: Bool = true, onDisplay: ()->() = {}) {
        if resetImage {
            imageView.image = nil
        }
        
        let nsurl = NSURL(string:url)!
        let request = NSMutableURLRequest(URL: nsurl)
        request.cachePolicy = NSURLRequestCachePolicy.ReturnCacheDataElseLoad
        
        NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue(), completionHandler:{ (response, data, error) in
            imageView.image = UIImage(data: data)

            if fadeIn {
                UIView.transitionWithView(imageView, duration: 1.0, options: UIViewAnimationOptions.TransitionCrossDissolve,
                    animations: {
                        imageView.hidden = false
                    },
                    completion: { finished in
                        onDisplay()
                    }
                )
            } else {
                imageView.hidden = false
                onDisplay()
            }
        })
    }
    
    func progressiveLoadLargeImage(thumbnailUrl: String, originalUrl: String, imageView: UIImageView) {
        imageView.image = nil
        
        func loadOriginal() {
            loadImage(originalUrl, imageView: imageView, resetImage: false)
        }
        
        loadImage(thumbnailUrl, imageView: imageView, fadeIn: false, onDisplay: loadOriginal)
    }
 
    func makeErrorView(message: String, view: UIView) -> UIView {
        let errorView = UIView(frame: CGRectMake(0, 65, view.frame.width, 30))
        errorView.backgroundColor = UIColor.redColor()
        errorView.alpha = 0.5
        
        let errorLabel = UILabel()
        errorLabel.text = message
        errorLabel.textColor = UIColor.whiteColor()
        errorLabel.sizeToFit()
        
        errorLabel.center = errorView.convertPoint(errorView.center, fromCoordinateSpace: view)
        errorView.addSubview(errorLabel)
        
        return errorView
    }
    
    func loadData(url: String, onError: ()->(), onSuccess: ([NSDictionary])->()) {
        let nsurl = NSURL(string: url)
        let request = NSMutableURLRequest(URL: nsurl!)
        
        // Set timeout to 5 seconds to facilitate demo
        request.timeoutInterval = 5
        
        func onCompletion(response: NSURLResponse!, data: NSData!, error: NSError!) {
            // Network error?
            if error != nil {
                onError()
                return
            }
            
            // Deserialize response into dictionary
            var jsonError: NSError? = nil
            let dictionary = NSJSONSerialization.JSONObjectWithData(data, options: nil, error: &jsonError) as! NSDictionary

            // Problem deserializing?
            if jsonError != nil {
                onError()
                return
            }
            
            // Success
            let data = dictionary.valueForKey("movies") as! [NSDictionary]
            onSuccess(data)
        }
        
        NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue(), completionHandler: onCompletion)
    }
}