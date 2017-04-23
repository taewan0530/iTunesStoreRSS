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

final class AppLookupViewModel: NSObject, AppLookupViewModelType, AppLookupViewModelInputType , AppLookupViewModelOutputType{
    var input: AppLookupViewModelInputType { return self }
    var output: AppLookupViewModelOutputType { return self }
    
    let service: LookupService
    
    //input
    let refresh: PublishSubject<Void> = .init()
    
    //output
    
    init?(appId: String) {
        if appId.isEmpty { return nil }
        self.service = .init(id: appId)
        
        defer {
            _ = self.refresh
                .takeUntil(rx.deallocated)
                .bind(to: self.service.rx.refresh)
        }
        
//        let rxDataSource = self.service.rx.dataSource
        
//        rxDataSource.map {
//            $0.
//        }
        
        
        super.init()
    }
    
}
