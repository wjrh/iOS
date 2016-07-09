//
//  TealEpisode.swift
//  WJRH
//
//  Created by Eric Weber on 7/1/16.
//  Copyright © 2016 Eric Weber. All rights reserved.
//

import Foundation
import UIKit

class TealEpisode {
    var name: String?
    var description: String?
    var image: UIImage?
    private var urlSession: NSURLSession?
    
    init(name: String, description: String, imageURL: String, imageLoadCallback: ((Void) -> Void)?, urlSession: NSURLSession, programImage: UIImage) {
        self.name = name
        self.description = description
        self.urlSession = urlSession
        requestImage(imageURL, imageLoadCallback: imageLoadCallback, programImage: programImage)
    }
    
    private func requestImage(imageURL: String, imageLoadCallback: ((Void) -> Void)?, programImage: UIImage) {
        if (imageURL != "<null>") {
            if (imageURL.rangeOfString("imgur") != nil) {
                if let lastDotRange = imageURL.rangeOfString(".", options: .BackwardsSearch) {
                    let lastDotIndex = lastDotRange.startIndex
                    let thumbnailImageURL = imageURL.substringToIndex(lastDotIndex) + "m" + imageURL.substringFromIndex(lastDotIndex) //http://api.imgur.com/models/image
                    let request = urlSession!.dataTaskWithURL(NSURL(string: thumbnailImageURL)!) { (data, response, error) -> Void in
                        //print("Loaded image")
                        if let dataUnwrapped = data {
                            self.image = UIImage(data: dataUnwrapped)
                        }
                        if let callBack = imageLoadCallback {
                            callBack()
                        }
                    }
                    request.resume()
                }
            }
            else {
                let request = urlSession!.dataTaskWithURL(NSURL(string: imageURL)!) { (data, response, error) -> Void in
                    if let dataUnwrapped = data {
                        self.image = UIImage(data: dataUnwrapped)
                    }
                }
                request.resume()
            }
        }
        else {
            self.image = programImage
        }
    }
}