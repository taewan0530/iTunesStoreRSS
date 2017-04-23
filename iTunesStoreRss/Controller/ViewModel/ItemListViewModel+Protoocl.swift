//
//  AppRssListViewModel+Protoocl.swift
//  iTunesStoreRss
//
//  Created by taewan on 2017. 4. 20..
//  Copyright © 2017년 taewan. All rights reserved.
//

import Foundation

import RxSwift
import RxCocoa

protocol ItemListViewModelType: ViewModelType {
    var input: ItemListViewModelInputType { get }
    var output: ItemListViewModelOutputType { get }
}

protocol ItemListViewModelInputType {
    var refresh: PublishSubject<Void> { get }
    var itemDidSelect: PublishSubject<IndexPath> { get }
    
}

protocol ItemListViewModelOutputType {
    var sections: Driver<[ItemSectionData]> { get }
    var refreshCompleted: Driver<Bool> { get }
    var performLookup: Driver<LookupViewModelType?> { get }
    
}
