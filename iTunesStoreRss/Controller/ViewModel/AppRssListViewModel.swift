//
//  AppRssListViewModel.swift
//  iTunesStoreRss
//
//  Created by taewan on 2017. 4. 20..
//  Copyright © 2017년 taewan. All rights reserved.
//

import Foundation

import RxSwift
import RxCocoa
import RxDataSources

struct RssSectionData {
    var items: [Item]
}
extension RssSectionData: SectionModelType {
    typealias Item = AppRssTableViewModel
    
    init(original: RssSectionData, items: [Item]) {
        self = original
        self.items = items
    }
}


final class AppRssListViewModel: NSObject, AppRssListViewModelType, AppRssListViewModelInputType, AppRssListViewModelOutputType {
    var input: AppRssListViewModelInputType { return self }
    var output: AppRssListViewModelOutputType { return self }
    
    let service: RssService
    
    //input
    let refresh: PublishSubject<Void> = .init()
    let itemDidSelect: PublishSubject<IndexPath> = .init()
    
    //output
    let sections: Driver<[RssSectionData]>
    var refreshCompleted: Driver<Bool>
    let selectedAppId: Driver<String>
    
    init(genre: Router.Genre, limit: Int = 50) {
        self.service = .init(genre: genre, limit: limit)
        
        defer {
            //input
            _ = self.refresh
                .takeUntil(rx.deallocated)
                .bindTo(self.service.rx.refresh)
        }
        
        
        //output
        let rssDataSource = self.service.rx.dataSources
                
        self.selectedAppId = itemDidSelect
            .withLatestFrom(rssDataSource) { (indexPath, models)  in
                models[indexPath.row]
            }.map { $0.id }
            .asDriver(onErrorJustReturn: "")
        
        self.sections = rssDataSource
            .map {
                $0.enumerated().map { (i, item) in
                    AppRssTableViewModel(rank: i + 1, model: item)
                }
            }.map {
                [RssSectionData(items: $0)]
            }.asDriver(onErrorJustReturn: [])
        

        self.refreshCompleted = rssDataSource
            .do(onNext: { _ in
                print("refreshCompleted")
            }).map { _ in false }
            .asDriver(onErrorJustReturn: false)
        
        super.init()
    }
}
