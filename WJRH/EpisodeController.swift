//
//  EpisodeController.swift
//  WJRH
//
//  Created by Eric Weber on 7/9/16.
//  Copyright © 2016 Eric Weber. All rights reserved.
//

import UIKit

class EpisodeController: UIViewController {
    
    var tealEpisode: TealEpisode?
    @IBOutlet weak var episodeNameLabel: UILabel!
    @IBOutlet weak var episodeImage: UIImageView!
    @IBOutlet weak var episodeDescriptionLabel: UILabel!
    @IBOutlet weak var episodeReleaseLabel: UILabel!
    @IBOutlet weak var episodeDurationLabel: UILabel!
    @IBOutlet weak var playPauseButton: UIButton!
    private let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        if let tealEpisodeUnwrapped = tealEpisode {
            episodeNameLabel.text = tealEpisodeUnwrapped.name!
            episodeImage.image = tealEpisodeUnwrapped.image
            episodeDescriptionLabel.text = tealEpisodeUnwrapped.description
            let dateFormatter = NSDateFormatter()
            dateFormatter.dateStyle = NSDateFormatterStyle.MediumStyle
            episodeReleaseLabel.text = "Released on \(dateFormatter.stringFromDate(tealEpisodeUnwrapped.releaseDate!))"
            let durationHours = tealEpisodeUnwrapped.duration! / 3600
            let durationMinutes = (tealEpisodeUnwrapped.duration! % 3600) / 60
            let durationSeconds = tealEpisodeUnwrapped.duration! % 60
            episodeDurationLabel.text = String(format: "Duration: %0.2d:%0.2d:%0.2d", durationHours, durationMinutes, durationSeconds)
            appDelegate.episodePlaying = false
            appDelegate.loadEpisode(tealEpisodeUnwrapped.audioURL!)
        }
    }
    
    override func viewDidAppear(animated: Bool) {
        if appDelegate.episodePlaying {
            playPauseButton.setImage(UIImage(named: "PauseButton.png"), forState: UIControlState.Normal)
        } else {
            playPauseButton.setImage(UIImage(named: "PlayButton.png"), forState: UIControlState.Normal)
        }
        appDelegate.stopRadio()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction private func playPause(sender: UIButton) {
        if appDelegate.episodePlaying {
            appDelegate.pauseEpisode()
            playPauseButton.setImage(UIImage(named: "PlayButton.png"), forState: UIControlState.Normal)
        } else {
            appDelegate.playEpisode()
            playPauseButton.setImage(UIImage(named: "PauseButton.png"), forState: UIControlState.Normal)
        }
    }
}