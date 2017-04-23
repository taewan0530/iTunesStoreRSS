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

protocol AppLookupViewModelType {
    var input: AppLookupViewModelInputType { get }
    var output: AppLookupViewModelOutputType { get }
}

protocol AppLookupViewModelInputType {
    var refresh: PublishSubject<Void> { get }
}

protocol AppLookupViewModelOutputType {
    
}
