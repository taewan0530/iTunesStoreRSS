//
//  AppLookupTableCellModel.swift
//  iTunesStoreRss
//
//  Created by taewan on 2017. 4. 23..
//  Copyright © 2017년 taewan. All rights reserved.
//

import Foundation


enum LookupCellType {
    case screenshot(title: String)
    case content(title: String)
    case review
    
    var title: String {
        switch self {
        case .screenshot(let title):
            return title
        case .content(let title):
            return title
        case .review:
            return ""
        }
    }
    
}

protocol LookupTableCellType: ViewModelType {
    var type: LookupCellType { get }
}
