//
//  LookupReviewCellViewModel.swift
//  iTunesStoreRss
//
//  Created by taewan on 2017. 4. 24..
//  Copyright © 2017년 taewan. All rights reserved.
//

import Foundation

import RxSwift
import RxCocoa


protocol LookupReviewCellModelType: ViewModelType {
    var output: LookupReviewCellModelOuputType { get }
}

protocol LookupReviewCellModelOuputType: ViewModelType {
    var name: Driver<String> { get }
    var rating: Driver<Float> { get }
    var title: Driver<String> { get }
    var content: Driver<String> { get }
}

struct LookupReviewCellModel: LookupTableCellType, LookupReviewCellModelType, LookupReviewCellModelOuputType {
    var output: LookupReviewCellModelOuputType { return self }
 
    let type: LookupCellType
    
    var name: Driver<String>
    var rating: Driver<Float>
    var title: Driver<String>
    var content: Driver<String>
    
    init(type: LookupCellType, model: ReviewModel) {
        self.type = type
        
        self.name = Observable.just(model.name)
            .map { "\($0) 님 작성" }
            .asDriver(onErrorJustReturn: "-")
        
        self.rating = Observable.just(model.rating)
            .map { Float($0) ?? 0 }
            .asDriver(onErrorJustReturn: 0)
        
        self.title = Observable.just(model.title)
            .asDriver(onErrorJustReturn: "")
        
        self.content = Observable.just(model.content)
            .asDriver(onErrorJustReturn: "")
    }

}
