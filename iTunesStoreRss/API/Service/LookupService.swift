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
    
    let id: String
    
    public init(id: String) {
        self.id = id
        super.init()
    }
}

extension Reactive where Base: LookupService {
    func load() -> Observable<LookupModel> {
        return Router.lookup(id: self.base.id)
            .asRequset()
            .rx.responseSwiftyJSON()
            .map { $0["results"].arrayValue.first ?? JSON(parseJSON: "{}") }
            .map { LookupModel($0["feed"]["entry"]) }
    }
}
