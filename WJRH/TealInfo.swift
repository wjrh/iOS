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
    
    init() {
        reloadCurrentMetaData()
        
        let request = urlSession.dataTaskWithURL(NSURL(string: "https://api.teal.cool/organizations/wjrh/")!) { (data, response, error) -> Void in
            do {
                let resultAsJson = try NSJSONSerialization.JSONObjectWithData(data!, options: .AllowFragments)
                for i in 0...resultAsJson.count - 1 {
                    //print(resultAsJson[i]["name"]!!)
                    let showName = String(resultAsJson[i]["name"]!!)
                    let showAuthor = String(resultAsJson[i]["author"]!!)
                    let showImageUrl = String(resultAsJson[i]["image"]!!)
                    self.programs[showName] = TealProgram(name: showName, author: showAuthor, imageURL: showImageUrl, urlSession: self.urlSession)
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
                let resultAsJson = try NSJSONSerialization.JSONObjectWithData(data!, options: .AllowFragments)
                if let event = resultAsJson["event"]! {
                    let eventString = String(event)
                    if eventString == "episode-start" {
                        self.currentShowName = String(resultAsJson["program"]!!["name"]!!)
                        self.currentDJName = String(resultAsJson["program"]!!["author"]!!)
                        
                        self.currentSongName = ""
                        self.currentArtist = ""
                    }
                    if eventString == "track-log" {
                        self.currentShowName = String(resultAsJson["program"]!!["name"]!!)
                        self.currentDJName = String(resultAsJson["program"]!!["author"]!!)
                        
                        self.currentSongName = String(resultAsJson["track"]!!["title"]!!)
                        self.currentArtist = String(resultAsJson["track"]!!["artist"]!!)
                    }
                }
            } catch {
                print("Error loading log.")
            }
        }
        request.resume()
    }
}