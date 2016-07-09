//
//  ProgramController.swift
//  WJRH
//
//  Created by Eric Weber on 7/1/16.
//  Copyright © 2016 Eric Weber. All rights reserved.
//

import UIKit

class ProgramController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var episodeTableView: UITableView!
    var tealProgram: TealProgram?
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tealProgram!.episodes.count + 1
    }
    
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) ->
        UITableViewCell {
        
        if (indexPath.item == 0) {
            let programHeader = tableView.dequeueReusableCellWithIdentifier("programHeader", forIndexPath: indexPath) as! ProgramTableViewCell
            if tealProgram != nil {
                programHeader.programImage.image = tealProgram!.image
                programHeader.programNameLabel.text = tealProgram!.name
                if tealProgram!.author != "<null>" {
                    programHeader.programAuthorLabel.text = tealProgram!.author
                } else {
                    programHeader.programAuthorLabel.text = ""
                }
            }
            
            return programHeader
        } else {
            let episodeCell = tableView.dequeueReusableCellWithIdentifier("episodeTemplate", forIndexPath: indexPath) as! EpisodeTableViewCell
            
            episodeCell.tealEpisode = tealProgram!.episodes[indexPath.item - 1]
            let episodeName = episodeCell.tealEpisode!.name!
            print(episodeName)
            let episodeImage = episodeCell.tealEpisode!.image
            var episodeDescription = ""
            if let episodeDescriptionUnwrapped = episodeCell.tealEpisode!.description {
                episodeDescription = episodeDescriptionUnwrapped
            }
            episodeCell.episodeNameLabel.text = episodeName
            episodeCell.episodeImage.image = episodeImage
            episodeCell.episodeDescriptionLabel.text = episodeDescription
            
            return episodeCell
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}