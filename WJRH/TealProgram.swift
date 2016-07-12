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
    var time: String?
    var description: String?
    var image: UIImage?
    var episodes: [TealEpisode] = []
    var episodesLoaded = false
    private var urlSession: NSURLSession?
    
    init(name: String, shortName: String, author: String, time: String, description: String, imageURL: String, imageLoadCallback: ((Void) -> Void)?, urlSession: NSURLSession) {
        self.name = name
        self.shortName = shortName
        self.author = author
        self.time = time
        self.description = description
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
                            var episodeDuration = 0
                            if let episodeDurationFromRequest = jsonEpisodes[i]["length"]!! as? String {
                                episodeDuration = Int(episodeDurationFromRequest)!
                            }
                            var episodeAudioURL = ""
                            if let episodeAudioURLFromRequest = jsonEpisodes[i]["audio_url"]!! as? String {
                                episodeAudioURL = episodeAudioURLFromRequest
                            }
                            var episodeReleaseDate = ""
                            if let episodeReleaseDateFromRequest = jsonEpisodes[i]["pubdate"]!! as? String {
                                episodeReleaseDate = episodeReleaseDateFromRequest
                            }
                            var episodeImageURL = "<null>"
                            if let episodeImageURLFromRequest = jsonEpisodes[i]["image"]!! as? String {
                                episodeImageURL = episodeImageURLFromRequest
                            }
                            let episode = TealEpisode(name: episodeName, description: episodeDescription, duration: episodeDuration, audioURL: episodeAudioURL, releaseDate: episodeReleaseDate, imageURL: episodeImageURL, imageLoadCallback: {}, urlSession: self.urlSession!, programImage: self.image!)
                            self.episodes.append(episode)
                        }
                    }
                    self.episodes = self.episodes.sort() { (firstEpisode, secondEpisode) -> Bool in
                        if firstEpisode.releaseDate!.compare(secondEpisode.releaseDate!) == NSComparisonResult.OrderedDescending {
                            return true
                        } else {
                            return false
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