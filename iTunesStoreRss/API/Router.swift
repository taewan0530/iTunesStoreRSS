//
//  Router.swift
//  iTunesStoreRss
//
//  Created by taewan on 2017. 4. 20..
//  Copyright © 2017년 taewan. All rights reserved.
//

import Foundation

import Alamofire

enum Router {
    
    case applications(feedType: Router.FeedType, limit: Int, genre: Router.Genre)
    case lookup(id: String)
    case customerReviews(id: String)
    
    static let baseURLString: String = "https://itunes.apple.com"
    static var location: String = "kr"//"us"
    
    fileprivate var result: (path: String, parameters: Parameters?)  {
        switch self {
        case .applications(let feedType, let limit, let genre):
            return ("/\(Router.location)/rss/\(feedType.rawValue)/limit=\(limit)/genre=\(genre.rawValue)/json", nil)

        case .lookup(let id):
            return ("/lookup", ["id": id, "country": Router.location])
            
        case .customerReviews(let id):
            return ("/\(Router.location)/rss/customerreviews/id=\(id)/json", nil)
        }
    }
    
    public func asDataRequest() -> DataRequest {
        return Alamofire.request(self)
    }
}


extension Router: URLRequestConvertible {
    // MARK: URLRequestConvertible
    func asURLRequest() throws -> URLRequest {
        let url = try Router.baseURLString.asURL()
        let urlRequest = URLRequest(url: url.appendingPathComponent(result.path))
        
        return try URLEncoding.default.encode(urlRequest, with: result.parameters)
    }
}


// MARK: - Other enum
extension Router {
    enum FeedType: String {
        case newApplications = "newapplications"
        case newFreeApplications = "newfreeapplications"
        case newPaidApplications = "newpaidapplications"
        case topFreeApplications = "topfreeapplications"
        case topGrossingApplications = "topgrossingapplications"
        case topPaidApplications = "toppaidapplications"
    }
    
    enum Genre: Int {
        case book = 6018
        case catalogs = 6022
        case business = 6000
        case finance = 6015
        case education = 6017
        case entertainment = 6016
        case food = 6023
        case games = 6014
        case health = 6013
        case lifestyle = 6012
        case medical = 6020
        case music = 6011
        case navigation = 6010
        case news = 6009
        case newsstand = 6021
        case photo = 6008
        case productivty = 6007
        case reference = 6006
        case socialNetworking = 6005
        case sports = 6004
        case travel = 6003
        case utilities = 6002
        case weather = 6001
    }
}
