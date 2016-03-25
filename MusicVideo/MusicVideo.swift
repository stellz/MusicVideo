//
//  MusicVideo.swift
//  MusicVideo
//
//  Created by Stellz on 3/13/16.
//  Copyright © 2016 Stellz. All rights reserved.
//

import Foundation

class MusicVideo {
    
    var vRank = 0
    
    //Data encapsulation
    private (set) var vName:String
    private (set) var vImageUrl:String
    private (set) var vVideoUrl:String
    private (set) var vRights:String
    private (set) var vPrice:String
    private (set) var vArtist:String
    private (set) var vImid:String
    private (set) var vGenre:String
    private (set) var vLinkToiTunes:String
    private (set) var vReleaseDate:String
    
    //This variable gets created from the UI
    var vImageData:NSData?
    
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
            vImageUrl = ""
        }
        
        //The video url
        
        if let video = data["link"] as? JSONArray,
            vUrl = video[1] as? JSONDictionary,
            vHref = vUrl["attributes"] as? JSONDictionary,
            vVideoUrl = vHref["href"] as? String {
                self.vVideoUrl = vVideoUrl
        } else {
            vVideoUrl = ""
        }
        
        //Video rights
        
        if let rights = data["rights"] as? JSONDictionary,
            vRights = rights["label"] as? String {
                self.vRights = vRights
        } else {
            vRights = ""
        }
        
        //Video price
        
        if let price = data["im:price"] as? JSONDictionary,
            vPrice = price["label"] as? String {
                self.vPrice = vPrice
        } else {
            vPrice = ""
        }
        
        //Video artist
        
        if let artist = data["im:artist"] as? JSONDictionary,
            vArtist = artist["label"] as? String {
                self.vArtist = vArtist
        } else {
            vArtist = ""
        }
        
        //Video id
        
        if let imid = data["id"] as? JSONDictionary,
            immid = imid["attributes"] as? JSONDictionary,
            vImid = immid["im:id"] as? String {
                self.vImid = vImid
        } else {
            vImid = ""
        }
        
        //Video genre
        
        if let genre = data["category"] as? JSONDictionary,
            ggenre = genre["attributes"] as? JSONDictionary,
            vGenre = ggenre["label"] as? String {
                self.vGenre = vGenre
        } else {
            vGenre = ""
        }
        
        //The video link to iTunes
        
        if let link = data["link"] as? JSONArray,
            vHref = link[0] as? JSONDictionary,
            vLinkiTunes = vHref["href"] as? String {
                self.vLinkToiTunes = vLinkiTunes
        } else {
            vLinkToiTunes = ""
        }
        
        //Video release date
        
        if let date = data["im:releaseDate"] as? JSONDictionary,
            vDate = date["attributes"] as? JSONDictionary,
            vReleaseDate = vDate["label"] as? String {
                self.vReleaseDate = vReleaseDate
        } else {
            vReleaseDate = ""
        }

    }
    
}