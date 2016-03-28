//
//  SettingsTVC.swift
//  MusicVideo
//
//  Created by Stella on 3/28/16.
//  Copyright © 2016 Stellz. All rights reserved.
//

import UIKit

class SettingsTVC: UITableViewController {

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
    
    // The deinit is called everytime the object gets deallocated; we should remove the observer here
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIContentSizeCategoryDidChangeNotification, object: nil)
    }
}
