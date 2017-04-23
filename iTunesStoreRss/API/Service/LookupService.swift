//
//  LookupService.swift
//  iTunesStoreRss
//
//  Created by taewan on 2017. 4. 20..
//  Copyright © 2017년 taewan. All rights reserved.
//

import Foundation

import RxSwift
import SwiftyJSON


final class LookupService: NSObject {
    fileprivate var rxRefresh: PublishSubject<Void> = .init()
    
    let id: String
    
    public init(id: String) {
        self.id = id
        super.init()
    }
}

extension Reactive where Base: LookupService {
    var refresh: PublishSubject<Void> {
        return self.base.rxRefresh
    }
    
    var dataSource: Observable<LookupModel> {
        let responseJSON = Router.lookup(id: self.base.id)
            .asDataRequest()
            .rx.responseSwiftyJSON()

        return self.base.rxRefresh
            .flatMap { responseJSON }
            .map { $0["results"].arrayValue.first ?? JSON(parseJSON: "{}") }
            .map { LookupModel($0) }
            .shareReplay(1)
    }
}
