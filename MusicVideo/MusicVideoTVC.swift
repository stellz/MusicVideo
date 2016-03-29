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
    var filteredVideos = [MusicVideo]()
    let resultSearchController = UISearchController(searchResultsController:nil) // the search results will be displayed in the same view where we search - that's why it's nil
    
    var limit = 10
    
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var rank: UILabel!
    
    @IBOutlet weak var musicTitle: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(MusicVideoTVC.reachabilityStatusChanged), name: "ReachStatusChanged", object: nil)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(MusicVideoTVC.prefferedFontChanged), name: UIContentSizeCategoryDidChangeNotification, object: nil)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(MusicVideoTVC.apiCountChanged), name: kAPICountChangedNotification, object: nil)
        
        reachabilityStatusChanged()
        
        navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.redColor()]
        
        title = "The iTunes Top \(limit) Music Videos"
        
        // Setup the Search Controller
        
        //resultSearchController.searchResultsUpdater = self
        
        definesPresentationContext = true
        resultSearchController.dimsBackgroundDuringPresentation = false
        resultSearchController.searchBar.placeholder = "Search for Artist"
        resultSearchController.searchBar.searchBarStyle = UISearchBarStyle.Minimal
        
        // add the search bar to your tableview
        tableView.tableHeaderView = resultSearchController.searchBar
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
    
    func apiCountChanged() {
        runAPI()
        title = "The iTunes Top \(limit) Music Videos"
    }
    
    func prefferedFontChanged () {
        print ("The preffered font has changed")
    }
    
    func reachabilityStatusChanged () {
        switch reachabilityStatus {
        case NOACCESS:
            view.backgroundColor = UIColor.redColor()
            
            //we dispatch the func asynchronusly to make sure it will be presented after the main view is already on the screen; also when calling function in a closure we call it with self.
            
            //instead of using the dispatch we could show the alert in the viewDidLoad(), but that will lead to multiple function calls each time the view is shown, and we don't want that
            
            
            //self has a pointer to the closure; but the closure has a pointer to self itself -> this leads to retain cicle that's why we do [unowned self] in... ; it can also be [weak self] in ...
            dispatch_async(dispatch_get_main_queue()) {[unowned self] in
                self.showAlert()
            }
        default:
            if videos.count > 0 {
                print("Do not refresh api, don't make network calls")
            } else {
                runAPI()
            }
        }
    }
    
    func showAlert() {
        let alert = UIAlertController(title: "No Internet Access", message: "Please, make sure you are connected to the Internet", preferredStyle: .Alert)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .Default, handler: { action -> () in
            print("Cancel")
        })
        
        let deleteAction = UIAlertAction(title: "Delete", style: .Destructive, handler: { action -> () in
            print("Delete")
        })
        
        let okAction = UIAlertAction(title: "OK", style: .Default, handler: { action -> Void in
            print("OK")
            
            //do something if you want
            //alert.dismissViewControllerAnimated(true, completion: nil)
        })
        
        alert.addAction(okAction)
        alert.addAction(cancelAction)
        alert.addAction(deleteAction)
        
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    @IBAction func refresh(sender: UIRefreshControl) {
        refreshControl?.endRefreshing()
        runAPI()
        
        title = "The iTunes Top \(limit) Music Videos"
    }
    
    func getAPICount() {
        if (NSUserDefaults.standardUserDefaults().objectForKey("APICNT") != nil) {
            let theValue = NSUserDefaults.standardUserDefaults().objectForKey("APICNT") as! Int
            limit = theValue
        }
        
        let formatter = NSDateFormatter()
        formatter.dateFormat = "E, dd MMM yyyy HH:mm:ss"
        let refreshDate = formatter.stringFromDate(NSDate())
        
        refreshControl?.attributedTitle = NSAttributedString(string: "\(refreshDate)")
    }
    
    func runAPI() {
        
        getAPICount()
        
        //Call API
        let api = APIManager()
        api.loadData("https://itunes.apple.com/us/rss/topmusicvideos/limit=\(limit)/json", completion: didLoadData)
        
    }
    
    
    // The deinit is called everytime the object gets deallocated; we should remove the observer here
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self, name: "ReachStatusChanged", object: nil)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIContentSizeCategoryDidChangeNotification, object: nil)
    }


    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if resultSearchController.active {
            return filteredVideos.count
        }
        return videos.count
    }

    private struct storyboard {
        static let cellReuseIdentifier = "cell"
        static let segueIdentifier = "musicDetail"
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(storyboard.cellReuseIdentifier, forIndexPath: indexPath) as! MusicVideoTableViewCell

        if resultSearchController.active {
            cell.video = filteredVideos[indexPath.row]
        } else {
            cell.video = videos[indexPath.row]
        }

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

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == storyboard.segueIdentifier {
            if let indexPath = tableView.indexPathForSelectedRow {
                
                let video:MusicVideo
                
                if resultSearchController.active {
                    video = filteredVideos[indexPath.row]
                } else {
                    video = videos[indexPath.row]
                }
                
                let dvc = segue.destinationViewController as! MusicVideoDetailVC
                dvc.musicVideo = video
            }
        }
    }
    

}
