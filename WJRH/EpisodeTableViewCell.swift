//
//  EpisodeTableViewCell.swift
//  WJRH
//
//  Created by Eric Weber on 7/3/16.
//  Copyright © 2016 Eric Weber. All rights reserved.
//

import Foundation
import UIKit

class EpisodeTableViewCell: UITableViewCell {
    
    var tealEpisode: TealEpisode?
    
    @IBOutlet weak var episodeNameLabel: UILabel!
    @IBOutlet weak var episodeImage: UIImageView!
    @IBOutlet weak var episodeDescriptionLabel: UILabel!
}