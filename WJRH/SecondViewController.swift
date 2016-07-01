//
//  SecondViewController.swift
//  WJRH
//
//  Created by Eric Weber on 6/23/16.
//  Copyright © 2016 Eric Weber. All rights reserved.
//

import UIKit

class SecondViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var programTableView: UITableView!
    private let programTemplateCellIdentifier = "template"
    
    private let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    private var tealInfo: TealInfo?
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        tealInfo = appDelegate.tealInfo
        return tealInfo!.programs.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let programCell = tableView.dequeueReusableCellWithIdentifier("template", forIndexPath: indexPath) as! ProgramTableViewCell
        
        let showName = Array(tealInfo!.programs.keys)[indexPath.item]
        print("making \(showName) cell")
        programCell.programNameLabel.text = tealInfo!.programs[showName]?.name
        if (tealInfo!.programs[showName]?.author != "<null>") {
            programCell.programAuthorLabel.text = tealInfo!.programs[showName]?.author
        } else {
            programCell.programAuthorLabel.text = ""
        }
        programCell.programImage.contentMode = .ScaleAspectFit
        programCell.programImage.image = tealInfo!.programs[showName]?.image
        
        return programCell
    }
    
    func tableView(tableView: UITableView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        print("You selected cell #\(indexPath.item)!")
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

