//
//  LookupContentCellModel.swift
//  iTunesStoreRss
//
//  Created by taewan on 2017. 4. 23..
//  Copyright © 2017년 taewan. All rights reserved.
//

import Foundation



protocol LookupContentCellModelType: ViewModelType {
    var title: String { get }
    var content: String { get }
}



struct LookupContentCellModel: LookupTableCellType, LookupContentCellModelType {
    
    let type: LookupCellType
    let title: String
    
    let content: String
    
    init(type: LookupCellType, content: String) {
        self.type = type
        self.title = type.title
        self.content = content
    }
}

