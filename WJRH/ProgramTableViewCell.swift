//
//  ProgramTableViewCell.swift
//  WJRH
//
//  Created by Eric Weber on 6/28/16.
//  Copyright © 2016 Eric Weber. All rights reserved.
//

import Foundation
import UIKit

class ProgramTableViewCell: UITableViewCell {
    
    var tealProgram: TealProgram?
    
    @IBOutlet weak var programNameLabel: UILabel!
    @IBOutlet weak var programImage: UIImageView!
    @IBOutlet weak var programAuthorLabel: UILabel!
}