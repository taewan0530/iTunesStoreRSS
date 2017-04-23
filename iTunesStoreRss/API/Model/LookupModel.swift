//
//  LookupModel.swift
//  iTunesStoreRss
//
//  Created by taewan on 2017. 4. 20..
//  Copyright © 2017년 taewan. All rights reserved.
//

import Foundation

import SwiftyJSON


struct LookupModel: ObjectSerializable {
    
    let trackCensoredName: String
    let artistName: String
    
    let contentAdvisoryRating: String
    
    let userRatingCountForCurrentVersion: Int
    let averageUserRatingForCurrentVersion: Float
    
    let artworkURL: URL?
    
    
    let screenshotURLs: [URL]
    
    let releaseNotes: String
    let description: String
    
    init(_ json: JSON) {
        self.trackCensoredName = json["trackCensoredName"].stringValue
        self.artistName = json["artistName"].stringValue
        
        self.contentAdvisoryRating = json["contentAdvisoryRating"].stringValue
        
        self.userRatingCountForCurrentVersion = json["userRatingCountForCurrentVersion"].intValue
        self.averageUserRatingForCurrentVersion = json["averageUserRatingForCurrentVersion"].floatValue
        
        
        self.artworkURL = URL(string: json["artworkUrl512"].stringValue)
        
        self.screenshotURLs = json["screenshotUrls"].arrayValue
            .flatMap { URL(string: $0.stringValue) }
        
        self.releaseNotes = json["releaseNotes"].stringValue
        self.description = json["description"].stringValue
    }
}
