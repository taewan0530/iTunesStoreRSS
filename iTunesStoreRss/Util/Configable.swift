//
//  Configable.swift
//  iTunesStoreRss
//
//  Created by taewan on 2017. 4. 23..
//  Copyright © 2017년 taewan. All rights reserved.
//

import Foundation

import RxSwift
import RxCocoa

public protocol ViewModelType {}

public protocol Configurable: class {
    associatedtype ViewModel = ViewModelType
    func configure(by viewModel: ViewModel)
}

public protocol ConfigureCell: class {
    func configure(by item: ViewModelType?)
}

public extension ConfigureCell where Self: Configurable {
    func configure(by item: ViewModelType?) {
        if item == nil { return }
        guard let viewModel = item as? Self.ViewModel else {
//            dump(item)
            assertionFailure("ViewModelType이 일치 하지 않습니다!!")
            return
        }
        
        configure(by: viewModel)
    }
}


//extension Reactive where Base: ReactiveCompatible, Base: Configurable  {
//
//    public var configure: UIBindingObserver<Base, ViewModelType?> {
//        return UIBindingObserver(UIElement: self.base) { configurable, item in
//            guard let viewModel = item as? Base.ViewModel else {
//                assertionFailure("ViewModelType이 일치 하지 않습니다!!")
//                return
//            }
//            configurable.configure(by: viewModel)
//        }
//    }
//}
