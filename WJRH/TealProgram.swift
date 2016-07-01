//
//  TealProgram.swift
//  WJRH
//
//  Created by Eric Weber on 6/30/16.
//  Copyright © 2016 Eric Weber. All rights reserved.
//

import Foundation
import UIKit

class TealProgram {
    var name: String?
    var author: String?
    var image: UIImage?
    private var urlSession: NSURLSession?
    
    init(name: String, author: String, imageURL: String, urlSession: NSURLSession) {
        self.name = name
        self.author = author
        self.urlSession = urlSession
        requestImage(imageURL)
    }
    
    private func requestImage(imageURL: String) {
        if (imageURL != "<null>") {
            if (imageURL.rangeOfString("imgur") != nil) {
                if let lastDotRange = imageURL.rangeOfString(".", options: .BackwardsSearch) {
                    let lastDotIndex = lastDotRange.startIndex
                    let thumbnailImageURL = imageURL.substringToIndex(lastDotIndex) + "m" + imageURL.substringFromIndex(lastDotIndex) //http://api.imgur.com/models/image
                    let request = urlSession!.dataTaskWithURL(NSURL(string: thumbnailImageURL)!) { (data, response, error) -> Void in
                        print("Loaded image")
                        self.image = UIImage(data: data!)
                    }
                    request.resume()
                }
            }
            else {
                let request = urlSession!.dataTaskWithURL(NSURL(string: imageURL)!) { (data, response, error) -> Void in
                    self.image = UIImage(data: data!)
                }
                request.resume()
            }
        }
        else {
            self.image = UIImage(named: "placeholder.png")// data: data!)
            //}
            //request.resume()*/
            //let request = urlSession!.dataTaskWithURL() { (data, response, error) -> Void in
            //    self.image = UIImage(data: data!)
            //}
            //request.resume()
        }
    }
}