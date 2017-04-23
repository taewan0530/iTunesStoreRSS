//
//  LookupScreenshotCellModel.swift
//  iTunesStoreRss
//
//  Created by taewan on 2017. 4. 23..
//  Copyright © 2017년 taewan. All rights reserved.
//

import Foundation




protocol LookupScreenshotCellModelType: ViewModelType {
    var title: String { get }
    var urls: [URL] { get }
}


struct LookupScreenshotCellModel: LookupTableCellType, LookupScreenshotCellModelType {
    
    let type: LookupCellType
    let title: String
    
    let urls: [URL]
    
    
    init(type: LookupCellType, urls: [URL]) {
        self.type = type
        self.title = type.title
        self.urls = urls
    }
}


