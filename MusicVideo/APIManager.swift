//
//  APIManager.swift
//  MusicVideo
//
//  Created by Stellz on 3/13/16.
//  Copyright © 2016 Stellz. All rights reserved.
//

import Foundation


class APIManager {
    func loadData(urlString:String, completion:(result:String)->Void) {
        let config = NSURLSessionConfiguration.ephemeralSessionConfiguration()
        let session = NSURLSession(configuration: config)
        //let session = NSURLSession.sharedSession()
        let url = NSURL(string:urlString)!
        
        let task = session.dataTaskWithURL(url) {
            (data, response, error) -> Void in
            
            dispatch_async(dispatch_get_main_queue()) {
                if error != nil {
                    completion (result: error!.localizedDescription)
                }
                else {
                    //Added for JSONSerialization
                    do {
                    /* .AllowFragments - top level object is not Array or SDictionary
                        Any type of string or value
                        NSJASONSerialization requires the Do / Try / Catch
                        Converts the NSDATA into a JSON object and cast it to a Dictionary */
                        if let json = try NSJSONSerialization.JSONObjectWithData(data!, options: .AllowFragments)
                            as? JSONDictionary {
                                print(json)
                                
                                let priority = DISPATCH_QUEUE_PRIORITY_HIGH
                                dispatch_async(dispatch_get_global_queue(priority, 0)){
                                    dispatch_async(dispatch_get_main_queue()){
                                        completion (result: "JSONSerialization Successful")
                                    }
                                }
                        }
                    }
                    catch {
                        dispatch_async(dispatch_get_main_queue()){
                            completion (result: "error in JSONSerialization")
                        }

                    }
                }
            }
        }
        task.resume()
    }
}