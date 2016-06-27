//
//  FirstViewController.swift
//  WJRH
//
//  Created by Eric Weber on 6/23/16.
//  Copyright © 2016 Eric Weber. All rights reserved.
//

import UIKit
import AVFoundation

class FirstViewController: UIViewController {
    
    private var radioPlayer = AVPlayer()
    private var playing = false
    private var loop = NSTimer()
    private var urlSession = NSURLSession.sharedSession()
    
    private var songName = "none"
    private var artist = "none"
    private var showName = "none"
    private var djName = "none"
    
    @IBOutlet weak var songNameLabel: UILabel!
    @IBOutlet weak var artistLabel: UILabel!
    @IBOutlet weak var showNameLabel: UILabel!
    @IBOutlet weak var djNameLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        do {
            try AVAudioSession.sharedInstance().setCategory( AVAudioSessionCategoryPlayAndRecord, withOptions: .DefaultToSpeaker)
            radioPlayer = AVPlayer(URL: NSURL(string:"http://wjrh.org:8000/WJRHlow")!)
            radioPlayer.play()
            playing = true
        } catch {
            print("Failed to open stream")
        }
        loop = NSTimer.scheduledTimerWithTimeInterval(1.0, target: self, selector: #selector(FirstViewController.refreshLabels), userInfo: nil, repeats: true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func muteStream(sender: UIButton) {
        if playing {
            radioPlayer.volume = 0.0
            playing = false
        } else {
            radioPlayer.volume = 1.0
            playing = true
        }
    }
    
    func refreshLabels() {
        songNameLabel.text = songName
        artistLabel.text = artist
        showNameLabel.text = showName
        djNameLabel.text = djName
        let request = urlSession.dataTaskWithURL(NSURL(string: "https://api.teal.cool/organizations/wjrh/latest")!) { (data, response, error) -> Void in
            
            do {
                let resultAsJson = try NSJSONSerialization.JSONObjectWithData(data!, options: .AllowFragments)
                if let event = resultAsJson["event"]! {
                    let eventString = String(event)
                    if eventString == "episode-start" {
                        self.showName = String(resultAsJson["program"]!!["name"]!!)
                        self.djName = String(resultAsJson["program"]!!["author"]!!)
                    }
                    if eventString == "track-log" {
                        self.showName = String(resultAsJson["program"]!!["name"]!!)
                        self.djName = String(resultAsJson["program"]!!["author"]!!)
                        
                        self.songName = String(resultAsJson["track"]!!["title"]!!)
                        self.artist = String(resultAsJson["track"]!!["artist"]!!)
                    }
                }
            } catch {
                print("Error loading log.")
            }
        }
        request.resume()
    }
}

