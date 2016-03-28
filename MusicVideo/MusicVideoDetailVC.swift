//
//  MusicVideoDetailVC.swift
//  MusicVideo
//
//  Created by Stellz on 3/27/16.
//  Copyright © 2016 Stellz. All rights reserved.
//

import UIKit
import AVKit
import AVFoundation

class MusicVideoDetailVC: UIViewController {

    var musicVideo:MusicVideo!
    
    @IBOutlet weak var videoImage: UIImageView!
    @IBOutlet weak var vName: UILabel!
    @IBOutlet weak var vGenre: UILabel!
    @IBOutlet weak var vPrice: UILabel!
    @IBOutlet weak var vRights: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(MusicVideoTVC.prefferedFontChanged), name: UIContentSizeCategoryDidChangeNotification, object: nil)
        
        title = musicVideo.vArtist
        
        vName.text = musicVideo.vName
        vGenre.text = musicVideo.vGenre
        vPrice.text = musicVideo.vPrice
        vRights.text = musicVideo.vRights
        if musicVideo.vImageData != nil {
            videoImage.image = UIImage(data: musicVideo.vImageData!)
        } else {
            videoImage.image = UIImage(named: "imageNotAvailable")
        }
        
    }
    
    func prefferedFontChanged () {
        
        vName.font = UIFont.preferredFontForTextStyle(UIFontTextStyleHeadline)
        vGenre.font = UIFont.preferredFontForTextStyle(UIFontTextStyleHeadline)
        vPrice.font = UIFont.preferredFontForTextStyle(UIFontTextStyleHeadline)
        vRights.font = UIFont.preferredFontForTextStyle(UIFontTextStyleSubheadline)
        
        print ("The preffered font has changed")
    }
    
    @IBAction func socialMedia(sender: UIBarButtonItem) {
        
        shareMedia()
    }
    
    func shareMedia() {
        
        let activity1 = "Have yo had the opportunity to see this Music Video?"
        let activity2 = "\(musicVideo.vName) by \(musicVideo.vArtist)"
        let activity3 = "Whatch it and tell me what you think"
        let activity4 = musicVideo.vLinkToiTunes
        let activity5 = "Shared with the Music Video App - Step It UP!"
        
        let activityViewController = UIActivityViewController(activityItems: [activity1, activity2, activity3, activity4, activity5], applicationActivities: nil)
        
        //activityViewController.excludedActivityTypes = [UIActivityTypeMail]
        
        //activityViewController.excludedActivityTypes = [UIActivityTypePostToTwitter,UIActivityTypePostToVimeo]
        
        activityViewController.completionWithItemsHandler = {
            (activity, success, items, error) in
            
            if activity == UIActivityTypeMail {
                print("Email selected")
            }
        }
        
        self.presentViewController(activityViewController, animated: true, completion: nil)
    }
    
    @IBAction func playVideo(sender: UIBarButtonItem) {
        
        let url = NSURL(string: musicVideo.vVideoUrl)!
        let player = AVPlayer(URL: url)
        let playerViewController = AVPlayerViewController()
        
        playerViewController.player = player
        self.presentViewController(playerViewController, animated: true) { 
            playerViewController.player?.play()
        }
        
    }
    // The deinit is called everytime the object gets deallocated; we should remove the observer here
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIContentSizeCategoryDidChangeNotification, object: nil)
    }
    
}
