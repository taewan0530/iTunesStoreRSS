//
//  Serializable.swift
//  iTunesStoreRss
//
//  Created by taewan on 2017. 4. 20..
//  Copyright © 2017년 taewan. All rights reserved.
//

import Foundation

import Alamofire
import SwiftyJSON

public protocol ObjectSerializable {
    init(_ json: JSON)
}

public protocol CollectionSerializable {
    static func collection<T: ObjectSerializable>(_ json: JSON) -> [T]
}

public extension CollectionSerializable {
    static func collection<T: ObjectSerializable>(_ json: JSON) -> [T] {
        return json.arrayValue.map { T($0) }
    }
}

public typealias JSONCollection = CollectionSerializable & ObjectSerializable
