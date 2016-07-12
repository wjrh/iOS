//
//  ProgramInfoController.swift
//  WJRH
//
//  Created by Eric Weber on 7/11/16.
//  Copyright © 2016 Eric Weber. All rights reserved.
//

import UIKit

class ProgramInfoController: UIViewController {
    var tealProgram: TealProgram?
    
    @IBOutlet weak var programNameLabel: UILabel!
    @IBOutlet weak var djNameLabel: UILabel!
    @IBOutlet weak var programTimeLabel: UILabel!
    @IBOutlet weak var programDescriptionLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        if let tealProgramUnwrapped = tealProgram {
            programNameLabel.text = tealProgramUnwrapped.name
            djNameLabel.text = tealProgramUnwrapped.author
            programTimeLabel.text = tealProgramUnwrapped.time
            programDescriptionLabel.text = tealProgramUnwrapped.description
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}