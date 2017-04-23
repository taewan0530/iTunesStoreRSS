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

struct ItemSectionData {
    var items: [Item]
}
extension ItemSectionData: SectionModelType {
    typealias Item = AppItemTableViewModel
    
    init(original: ItemSectionData, items: [Item]) {
        self = original
        self.items = items
    }
}


final class AppItemListViewModel: NSObject, AppItemListViewModelType, AppItemListViewModelInputType, AppItemListViewModelOutputType {
    var input: AppItemListViewModelInputType { return self }
    var output: AppItemListViewModelOutputType { return self }
    
    let service: ItemService
    
    //input
    let refresh: PublishSubject<Void> = .init()
    let itemDidSelect: PublishSubject<IndexPath> = .init()
    
    //output
    let sections: Driver<[ItemSectionData]>
    var refreshCompleted: Driver<Bool>
    let selectedAppId: Driver<String>
    
    init(genre: Router.Genre, limit: Int = 50) {
        self.service = .init(feedType: .topFreeApplications, genre: genre, limit: 50)
        
        defer {
            //input
            _ = self.refresh
                .takeUntil(rx.deallocated)
                .bind(to: self.service.rx.refresh)
        }
        
        
        let rssDataSources = self.service.rx.dataSources
        
        self.selectedAppId = self.itemDidSelect
            .withLatestFrom(rssDataSources) { (indexPath, models)  in
                models[indexPath.row]
            }.map { $0.id }
            .asDriver(onErrorJustReturn: "")
        
        self.sections = rssDataSources
            .map {
                $0.enumerated().map { (i, item) in
                    AppItemTableViewModel(rank: i + 1, model: item)
                }
            }.map {
                [ItemSectionData(items: $0)]
            }.asDriver(onErrorJustReturn: [])
        

        self.refreshCompleted = rssDataSources
            .map { _ in false }
            .asDriver(onErrorJustReturn: false)
        
        super.init()
    }
}
