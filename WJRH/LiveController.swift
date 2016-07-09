//
//  LiveController.swift
//  WJRH
//
//  Created by Eric Weber on 6/23/16.
//  Copyright © 2016 Eric Weber. All rights reserved.
//

import UIKit
import AVFoundation

class LiveController: UIViewController {
    
    private var radioPlayer = AVPlayer()
    private var playing = false
    private var refreshLabelTimer = NSTimer()
    
    private var tealInfo: TealInfo?
    
    @IBOutlet weak var songNameLabel: UILabel!
    @IBOutlet weak var artistLabel: UILabel!
    @IBOutlet weak var showNameLabel: UILabel!
    @IBOutlet weak var djNameLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        tealInfo = appDelegate.tealInfo!
        
        do {
            try AVAudioSession.sharedInstance().setCategory( AVAudioSessionCategoryPlayAndRecord, withOptions: .DefaultToSpeaker)
            radioPlayer = AVPlayer(URL: NSURL(string:"http://wjrh.org:8000/WJRHlow")!)
            radioPlayer.play()
            playing = true
        } catch {
            print("Failed to open stream")
        }
        refreshLabelTimer = NSTimer.scheduledTimerWithTimeInterval(1.0, target: self, selector: #selector(LiveController.refreshLabels), userInfo: nil, repeats: true)
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
        songNameLabel.text = tealInfo!.currentSongName
        artistLabel.text = tealInfo!.currentArtist
        showNameLabel.text = tealInfo!.currentShowName
        djNameLabel.text = tealInfo!.currentDJName
        
        tealInfo!.reloadCurrentMetaData()
    }
}

