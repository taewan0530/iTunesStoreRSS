//
//  Router.swift
//  iTunesStoreRss
//
//  Created by taewan on 2017. 4. 20..
//  Copyright © 2017년 taewan. All rights reserved.
//

import Foundation

import Alamofire



enum Router: URLRequestConvertible {
    
    case topFreeApplications(limit: Int, genre: Router.Genre)
    case lookup(id: String)
    
    static let baseURLString = "https://itunes.apple.com"
    
    
    var result: (path: String, parameters: Parameters?)  {
        switch self {
        case .topFreeApplications(let limit, let genre):
            return ("/kr/rss/topfreeapplications/limit=\(limit)/genre=\(genre.rawValue)/json", nil)
        case .lookup(let id):
            return ("/lookup", ["id": id, "country": "kr"])
            
        }
    }
    
    // MARK: URLRequestConvertible
    func asURLRequest() throws -> URLRequest {
        let url = try Router.baseURLString.asURL()
        let urlRequest = URLRequest(url: url.appendingPathComponent(result.path))
        
        return try URLEncoding.default.encode(urlRequest, with: result.parameters)
    }
    
    public func asRequset() -> DataRequest {
        return Alamofire.request(self)
    }
}



// MARK: - Other enum
extension Router {
    enum Genre: Int {
        case finance = 6015
    }
}
