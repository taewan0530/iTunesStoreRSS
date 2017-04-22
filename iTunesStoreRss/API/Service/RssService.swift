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
    fileprivate var rxRefresh: PublishSubject<Void> = .init()
    
    let genre: Router.Genre
    let limit: Int
    
    public init(genre: Router.Genre, limit: Int = 50) {
        self.genre = genre
        self.limit = limit
        super.init()
    }
}

extension Reactive where Base: RssService {
    var refresh: PublishSubject<Void> {
        return self.base.rxRefresh
    }
    
    var dataSources: Observable<[RssModel]> {
        let responseJSON = Router.topFreeApplications(limit: self.base.limit, genre: self.base.genre)
            .asRequset()
            .rx.responseSwiftyJSON()
        
        return self.base.rxRefresh
            .flatMap { responseJSON }
            .map { RssModel.collection($0["feed"]["entry"]) }
            .shareReplay(1)
        
    }
    //
    //    func load() -> Observable<[RssModel]> {
    //        print("RssService load")
    //
    //        let rxLoad = Router.topFreeApplications(limit: self.base.limit, genre: self.base.genre)
    //            .asRequset()
    //            .rx.responseSwiftyJSON()
    //
    //        return self.base.rxRefresh
    //            .flatMap { rxLoad }
    //            .map {
    //                RssModel.collection($0["feed"]["entry"])
    //            }//.shareReplay(1)
    //    }
}
