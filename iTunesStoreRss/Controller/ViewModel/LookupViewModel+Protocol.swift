//
//  AppLookupViewModel+Protocol.swift
//  iTunesStoreRss
//
//  Created by taewan on 2017. 4. 20..
//  Copyright © 2017년 taewan. All rights reserved.
//

import Foundation

import RxSwift
import RxCocoa

protocol LookupViewModelType: ViewModelType {
    var input: LookupViewModelInputType { get }
    var output: LookupViewModelOutputType { get }
}

protocol LookupViewModelInputType {
    var refresh: PublishSubject<Void> { get }
}

protocol LookupViewModelOutputType {
    var loadCompleted: Observable<Void> { get }
    var header: Driver<LookupHeaderViewModelType?> { get }
    var sections: Driver<[LookupSectionData]> { get }
}
