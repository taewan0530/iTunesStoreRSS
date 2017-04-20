//
//  Serializable+DataRequest.swift
//  iTunesStoreRss
//
//  Created by taewan on 2017. 4. 20..
//  Copyright © 2017년 taewan. All rights reserved.
//

import Foundation

import Alamofire
import SwiftyJSON

extension DataRequest {
    
    /// 에러 들어오는것 보자!
    ///
    /// - Parameter error: AFError
    private static func responseError(_ error: AFError?) {
        dump(error)
    }
    
    public func responseSwiftyJSON(_ completionHandler: @escaping (DataResponse<JSON>) -> Void) -> Self {
        let responseSerializer = DataResponseSerializer<JSON> { request, response, data, error in
            
            guard error == nil else {
                DataRequest.responseError(error as? AFError)
                return .failure(error!)
            }
            
            let jsonSerializer = DataRequest.jsonResponseSerializer(options: .allowFragments)
            let result = jsonSerializer.serializeResponse(request, response, data, error)
            
            switch result {
            case .success(let value):
                return .success(JSON(value))
            case .failure(let error):
                DataRequest.responseError(error as? AFError)
                return .failure(error)
            }
        }
        
        return response(responseSerializer: responseSerializer, completionHandler: completionHandler)
    }
    
    
}
