//
//  RssModel.swift
//  iTunesStoreRss
//
//  Created by taewan on 2017. 4. 20..
//  Copyright © 2017년 taewan. All rights reserved.
//

import Foundation

import SwiftyJSON


struct ItemModel: JSONCollection {
    let id: String
    let title: String
    let imageURL: URL?
    
    let artist: String
    let category: String
    
    let linkURL: URL?
    //여기도 앱 url 넣자.
    init(_ json: JSON) {
        self.id = json["id"]["attributes"]["im:id"].stringValue
        self.title = json["im:name"]["label"].stringValue
        
        self.artist = json["im:artist"]["label"].stringValue
        self.category = json["category"]["label"].stringValue
        
        self.linkURL = URL(string: json["link"]["attributes"]["href"].stringValue)
        
        if let lastImage = json["im:image"].arrayValue.last {     
            self.imageURL = URL(string: lastImage["label"].stringValue)
        } else {
            self.imageURL = nil
        }
    }
}
