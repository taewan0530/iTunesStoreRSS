//
//  StarRatingView.swift
//  iTunesStoreRss
//
//  Created by taewan on 2017. 4. 23..
//  Copyright © 2017년 taewan. All rights reserved.
//

import UIKit


@IBDesignable
open class StarRatingView: UIView {
    
    @IBInspectable
    var currentRating: Float = 0 {
        didSet { self.setNeedsDisplay() }
    }
    
    @IBInspectable
    var maxRate: Int = 5
    
    @IBInspectable
    var spacing: CGFloat = 4
    
    @IBInspectable
    var emptyImage: UIImage?
    
    @IBInspectable
    var halfImage: UIImage?
    
    @IBInspectable
    var fillImage: UIImage?
    
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    private func setup() {
        
    }
    
    open override func draw(_ rect: CGRect) {
        super.draw(rect)
        guard let emptyImage = self.emptyImage,
            let halfImage = self.halfImage,
            let fillImage = self.fillImage else { return }

        let size = emptyImage.size
        let currentRating = CGFloat(self.currentRating)
        
        for i in 0..<maxRate {
            let index = CGFloat(i)
            let x = (size.width + spacing) * index
            if index < currentRating {
                if 0 < floor(currentRating - index) {
                     fillImage.draw(at: .init(x: x, y: 0))
                } else {
                     halfImage.draw(at: .init(x: x, y: 0))
                }
            } else {
                emptyImage.draw(at: .init(x: x, y: 0))
            }
        }
    }
    

    open override var intrinsicContentSize: CGSize {
        let size = self.emptyImage?.size ?? CGSize(width: 12, height: 12)
        let count = CGFloat(maxRate)
        let width = ((size.width + spacing) * count)
        return CGSize(width: width, height: size.height)
    }
}
