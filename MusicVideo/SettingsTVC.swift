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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Settings"
        
        tableView.alwaysBounceVertical = false
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(MusicVideoTVC.prefferedFontChanged), name: UIContentSizeCategoryDidChangeNotification, object: nil)
        
        touchID.on = NSUserDefaults.standardUserDefaults().boolForKey("SecSetting")
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
    
    func prefferedFontChanged () {
        
        aboutDisplay.font = UIFont.preferredFontForTextStyle(UIFontTextStyleSubheadline)
        feedbackDisplay.font = UIFont.preferredFontForTextStyle(UIFontTextStyleSubheadline)
        securityDisplay.font = UIFont.preferredFontForTextStyle(UIFontTextStyleSubheadline)
        bestImageDisplay.font = UIFont.preferredFontForTextStyle(UIFontTextStyleSubheadline)
        APICnt.font = UIFont.preferredFontForTextStyle(UIFontTextStyleSubheadline)
        
        
        print ("The preffered font has changed")
    }
    
    // The deinit is called everytime the object gets deallocated; we should remove the observer here
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIContentSizeCategoryDidChangeNotification, object: nil)
    }
}
