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
    let averageUserRating: Float
    
    let artworkURL: URL?
    
    let screenshotURLs: [URL]
    let description: String
    
    init(_ json: JSON) {
        
        self.trackCensoredName = json["trackCensoredName"].stringValue
        self.averageUserRating = json["averageUserRating"].floatValue
        
        self.artworkURL = URL(string: json["artworkUrl512"].stringValue)
        
        self.screenshotURLs = json["screenshotUrls"].arrayValue
            .flatMap { URL(string: $0.stringValue) }
        
        self.description = json["description"].stringValue
    }
}
