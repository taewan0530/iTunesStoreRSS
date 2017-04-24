//
//  ItemTableViewModel.swift
//  iTunesStoreRss
//
//  Created by taewan on 2017. 4. 20..
//  Copyright © 2017년 taewan. All rights reserved.
//

import Foundation

import RxSwift
import RxCocoa

protocol ItemTableCellModelType: ViewModelType {
    var output: ItemTableCellModelOuputType { get }
}

protocol ItemTableCellModelOuputType: ViewModelType {
    var rank: Driver<String>  { get }
    var title: Driver<String> { get }
    var imageURL: Driver<URL?> { get }
}


struct ItemTableCellModel: ItemTableCellModelType, ItemTableCellModelOuputType {
    var output: ItemTableCellModelOuputType { return self }
    
    let rank: Driver<String>
    let title: Driver<String>
    let imageURL: Driver<URL?>
    
    init(rank: Int, model: ItemModel) {
        
        self.rank = Observable.just("\(rank)")
            .asDriver(onErrorJustReturn: "-")
        
        self.title = Observable.just(model.title)
            .asDriver(onErrorJustReturn: "-")
        
        self.imageURL = Observable.just(model.imageURL)
            .asDriver(onErrorJustReturn: nil)
    }
}
