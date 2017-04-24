//
//  ReviewService.swift
//  iTunesStoreRSS
//
//  Created by taewan on 2017. 4. 24..
//  Copyright © 2017년 taewan. All rights reserved.
//

import Foundation

import RxSwift
import SwiftyJSON


final class ReviewService: NSObject {
    fileprivate var rxRefresh: PublishSubject<Void> = .init()
    
    let id: String
    
    public init(id: String) {
        self.id = id
        super.init()
        
    }
}

extension Reactive where Base: ReviewService {
    var refresh: PublishSubject<Void> {
        return self.base.rxRefresh
    }
    
    var dataSources: Observable<[ReviewModel]> {
        let responseJSON = Router.customerReviews(id: self.base.id)
            .asDataRequest()
            .rx.responseSwiftyJSON()
        return self.base.rxRefresh
            .flatMap { responseJSON }
            .map { ReviewModel.collection($0["feed"]["entry"]) }
            .map { $0.filter { !$0.isEmpty } }
            .shareReplay(1)
    }
}
