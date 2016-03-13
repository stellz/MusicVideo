//
//  MusicVideo.swift
//  MusicVideo
//
//  Created by Stellz on 3/13/16.
//  Copyright © 2016 Stellz. All rights reserved.
//

import Foundation

class Videos {
    
    //Data encapsulation
    
    private (set) var vName:String
    private (set) var vImageUrl:String
    private (set) var vVideoUrl:String
    
    init (data: JSONDictionary) {
        
        //If we do not initialize all properties we will get error message
        //Return from initializer without initializing all stored properties
        
        //Video name
        
        if let name = data["im:name"] as? JSONDictionary,
            vName = name["label"] as? String {
                self.vName = vName
        } else {
            //You may not always get data back from the JSON - you may want to display a message
            //element in the JSON is unexpected
            vName = ""
        }
        
        //The video image
        
        if let img = data["im:image"] as? JSONArray,
            image = img[2] as? JSONDictionary,
            immage = image["label"] as? String {
                self.vImageUrl = immage.stringByReplacingOccurrencesOfString("100x100", withString: "600x600")
        } else {
            //You may not always get data back from the JSON - you may want to display a message
            //element in the JSON is unexpected
            vImageUrl = ""
        }
        
        //The video url
        
        if let video = data["link"] as? JSONArray,
            vUrl = video[1] as? JSONDictionary,
            vHref = vUrl["attributes"] as? JSONDictionary,
            vVideoUrl = vHref["href"] as? String {
                self.vVideoUrl = vVideoUrl
        } else {
            //You may not always get data back from the JSON - you may want to display a message
            //element in the JSON is unexpected
            vVideoUrl = ""
        }
    }
    
}