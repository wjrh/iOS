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
    
    private var refreshLabelTimer = NSTimer()
    private var tealInfo: TealInfo?
    private var appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    
    @IBOutlet weak var songNameLabel: UILabel!
    @IBOutlet weak var artistLabel: UILabel!
    @IBOutlet weak var showNameLabel: UILabel!
    @IBOutlet weak var djNameLabel: UILabel!
    @IBOutlet weak var muteButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        tealInfo = appDelegate.tealInfo!
        
        appDelegate.playRadio()
        
        refreshLabelTimer = NSTimer.scheduledTimerWithTimeInterval(1.0, target: self, selector: #selector(LiveController.refreshLabels), userInfo: nil, repeats: true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(animated: Bool) {
        if !appDelegate.radioPlaying && !appDelegate.episodePlaying && !appDelegate.radioMuted {
            appDelegate.playRadio()
        }
        if appDelegate.radioPlaying {
            muteButton.setImage(UIImage(named: "MuteRadio.png"), forState: UIControlState.Normal)
        } else {
            muteButton.setImage(UIImage(named: "PlayRadio.png"), forState: UIControlState.Normal)
        }
    }
    
    @IBAction func muteUnmuteRadio(sender: UIButton) {
        if appDelegate.radioPlaying {
            appDelegate.stopRadio()
            appDelegate.radioMuted = true
            muteButton.setImage(UIImage(named: "PlayRadio.png"), forState: UIControlState.Normal)
        } else {
            appDelegate.pauseEpisode()
            appDelegate.playRadio()
            appDelegate.radioMuted = false
            muteButton.setImage(UIImage(named: "MuteRadio.png"), forState: UIControlState.Normal)
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

