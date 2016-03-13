//
//  ViewController.swift
//  MusicVideo
//
//  Created by Stellz on 3/13/16.
//  Copyright © 2016 Stellz. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Call API
        let api = APIManager()
       // api.loadData("https://itunes.apple.com/us/rss/topmusicvideos/limit=10/json", completion: didLoadData)
        
        api.loadData("https://itunes.apple.com/us/rss/topmusicvideos/limit=10/json") {
            (result:String) in
            print(result)
        }
    }
    
//    func didLoadData(result:String) {
//        print(result)
//    }

}

