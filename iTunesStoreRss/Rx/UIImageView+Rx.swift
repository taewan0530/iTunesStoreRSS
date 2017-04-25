//
//  UIImageView+Rx.swift
//  iTunesStoreRss
//
//  Created by kimtaewan on 2017. 4. 25..
//  Copyright © 2017년 taewan. All rights reserved.
//

import UIKit
import AlamofireImage
import Alamofire
import RxSwift
import RxCocoa

extension Reactive where Base: UIImageView {
    
    public var afImageURL: UIBindingObserver<Base, URL?> {
        return UIBindingObserver(UIElement: base) { imageView, url in
            guard let url = url else { return }    
            imageView.af_setImage(withURL: url,
                                  imageTransition: .crossDissolve(0.3))
        }
    }
    
}
