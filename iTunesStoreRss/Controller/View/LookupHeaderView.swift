//
//  AppLookupHeaderView.swift
//  iTunesStoreRss
//
//  Created by taewan on 2017. 4. 23..
//  Copyright © 2017년 taewan. All rights reserved.
//

import UIKit


final class LookupHeaderView: UIView {
   
    @IBOutlet weak var imageView: UIImageView!

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var teamLabel: UILabel!
    
    @IBOutlet weak var starRateView: StarRateView!
    @IBOutlet weak var ratingCountLabel: UILabel!
    
    @IBOutlet weak var actionButton: UIButton!
    @IBOutlet weak var advisoryRatingButton: UIButton!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    private func setup() {
        self.preservesSuperviewLayoutMargins = true
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        imageView.layer.borderWidth = 1
        imageView.layer.borderColor = UIColor.SRGray.cgColor
        imageView.layer.cornerRadius = 18
        
        
        advisoryRatingButton.layer.borderWidth = 1
        advisoryRatingButton.layer.borderColor = advisoryRatingButton.titleColor(for: .normal)?.cgColor
        
        actionButton.layer.borderWidth = 1
        actionButton.layer.borderColor = self.actionButton.tintColor.cgColor
        actionButton.layer.cornerRadius = 4
    }
    
}


// MARK: - ViewModel
extension LookupHeaderView: Configurable, ConfigureCell {
    func configure(by viewModel: LookupHeaderViewModelType) {
        
        if let url = viewModel.artworkURL {
            imageView.af_setImage(withURL: url,
                                  imageTransition: .crossDissolve(0.3))
        }
        
        titleLabel.text = viewModel.title
        teamLabel.text = viewModel.artistName
        
        advisoryRatingButton.setTitle(viewModel.advisoryRating, for: .normal)

        starRateView.currentRate = viewModel.averageUserRating
        ratingCountLabel.text = "(\(viewModel.userRatingCount))"
        
        advisoryRatingButton.isHidden = viewModel.advisoryRating.isEmpty
        ratingCountLabel.isHidden = viewModel.userRatingCount == 0
        starRateView.isHidden = viewModel.averageUserRating == 0
    }

}
