//
//  MusicVideoTVC.swift
//  MusicVideo
//
//  Created by Stella on 3/25/16.
//  Copyright © 2016 Stellz. All rights reserved.
//

import UIKit

class MusicVideoTVC: UITableViewController {
    
    var videos = [MusicVideo]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(ViewController.reachabilityStatusChanged), name: "ReachStatusChanged", object: nil)
        
        reachabilityStatusChanged()
        
        //Call API
        let api = APIManager()
        api.loadData("https://itunes.apple.com/us/rss/topmusicvideos/limit=100/json", completion: didLoadData)
        
        //second version without separate function
        //        api.loadData("https://itunes.apple.com/us/rss/topmusicvideos/limit=10/json") {
        //            (result:String) in
        //            print(result)
        //        }
    }
    
    func didLoadData(videos:[MusicVideo]) {
        
        // we need to set the videos property with data otherwise it will be empty aray
        //that way the function printVideosInfo() will have what to print
        self.videos = videos
        printVideosInfo()
        
        //we can print the result directly here using the local var videos which comes with this function
        //to be more interesting we can print the index of the item along with the name; we need to  enumerate the videos array
        for (index, video) in videos.enumerate() {
            print("\(index) name = \(video.vName)")
        }
        
        tableView.reloadData()
    }
    
    func printVideosInfo() {
        for video in videos {
            print("name = \(video.vName)")
        }
    }
    
    func reachabilityStatusChanged () {
        switch reachabilityStatus {
        case NOACCESS:
            view.backgroundColor = UIColor.redColor()
        case WIFI:
            view.backgroundColor = UIColor.greenColor()
        case WWAN:
            view.backgroundColor = UIColor.yellowColor()
        default: return
        }
    }
    
    
    // The deinit is called everytime the object gets deallocated; we should remove the observer here
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self, name: "ReachStatusChanged", object: nil)
    }


    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return videos.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath)

        let video = videos[indexPath.row]
        cell.textLabel?.text = "\(indexPath.row+1)"
        cell.detailTextLabel?.text = video.vName

        return cell
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
