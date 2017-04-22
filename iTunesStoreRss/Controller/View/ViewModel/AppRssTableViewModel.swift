//
//  AppRssTableViewModel.swift
//  iTunesStoreRss
//
//  Created by taewan on 2017. 4. 20..
//  Copyright © 2017년 taewan. All rights reserved.
//

import Foundation


protocol AppRssTableViewModelType {
    
    var rank: Int  { get }
    var title: String { get }
    var imageURL: URL? { get }
}

struct AppRssTableViewModel: AppRssTableViewModelType {
    
    let rank: Int
    let title: String
    let imageURL: URL?
    
    init(rank: Int, model: RssModel) {
        
        self.rank = rank
        self.title = model.title
        self.imageURL = model.imageURL
    }
}
