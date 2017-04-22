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

protocol AppRssListViewModelType {
    var input: AppRssListViewModelInputType { get }
    var output: AppRssListViewModelOutputType { get }
}

protocol AppRssListViewModelInputType {
    var refresh: PublishSubject<Void> { get }
    var itemDidSelect: PublishSubject<IndexPath> { get }
    
}

protocol AppRssListViewModelOutputType {
    var sections: Driver<[RssSectionData]> { get }
    var refreshCompleted: Driver<Bool> { get }
    var selectedAppId: Driver<String> { get }
    
}
