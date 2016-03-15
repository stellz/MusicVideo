//
//  ViewController.swift
//  MusicVideo
//
//  Created by Stellz on 3/13/16.
//  Copyright © 2016 Stellz. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    var videos = [Videos]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Call API
        let api = APIManager()
        api.loadData("https://itunes.apple.com/us/rss/topmusicvideos/limit=10/json", completion: didLoadData)
       
        //second version without separate function
//        api.loadData("https://itunes.apple.com/us/rss/topmusicvideos/limit=10/json") {
//            (result:String) in
//            print(result)
//        }
    }
    
    func didLoadData(videos:[Videos]) {
        
        // we need to set the videos property with data otherwise it will be empty aray
        //that way the function printVideosInfo() will have what to print
        self.videos = videos
        printVideosInfo()
        
        //we can print the result directly here using the local var videos which comes with this function
        //to be more interesting we can print the index of the item along with the name; we need to  enumerate the videos array
        for (index, video) in videos.enumerate() {
            print("\(index) name = \(video.vName)")
        }

    }
    
    func printVideosInfo(){
        for video in videos {
            print("name = \(video.vName)")
        }
    }

}

