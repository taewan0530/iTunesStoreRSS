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
    typealias Item = ItemTableCellModelType
    
    init(original: ItemSectionData, items: [Item]) {
        self = original
        self.items = items
    }
}


final class ItemListViewModel: NSObject, ItemListViewModelType, ItemListViewModelInputType, ItemListViewModelOutputType {
    var input: ItemListViewModelInputType { return self }
    var output: ItemListViewModelOutputType { return self }
    
    let service: ItemService
    
    //input
    let refresh: PublishSubject<Void> = .init()
    let itemDidSelect: PublishSubject<IndexPath> = .init()
    
    //output
    let sections: Driver<[ItemSectionData]>
    var refreshCompleted: Driver<Bool>
    let performLookup: Driver<LookupViewModelType?>
    
    init(genre: Router.Genre, limit: Int = 50) {
        self.service = .init(feedType: .topFreeApplications, genre: genre, limit: 50)
        
        defer {
            //input
            _ = self.refresh
                .takeUntil(rx.deallocated)
                .bind(to: self.service.rx.refresh)
        }
                
        let rssDataSources = self.service.rx.dataSources
        
        self.performLookup = self.itemDidSelect
            .withLatestFrom(rssDataSources) { (indexPath, models)  in
                models[indexPath.row]
            }.map {
                LookupViewModel(item: $0)
            }.asDriver(onErrorJustReturn: nil)
        
        self.sections = rssDataSources
            .map {
                $0.enumerated().map { (i, item) in
                    ItemTableCellModel(rank: i + 1, model: item)
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
