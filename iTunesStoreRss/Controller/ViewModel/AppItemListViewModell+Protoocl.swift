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

protocol AppItemListViewModelType {
    var input: AppItemListViewModelInputType { get }
    var output: AppItemListViewModelOutputType { get }
}

protocol AppItemListViewModelInputType {
    var refresh: PublishSubject<Void> { get }
    var itemDidSelect: PublishSubject<IndexPath> { get }
    
}

protocol AppItemListViewModelOutputType {
    var sections: Driver<[ItemSectionData]> { get }
    var refreshCompleted: Driver<Bool> { get }
    var selectedAppId: Driver<String> { get }
    
}
