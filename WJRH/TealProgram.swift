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
    var shortName: String?
    var author: String?
    var image: UIImage?
    var episodes: [TealEpisode] = []
    var episodesLoaded = false
    private var urlSession: NSURLSession?
    
    init(name: String, shortName: String, author: String, imageURL: String, imageLoadCallback: ((Void) -> Void)?, urlSession: NSURLSession) {
        self.name = name
        self.shortName = shortName
        self.author = author
        self.urlSession = urlSession
        requestImage(imageURL, imageLoadCallback: imageLoadCallback)
    }
    
    private func requestImage(imageURL: String, imageLoadCallback: ((Void) -> Void)?) {
        if (imageURL != "<null>") {
            if (imageURL.rangeOfString("imgur") != nil) {
                if let lastDotRange = imageURL.rangeOfString(".", options: .BackwardsSearch) {
                    let lastDotIndex = lastDotRange.startIndex
                    let thumbnailImageURL = imageURL.substringToIndex(lastDotIndex) + "m" + imageURL.substringFromIndex(lastDotIndex) //http://api.imgur.com/models/image
                    let request = urlSession!.dataTaskWithURL(NSURL(string: thumbnailImageURL)!) { (data, response, error) -> Void in
                        //print("Loaded image")
                        self.image = UIImage(data: data!)
                        if let callBack = imageLoadCallback {
                            callBack()
                        }
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
            self.image = UIImage(named: "placeholder.png")
        }
    }
    
    func loadEpisodes() {
        if !episodesLoaded {
            let request = urlSession!.dataTaskWithURL(NSURL(string: "https://api.teal.cool/programs/\(shortName!)")!) { (data, response, error) -> Void in
                do {
                    let resultAsJson = try NSJSONSerialization.JSONObjectWithData(data!, options: .AllowFragments)
                    if let jsonEpisodes = resultAsJson["episodes"]!! as? [AnyObject] where resultAsJson["episodes"]!!.count > 0 {
                        for i in 0..<jsonEpisodes.count {
                            let episodeName = jsonEpisodes[i]["name"]!! as! String
                            var episodeDescription = "<null>"
                            if let episodeDescriptionFromRequest = jsonEpisodes[i]["description"]!! as? String {
                                episodeDescription = episodeDescriptionFromRequest
                            }
                            var episodeImageURL = "<null>"
                            if let episodeImageURLFromRequest = jsonEpisodes[i]["image"]!! as? String {
                                episodeImageURL = episodeImageURLFromRequest
                            }
                            let episode = TealEpisode(name: episodeName, description: episodeDescription, imageURL: episodeImageURL, imageLoadCallback: {}, urlSession: self.urlSession!, programImage: self.image!)
                            self.episodes.append(episode)
                        }
                    }
                    //print(resultAsJson)
                } catch {
                    print("Error loading episodes.")
                }
            }
            request.resume()
            episodesLoaded = true
        }
    }
}