//
//  LookupContentCellModel.swift
//  iTunesStoreRss
//
//  Created by taewan on 2017. 4. 23..
//  Copyright © 2017년 taewan. All rights reserved.
//

import Foundation

import RxSwift
import RxCocoa


protocol LookupContentCellModelType: ViewModelType {
    var output: LookupContentCellModelOuputType { get }
}

protocol LookupContentCellModelOuputType: ViewModelType {
    var title: Driver<String> { get }
    var content: Driver<String> { get }
}


struct LookupContentCellModel: LookupTableCellType, LookupContentCellModelType, LookupContentCellModelOuputType {
    
    var output: LookupContentCellModelOuputType { return self }

    
    let type: LookupCellType
    
    let title: Driver<String>
    let content: Driver<String>
    
    init(type: LookupCellType, content: String) {
        self.type = type
        
        self.title = Observable.just(type.title)
            .asDriver(onErrorJustReturn: "")
        
        self.content = Observable.just(content)
            .asDriver(onErrorJustReturn: "")
    }
}

