//
//  StarraingView+Rx.swift
//  iTunesStoreRss
//
//  Created by kimtaewan on 2017. 4. 25..
//  Copyright © 2017년 taewan. All rights reserved.
//

import UIKit

import RxSwift
import RxCocoa

extension Reactive where Base: StarRatingView {
    
    public var currentRating: UIBindingObserver<Base, Float> {
        return UIBindingObserver(UIElement: base) { view, rating in
            view.currentRating = rating
        }
    }
    
}
