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


final class ItemService: NSObject {
    fileprivate var rxRefresh: PublishSubject<Void> = .init()
    
    var feedType: Router.FeedType
    var genre: Router.Genre
    var limit: Int
    
    public init(feedType: Router.FeedType, genre: Router.Genre, limit: Int = 50) {
        self.feedType = feedType
        self.genre = genre
        self.limit = limit
        super.init()
    }
}

extension Reactive where Base: ItemService {
    var refresh: PublishSubject<Void> {
        return self.base.rxRefresh
    }
    
    var dataSources: Observable<[ItemModel]> {
        let responseJSON = Router
            .applications(feedType: self.base.feedType,
                          limit: self.base.limit,
                          genre: self.base.genre)
            .asDataRequest()
            .rx.responseSwiftyJSON()
        
        return self.base.rxRefresh
            .flatMap { responseJSON }
            .map { ItemModel.collection($0["feed"]["entry"]) }
            .shareReplay(1)
    }
    
}
