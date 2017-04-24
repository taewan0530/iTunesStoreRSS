//
//  ReviewModel.swift
//  iTunesStoreRSS
//
//  Created by taewan on 2017. 4. 24..
//  Copyright © 2017년 taewan. All rights reserved.
//

import Foundation

import SwiftyJSON

struct ReviewModel: JSONCollection {
    
    var isEmpty: Bool {
        return name.isEmpty && rating.isEmpty
    }
    
    let name: String
    let rating: String
    
    let title: String
    let content: String
    
    init(_ json: JSON) {
        self.name = json["author"]["name"]["label"].stringValue
        self.rating = json["im:rating"]["label"].stringValue
        self.title = json["title"]["label"].stringValue
        self.content = json["content"]["label"].stringValue
    }
}
