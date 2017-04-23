//
//  AnimateScheduler.swift
//  iTunesStoreRss
//
//  Created by taewan on 2017. 4. 23..
//  Copyright © 2017년 taewan. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa


final class AnimateScheduler: NSObject, ImmediateSchedulerType {
    
    let duration: TimeInterval
    let delay: TimeInterval
    let options: UIViewAnimationOptions
    
    public init(withDuration duration: TimeInterval = 0.3, delay: TimeInterval = 0, options: UIViewAnimationOptions = []) {
        self.duration = duration
        self.delay = delay
        self.options = options
    }
    
    public func schedule<StateType>(_ state: StateType, action: @escaping (StateType) -> Disposable) -> Disposable {

        return MainScheduler.instance.schedule(state) { [weak self] (stateType) -> Disposable in
            guard let `self` = self else { return action(state) }
            
            var result: Disposable?
            UIView.animate(withDuration: self.duration, delay: self.delay, options: self.options, animations: {
                result = action(state)
            }, completion: nil)
            return result ?? action(state)
        }
    }
}
