//
//  TealInfo.swift
//  WJRH
//
//  Created by Eric Weber on 6/28/16.
//  Copyright © 2016 Eric Weber. All rights reserved.
//

import Foundation

class TealInfo {
    
    var currentSongName = ""
    var currentArtist = ""
    var currentShowName = ""
    var currentDJName = ""
    
    private var urlSession = NSURLSession.sharedSession()
    
    var programs: [String: TealProgram] = [:]
    
    init(imageLoadCallback: ((Void) -> Void)?) {
        reloadCurrentMetaData()
        
        let request = urlSession.dataTaskWithURL(NSURL(string: "https://api.teal.cool/organizations/wjrh/")!) { (data, response, error) -> Void in
            do {
                if let dataUnwrapped = data {
                    let resultAsJson = try NSJSONSerialization.JSONObjectWithData(dataUnwrapped, options: .AllowFragments)
                    for i in 0..<resultAsJson.count {
                        //print(resultAsJson[i]["name"]!!)
                        let showName = String(resultAsJson[i]["name"]!!)
                        let showShortName = String(resultAsJson[i]["shortname"]!!)
                        let showAuthor = String(resultAsJson[i]["author"]!!)
                        var showTime = ""
                        if let showTimeFromRequest = resultAsJson[i]["scheduled_time"]! {
                            showTime = String(showTimeFromRequest)
                        }
                        var showDescription = ""
                        if let showDescriptionFromRequest = resultAsJson[i]["description"]! {
                            showDescription = String(showDescriptionFromRequest)
                        }
                        let showImageUrl = String(resultAsJson[i]["image"]!!)
                        self.programs[showName] = TealProgram(name: showName, shortName: showShortName, author: showAuthor, time: showTime, description: showDescription, imageURL: showImageUrl, imageLoadCallback: imageLoadCallback, urlSession: self.urlSession)
                    }
                }
            } catch {
                print("Error loading log.")
            }
        }
        request.resume()
    }
    
    func reloadCurrentMetaData() {
        let request = urlSession.dataTaskWithURL(NSURL(string: "https://api.teal.cool/organizations/wjrh/latest")!) { (data, response, error) -> Void in
            
            do {
                if let dataUnwrapped = data {
                    let resultAsJson = try NSJSONSerialization.JSONObjectWithData(dataUnwrapped, options: .AllowFragments)
                    if let event = resultAsJson["event"]! {
                        let eventString = String(event)
                        if eventString == "episode-start" {
                            self.currentShowName = String(resultAsJson["program"]!!["name"]!!)
                            self.currentDJName = String(resultAsJson["program"]!!["author"]!!)
                            
                            self.currentSongName = ""
                            self.currentArtist = ""
                        } else if eventString == "track-log" {
                            //self.currentShowName = String(resultAsJson["program"]!!["name"]!!)
                            //self.currentDJName = String(resultAsJson["program"]!!["author"]!!)
                            
                            self.currentSongName = String(resultAsJson["track"]!!["title"]!!)
                            self.currentArtist = String(resultAsJson["track"]!!["artist"]!!)
                        } else if eventString == "episode-end" {
                            self.currentShowName = "WJRH Playlist"
                            self.currentDJName = "WJRH Robo DJ"
                            
                            self.currentSongName = ""
                            self.currentArtist = ""
                        }
                    }
                }
            } catch {
                print("Error loading log.")
            }
        }
        request.resume()
    }
}