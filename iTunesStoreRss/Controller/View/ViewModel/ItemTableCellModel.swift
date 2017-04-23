//
//  ItemTableViewModel.swift
//  iTunesStoreRss
//
//  Created by taewan on 2017. 4. 20..
//  Copyright © 2017년 taewan. All rights reserved.
//

import Foundation


protocol ItemTableCellModelType: ViewModelType {
    
    var rank: Int  { get }
    var title: String { get }
    var imageURL: URL? { get }
}

struct ItemTableCellModel: ItemTableCellModelType {
    
    let rank: Int
    let title: String
    let imageURL: URL?
    
    init(rank: Int, model: ItemModel) {
        
        self.rank = rank
        self.title = model.title
        self.imageURL = model.imageURL
    }
}
