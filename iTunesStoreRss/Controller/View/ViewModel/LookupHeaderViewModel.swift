//
//  LookupHeaderViewModel.swift
//  iTunesStoreRss
//
//  Created by taewan on 2017. 4. 23..
//  Copyright © 2017년 taewan. All rights reserved.
//

import Foundation


protocol LookupHeaderViewModelType: ViewModelType {
    var title: String { get }
    var artistName: String { get }
    var advisoryRating: String { get }
    
    var userRatingCount: Int { get }
    var averageUserRating: Float { get }
    
    var artworkURL: URL? { get }
}

struct LookupHeaderViewModel: LookupHeaderViewModelType {
    
    let title: String
    let artistName: String
    let advisoryRating: String
    
    let userRatingCount: Int
    let averageUserRating: Float
    
    let artworkURL: URL?
    
    init(_ item: ItemModel) {
        self.title = item.title
        self.artistName = item.artist
        self.artworkURL = item.imageURL
        self.advisoryRating = ""
        self.userRatingCount = 0
        self.averageUserRating = 0
    }
    
    init(_ model: LookupModel) {
        
        self.title = model.trackCensoredName
        self.artistName = model.artistName
        self.advisoryRating = model.contentAdvisoryRating
        self.userRatingCount = model.userRatingCountForCurrentVersion
        self.averageUserRating = model.averageUserRatingForCurrentVersion
        self.artworkURL = model.artworkURL
    }
}
