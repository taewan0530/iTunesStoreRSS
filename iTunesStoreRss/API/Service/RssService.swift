//
//  RssService.swift
//  iTunesStoreRss
//
//  Created by taewan on 2017. 4. 20..
//  Copyright © 2017년 taewan. All rights reserved.
//

import Foundation

import RxSwift
import SwiftyJSON


final class RssService: NSObject {
    
    let genre: Router.Genre
    let limit: Int
    
    public init(genre: Router.Genre, limit: Int = 50) {
        self.genre = genre
        self.limit = limit
        super.init()
    }
}

extension Reactive where Base: RssService {
    func load() -> Observable<RssModel> {
        
        return Router.topFreeApplications(limit: self.base.limit, genre: self.base.genre)
            .asRequset()
            .rx.responseSwiftyJSON()
            .map { RssModel($0["feed"]["entry"]) }
    }
}
