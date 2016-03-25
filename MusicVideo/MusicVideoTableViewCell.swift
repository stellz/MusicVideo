//
//  MusicVideoTableViewCell.swift
//  MusicVideo
//
//  Created by Stella on 3/25/16.
//  Copyright © 2016 Stellz. All rights reserved.
//

import UIKit

class MusicVideoTableViewCell: UITableViewCell {

    @IBOutlet weak var musicImage: UIImageView!

    @IBOutlet weak var rank: UILabel!
    
    @IBOutlet weak var musicTitle: UILabel!
    
    var video:MusicVideo? {
        didSet {
            updateCell()
        }
    }
    
    func updateCell() {
        
        rank.text = ("\(video!.vRank)")
        musicTitle.text = video?.vName
        musicImage.image = UIImage(named: "imageNotAvailable")
    
    }
}
