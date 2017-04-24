//
//  AppLookupViewModel.swift
//  iTunesStoreRss
//
//  Created by taewan on 2017. 4. 20..
//  Copyright © 2017년 taewan. All rights reserved.
//

import Foundation

import RxSwift
import RxCocoa
import RxDataSources

struct LookupSectionData {
    var items: [Item]
}

enum LookupServiceType {
    case lookup
    case review
}

protocol LookupViewModelType: ViewModelType {
    var input: LookupViewModelInputType { get }
    var output: LookupViewModelOutputType { get }
}

protocol LookupViewModelInputType {
    var shareDidTap: PublishSubject<Void> { get }
    var refresh: PublishSubject<LookupServiceType> { get }
}

protocol LookupViewModelOutputType {
    var loadCompleted: Observable<Void> { get }
    var header: Driver<LookupHeaderViewModelType?> { get }
    var sections: Driver<[LookupSectionData]> { get }
    var shareToURL: Driver<URL?> { get }
}


final class LookupViewModel: NSObject, LookupViewModelType, LookupViewModelInputType , LookupViewModelOutputType{
    
    var input: LookupViewModelInputType { return self }
    var output: LookupViewModelOutputType { return self }
    
    //input
    var shareDidTap: PublishSubject<Void> = .init()
    let refresh: PublishSubject<LookupServiceType> = .init()
    
    
    //output
    let loadCompleted: Observable<Void>
    let header: Driver<LookupHeaderViewModelType?>
    
    let sections: Driver<[LookupSectionData]>
    let shareToURL: Driver<URL?>
    
    init?(item: ItemModel) {
        if item.id.isEmpty { return nil }
        
        let lookupService = LookupService(id: item.id)
        let reviewService = ReviewService(id: item.id)
        
        defer {
            _ = self.refresh
                .takeUntil(rx.deallocated)
                .subscribe(onNext: {  type in
                    switch type {
                    case .lookup:
                        lookupService.rx.refresh.onNext(Void())
                    case .review:
                        reviewService.rx.refresh.onNext(Void())
                    }
                })
        }
        
        let lookupDataSources = lookupService
            .rx.dataSource
            .map { (model: LookupModel) -> [LookupSectionData] in
                var dataSources: [LookupTableCellType] = []
                
                let screenshot = LookupScreenshotCellViewModel(type: .screenshot(title: "iPhone"),
                                                               urls: model.screenshotURLs)
                
                let description = LookupContentCellModel(type: .content(title: "설명"),
                                                         content: model.description)
                
                let releaseNotes = LookupContentCellModel(type: .content(title: "새로운 기능"),
                                                          content: model.releaseNotes)
                
                dataSources.append(screenshot)
                dataSources.append(description)
                if !model.releaseNotes.isEmpty {
                    dataSources.append(releaseNotes)
                }
                return [LookupSectionData(items: dataSources)]
        }
        
        let reviewDataSources = reviewService
            .rx.dataSources
            .map { (models: [ReviewModel]) -> [LookupSectionData] in
                let items = models.map { LookupReviewCellModel(type: .review, model: $0) }
                return [LookupSectionData(items: items)]
        }
        
        
        let dataSources = Observable
            .from([lookupDataSources, reviewDataSources])
            .merge()
        
        
        self.loadCompleted = dataSources
            .map { _ in }
        
        
        let headerBase = Observable<LookupHeaderViewModelType?>
            .just(LookupHeaderViewModel(item))
        
        let headerLoaded = lookupService.rx.dataSource
            .map { (model: LookupModel) -> LookupHeaderViewModelType? in
                return LookupHeaderViewModel(model)
        }
        
        self.header = Observable.from([headerBase, headerLoaded])
            .merge()
            .asDriver(onErrorJustReturn: nil)
        
        self.sections = dataSources.asDriver(onErrorJustReturn: [])
        
        self.shareToURL =
            self.shareDidTap
                .map { _ in
                    URL(string: "https://itunes.apple.com/app/id\(item.id)")
                }.asDriver(onErrorJustReturn: nil)
        
        
        super.init()
    }
}



extension LookupSectionData: SectionModelType {
    typealias Item = LookupTableCellType
    
    init(original: LookupSectionData, items: [Item]) {
        self = original
        self.items = items
    }
}
