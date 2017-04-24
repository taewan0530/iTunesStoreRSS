//
//  LookupHeaderViewModel.swift
//  iTunesStoreRss
//
//  Created by taewan on 2017. 4. 23..
//  Copyright © 2017년 taewan. All rights reserved.
//

import Foundation

import RxSwift
import RxCocoa


protocol LookupHeaderViewModelType: ViewModelType {
    var output: LookupHeaderViewModelOuputType { get }
    var input: LookupHeaderViewModelInputType { get }
}

protocol LookupHeaderViewModelInputType: ViewModelType {
    var actionDidTap: PublishSubject<Void> { get }
}

protocol LookupHeaderViewModelOuputType: ViewModelType {
    var title: Driver<String> { get }
    var artistName: Driver<String> { get }
    var advisoryRating: Driver<String> { get }
    
    var userRatingCount: Driver<String> { get }
    var averageUserRating: Driver<Float> { get }
    
    var openURL: Driver<URL?> { get }
    var artworkURL: Driver<URL?> { get }
    
    var isAdvisoryRatingHidden: Driver<Bool> { get }
    var isRatingCountHidden: Driver<Bool> { get }
    var isStarRatingHidden: Driver<Bool> { get }
}

struct LookupHeaderViewModel: LookupHeaderViewModelType, LookupHeaderViewModelInputType, LookupHeaderViewModelOuputType {
    var input: LookupHeaderViewModelInputType { return self }
    var output: LookupHeaderViewModelOuputType { return self }
    
    let actionDidTap: PublishSubject<Void> = .init()
    
    let title: Driver<String>
    let artistName: Driver<String>
    let advisoryRating: Driver<String>
    
    let userRatingCount: Driver<String>
    let averageUserRating: Driver<Float>
    
    let openURL: Driver<URL?>
    let artworkURL: Driver<URL?>
    
    
    let isAdvisoryRatingHidden: Driver<Bool>
    let isRatingCountHidden: Driver<Bool>
    let isStarRatingHidden: Driver<Bool>
    
    init(_ item: ItemModel) {
        self.title = Observable.just(item.title)
            .asDriver(onErrorJustReturn: "")
        
        self.artistName = Observable.just(item.artist)
            .asDriver(onErrorJustReturn: "")
        
        self.artworkURL = Observable.just(item.imageURL)
            .asDriver(onErrorJustReturn: nil)
        
        self.advisoryRating = Observable.just("")
            .asDriver(onErrorJustReturn: "")
        
        self.userRatingCount = Observable.just("")
            .asDriver(onErrorJustReturn: "")
        
        self.averageUserRating = Observable.just(0)
            .asDriver(onErrorJustReturn: 0)
        
        self.openURL = Observable.just(nil)
            .asDriver(onErrorJustReturn: nil)
        
        let isHidden = Observable.just(true)
            .asDriver(onErrorJustReturn: true)
        
        self.isAdvisoryRatingHidden = isHidden
        self.isRatingCountHidden = isHidden
        self.isStarRatingHidden = isHidden
    }
    
    init(_ model: LookupModel) {
        //input
        self.openURL = self.actionDidTap
            .map { _ in
                model.trackViewUrl
            }.asDriver(onErrorJustReturn: nil)
        
        
        //ouput
        self.title = Observable.just(model.trackCensoredName)
            .asDriver(onErrorJustReturn: "")
        
        self.artistName = Observable.just(model.artistName)
            .asDriver(onErrorJustReturn: "")
        
        self.artworkURL = Observable.just(model.artworkURL)
            .asDriver(onErrorJustReturn: nil)
        
        self.advisoryRating = Observable.just(model.contentAdvisoryRating)
            .asDriver(onErrorJustReturn: "")
        
        self.userRatingCount = Observable.just(model.userRatingCountForCurrentVersion)
            .map { $0 == 0 ? "" : "(\($0))"}
            .asDriver(onErrorJustReturn: "")
        
        self.averageUserRating = Observable.just(model.averageUserRatingForCurrentVersion)
            .asDriver(onErrorJustReturn: 0)
        
        self.isAdvisoryRatingHidden = self.advisoryRating.map { $0.isEmpty }
        
        self.isRatingCountHidden = self.userRatingCount.map { $0.isEmpty }
        self.isStarRatingHidden = self.averageUserRating.map { $0 == 0 }
        
    }
}
