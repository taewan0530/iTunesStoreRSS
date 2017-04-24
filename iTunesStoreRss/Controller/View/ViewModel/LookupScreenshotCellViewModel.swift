//
//  LookupScreenshotCellModel.swift
//  iTunesStoreRss
//
//  Created by taewan on 2017. 4. 23..
//  Copyright © 2017년 taewan. All rights reserved.
//

import Foundation

import RxSwift
import RxCocoa
import RxDataSources

protocol LookupScreenshotCellViewModelType: ViewModelType {
    var output: LookupScreenshotCellViewModelOuputType { get }
}

protocol LookupScreenshotCellViewModelOuputType: ViewModelType {
    var title: Driver<String> { get }
    var sections: Driver<[SectionModel<Void, URL>]> { get }
}


struct LookupScreenshotCellViewModel: LookupTableCellType, LookupScreenshotCellViewModelType, LookupScreenshotCellViewModelOuputType {
    var output: LookupScreenshotCellViewModelOuputType { return self }
    
    let type: LookupCellType
    
    let title: Driver<String>
    let sections: Driver<[SectionModel<Void, URL>]>
    
    init(type: LookupCellType, urls: [URL]) {
        self.type = type
        
        self.title = Observable.just(type.title)
            .asDriver(onErrorJustReturn: "")

        self.sections = Observable.just(urls)
            .map { [SectionModel(model: Void(), items: $0)] }
            .asDriver(onErrorJustReturn: [])
    }
}


