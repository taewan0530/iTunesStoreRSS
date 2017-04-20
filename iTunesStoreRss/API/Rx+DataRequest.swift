//
//  Rx+DataRequest.swift
//  iTunesStoreRss
//
//  Created by taewan on 2017. 4. 20..
//  Copyright © 2017년 taewan. All rights reserved.
//

import Foundation

import RxSwift
import Alamofire
import SwiftyJSON

extension DataRequest: ReactiveCompatible {}


extension Reactive where Base: DataRequest {
    
    public func responseSwiftyJSON() -> Observable<JSON> {
        return Observable<JSON>.create { observer -> Disposable in
            let request = self.base.responseSwiftyJSON { response in
                switch response.result {
                case .failure(let error):
                    observer.onError(error)
                case .success(let value):
                    observer.onNext(value)
                    observer.onCompleted()
                }
            }
            return Disposables.create {
                request.cancel()
            }
        }
    }
    
}


