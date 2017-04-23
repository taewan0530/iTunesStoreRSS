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
extension LookupSectionData: SectionModelType {
    typealias Item = LookupTableCellType
    
    init(original: LookupSectionData, items: [Item]) {
        self = original
        self.items = items
    }
}

final class LookupViewModel: NSObject, LookupViewModelType, LookupViewModelInputType , LookupViewModelOutputType{
    
    var input: LookupViewModelInputType { return self }
    var output: LookupViewModelOutputType { return self }
    
    let service: LookupService
    
    //input
    let refresh: PublishSubject<Void> = .init()
    
    //output
    let loadCompleted: Observable<Void>
    let header: Driver<LookupHeaderViewModelType?>
    let sections: Driver<[LookupSectionData]>
    
    
    
    init?(item: ItemModel) {
        if item.id.isEmpty { return nil }
        self.service = .init(id: item.id)
        
        defer {
            _ = self.refresh
                .takeUntil(rx.deallocated)
                .bind(to: self.service.rx.refresh)
        }
        
        
        self.loadCompleted = self.service
            .rx.dataSource
            .map { _ in }
        
        let headerViewModel = Observable<LookupHeaderViewModelType?>
            .just(LookupHeaderViewModel(item))
        
        let loadedHeaderViewModel = self.service.rx.dataSource
            .map { (model: LookupModel) -> LookupHeaderViewModelType? in
                return LookupHeaderViewModel(model)
            }

        self.header = Observable.from([headerViewModel, loadedHeaderViewModel])
            .merge()
            .asDriver(onErrorJustReturn: nil)
        
        self.sections = self.service
            .rx.dataSource
            .map { (model: LookupModel) -> [LookupSectionData] in
                var dataSources: [LookupTableCellType] = []
                
                let screenshot = LookupScreenshotCellModel(type: .screenshot(title: "iPhone"),
                                                           urls: model.screenshotURLs)
                
                let description = LookupContentCellModel(type: .content(title: "설명"),
                                                         content: model.description)
                
                
                let releaseNotes = LookupContentCellModel(type: .content(title: "새로운 기능"),
                                                          content: model.releaseNotes)
                
                dataSources.append(screenshot)
                dataSources.append(description)
                
                if !releaseNotes.content.isEmpty {
                    dataSources.append(releaseNotes)
                }
                
                return [LookupSectionData(items: dataSources)]
            }.asDriver(onErrorJustReturn: [])
        
        
        
        
        //        self.service.rx.dataSource
        //        let rxDataSource = self.service.rx.dataSource
        
        //        rxDataSource.map {
        //            $0.
        //        }
        
        
        super.init()
    }
    
}
