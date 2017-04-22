//
//  RxViewController.swift
//  iTunesStoreRss
//
//  Created by taewan on 2017. 4. 21..
//  Copyright © 2017년 taewan. All rights reserved.
//

import UIKit
import RxSwift


open class RxViewController: UIViewController {
    
    public let disposeBag = DisposeBag()
    
    deinit {
        let name = type(of: self).description().components(separatedBy: ".").last ?? "name"
        print("deinit: \(name)")
    }
}
