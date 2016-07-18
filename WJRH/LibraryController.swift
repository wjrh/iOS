//
//  LibraryController.swift
//  WJRH
//
//  Created by Eric Weber on 6/23/16.
//  Copyright © 2016 Eric Weber. All rights reserved.
//

import UIKit

class LibraryController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var programTableView: UITableView!
    private let programTemplateCellIdentifier = "template"
    private var showNames = [String]()
    
    private let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    private var tealInfo: TealInfo?
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        tealInfo = appDelegate.tealInfo!
        showNames = Array(tealInfo!.programs.keys).sort()
        //print(tealInfo!.programs.count)
        return tealInfo!.programs.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let programCell = tableView.dequeueReusableCellWithIdentifier("programTemplate", forIndexPath: indexPath) as! ProgramTableViewCell
        
        let showName = showNames[indexPath.item]
        //print("making \(showName) cell")
        programCell.tealProgram = tealInfo!.programs[showName]
        programCell.programNameLabel.text = tealInfo!.programs[showName]?.name
        if (tealInfo!.programs[showName]?.author != "<null>") {
            programCell.programAuthorLabel.text = tealInfo!.programs[showName]?.author
        } else {
            programCell.programAuthorLabel.text = ""
        }
        programCell.programImage.contentMode = .ScaleAspectFit
        programCell.programImage.image = tealInfo!.programs[showName]?.image
        
        programCell.tealProgram!.loadEpisodes( { self.appDelegate.reloadEpisodeTable() } )
        
        return programCell
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        appDelegate.programTable = programTableView
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(animated: Bool) {
        if !appDelegate.radioPlaying && !appDelegate.episodePlaying && !appDelegate.radioMuted {
            appDelegate.playRadio()
        }
    }
    
    /*func refreshLibraryTable() {
        if let table = self.programTableView {
            dispatch_async(dispatch_get_main_queue(), {
                table.reloadSections(NSIndexSet(index: 0) , withRowAnimation: .Automatic)
            })
        }
    }*/
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "ProgramSegue" , let destination = segue.destinationViewController as? ProgramController {
            //print(segue.destinationViewController)
            if let programTableViewCellSender = sender as? ProgramTableViewCell {
                destination.tealProgram = programTableViewCellSender.tealProgram
                //print(programTableViewCellSender.program!.name)
            }
        }
    }
}