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
import LocalAuthentication

class MusicVideoDetailVC: UIViewController {

    var musicVideo:MusicVideo!
    
    var securitySwitch:Bool = false
    
    @IBOutlet weak var videoImage: UIImageView!
    @IBOutlet weak var vName: UILabel!
    @IBOutlet weak var vGenre: UILabel!
    @IBOutlet weak var vPrice: UILabel!
    @IBOutlet weak var vRights: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(MusicVideoDetailVC.prefferedFontChanged), name: UIContentSizeCategoryDidChangeNotification, object: nil)
        
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
        securitySwitch = NSUserDefaults.standardUserDefaults().boolForKey("SecSetting")
        
        switch securitySwitch {
        case true:
            touchIdCheck()
        default:
            shareMedia()
        }
    }
    
    func touchIdCheck() {
        
        // Create an alert
        let alert = UIAlertController(title: "", message: "", preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "Continue", style: UIAlertActionStyle.Cancel, handler: nil))
        
        
        // Create the Local Authentication Context
        let context = LAContext()
        var touchIDError : NSError?
        let reasonString = "Touch-Id authentication is needed to share info on Social Media"
        
        
        // Check if we can access local device authentication
        if context.canEvaluatePolicy(LAPolicy.DeviceOwnerAuthenticationWithBiometrics, error:&touchIDError) {
            // Check what the authentication response was
            context.evaluatePolicy(LAPolicy.DeviceOwnerAuthenticationWithBiometrics, localizedReason: reasonString, reply: { (success, policyError) -> Void in
                if success {
                    // User authenticated using Local Device Authentication Successfully!
                    dispatch_async(dispatch_get_main_queue()) { [unowned self] in
                        self.shareMedia()
                    }
                } else {
                    
                    alert.title = "Unsuccessful!"
                    
                    switch LAError(rawValue: policyError!.code)! {
                        
                    case .AppCancel:
                        alert.message = "Authentication was cancelled by application"
                        
                    case .AuthenticationFailed:
                        alert.message = "The user failed to provide valid credentials"
                        
                    case .PasscodeNotSet:
                        alert.message = "Passcode is not set on the device"
                        
                    case .SystemCancel:
                        alert.message = "Authentication was cancelled by the system"
                        
                    case .TouchIDLockout:
                        alert.message = "Too many failed attempts."
                        
                    case .UserCancel:
                        alert.message = "You cancelled the request"
                        
                    case .UserFallback:
                        alert.message = "Password not accepted, must use Touch-ID"
                        
                    default:
                        alert.message = "Unable to Authenticate!"
                        
                    }
                    
                    // Show the alert
                    dispatch_async(dispatch_get_main_queue()) { [unowned self] in
                        self.presentViewController(alert, animated: true, completion: nil)
                    }
                }
            })
        } else {
            // Unable to access local device authentication
            
            // Set the error title
            alert.title = "Error"
            
            // Set the error alert message with more information
            switch LAError(rawValue: touchIDError!.code)! {
                
            case .TouchIDNotEnrolled:
                alert.message = "Touch ID is not enrolled"
                
            case .TouchIDNotAvailable:
                alert.message = "TouchID is not available on the device"
                
            case .PasscodeNotSet:
                alert.message = "Passcode has not been set"
                
            case .InvalidContext:
                alert.message = "The context is invalid"
                
            default:
                alert.message = "Local Authentication not available"
            }
            
            // Show the alert
            dispatch_async(dispatch_get_main_queue()) { [unowned self] in
                self.presentViewController(alert, animated: true, completion: nil)
            }
        }
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
