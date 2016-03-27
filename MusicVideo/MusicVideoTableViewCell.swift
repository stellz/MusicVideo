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
        
        musicTitle.font = UIFont.preferredFontForTextStyle(UIFontTextStyleSubheadline)
        rank.font = UIFont.preferredFontForTextStyle(UIFontTextStyleSubheadline)
        
        rank.text = ("\(video!.vRank)")
        musicTitle.text = video?.vName
        //musicImage.image = UIImage(named: "imageNotAvailable")
        
        if video!.vImageData != nil {
            print("Get data from the array...")
            musicImage.image = UIImage(data: video!.vImageData!)
        } else {
            GetVideoImage(video!, imageView: musicImage)
            print("Download images in background thread...")
        }
    
    }
    
    func GetVideoImage(video: MusicVideo, imageView : UIImageView) {
        
        // all network calls should be made not on the main thread
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) {
            let data = NSData (contentsOfURL: NSURL(string: video.vImageUrl)!)
            
            var image:UIImage?
            
            if data != nil {
                video.vImageData = data
                image = UIImage(data: data!)
                
            }
            
            //Move back to main queue because we must update the UI while in a block on another thread
            dispatch_async(dispatch_get_main_queue()) {
                imageView.image = image
            }
            
        }
    }
}
