//
//  SettingsTVC.swift
//  MusicVideo
//
//  Created by Stella on 3/28/16.
//  Copyright © 2016 Stellz. All rights reserved.
//

import UIKit
import MessageUI

class SettingsTVC: UITableViewController, MFMailComposeViewControllerDelegate {

    @IBOutlet weak var aboutDisplay: UILabel!
    @IBOutlet weak var feedbackDisplay: UILabel!
    @IBOutlet weak var securityDisplay: UILabel!
    @IBOutlet weak var touchID: UISwitch!
    @IBOutlet weak var bestImageDisplay: UILabel!
    @IBOutlet weak var APICnt: UILabel!
    @IBOutlet weak var sliderCnt: UISlider!
    @IBOutlet weak var numberOfVideosDisplay: UILabel!
    @IBOutlet weak var dragTheSliderDisplay: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Settings"
        
        tableView.alwaysBounceVertical = false
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(MusicVideoTVC.prefferedFontChanged), name: UIContentSizeCategoryDidChangeNotification, object: nil)
        
        touchID.on = NSUserDefaults.standardUserDefaults().boolForKey("SecSetting")
        
        if (NSUserDefaults.standardUserDefaults().objectForKey("APICNT") != nil) {
            let theValue = NSUserDefaults.standardUserDefaults().objectForKey("APICNT") as! Int
            sliderCnt.value = Float(theValue)
            APICnt.text = "\(theValue)"
        } else {
            //for the very first time on installation of the app (if we don't want to deepnd on storyboard)
            sliderCnt.value = 10.0
            APICnt.text = "\(Int(sliderCnt.value))"
        }
    }
    
    @IBAction func touchIDSec(sender: UISwitch) {
        let defaults = NSUserDefaults.standardUserDefaults()
        
//        if touchID.on {
//            defaults.setBool(touchID.on, forKey: "SecSetting")
//        } else {
//            defaults.setBool(false, forKey: "SecSetting")
//        }
        
        defaults.setBool(touchID.on, forKey: "SecSetting")
    }
    
    @IBAction func valueChanged(sender: UISlider) {
        let defaults = NSUserDefaults.standardUserDefaults()
        defaults.setObject(Int(sliderCnt.value), forKey: "APICNT")
        APICnt.text = "\(Int(sliderCnt.value))"
    }
    
    func prefferedFontChanged () {
        
        aboutDisplay.font = UIFont.preferredFontForTextStyle(UIFontTextStyleBody)
        feedbackDisplay.font = UIFont.preferredFontForTextStyle(UIFontTextStyleBody)
        securityDisplay.font = UIFont.preferredFontForTextStyle(UIFontTextStyleBody)
        bestImageDisplay.font = UIFont.preferredFontForTextStyle(UIFontTextStyleBody)
        APICnt.font = UIFont.preferredFontForTextStyle(UIFontTextStyleBody)
        numberOfVideosDisplay.font = UIFont.preferredFontForTextStyle(UIFontTextStyleBody)
        dragTheSliderDisplay.font = UIFont.preferredFontForTextStyle(UIFontTextStyleSubheadline)
        
        
        print ("The preffered font has changed")
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath.section == 00 && indexPath.row == 1 {
            let mailComposeViewController = configureMail()
            if MFMailComposeViewController.canSendMail() {
                self.presentViewController(mailComposeViewController, animated: true, completion: nil)
            } else {
                // No email is setup on the Phone
                mailAlert()
            }
            
            tableView.deselectRowAtIndexPath(indexPath, animated: true)
        }
    }
    
    func mailAlert(){
        let alertController:UIAlertController = UIAlertController(title: "Alert", message: "No E-mail account setup for iPhone", preferredStyle: .Alert)
        let okAction = UIAlertAction(title: "OK", style: .Default) { action -> Void in
            // Do something if you want
        }
        alertController.addAction(okAction)
        self.presentViewController(alertController, animated: true, completion: nil)
    }
    
    func configureMail() -> MFMailComposeViewController {
        
        let mailComposeVC = MFMailComposeViewController()
        mailComposeVC.mailComposeDelegate = self
        mailComposeVC.setCcRecipients(["stel4e@gmail.com"])
        mailComposeVC.setSubject("Music Video App Feedback")
        mailComposeVC.setMessageBody("Hi Stella, \n\n I would like to share the following feedback...\n", isHTML: false)
        
        return mailComposeVC
    }
    
    func mailComposeController(controller: MFMailComposeViewController, didFinishWithResult result: MFMailComposeResult, error: NSError?) {
        switch result.rawValue {
        case MFMailComposeResultCancelled.rawValue:
            print("Mial cancelled")
        case MFMailComposeResultSaved.rawValue:
            print("Mial saved")
        case MFMailComposeResultSent.rawValue:
            print("Mial sent")
        case MFMailComposeResultFailed.rawValue:
            print("Mial failed")
        default:
            print("Unknown issue")
        }
        
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    // The deinit is called everytime the object gets deallocated; we should remove the observer here
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIContentSizeCategoryDidChangeNotification, object: nil)
    }
}
