//
//  AppLookupHeaderView.swift
//  iTunesStoreRss
//
//  Created by taewan on 2017. 4. 23..
//  Copyright © 2017년 taewan. All rights reserved.
//

import UIKit

import RxSwift
import RxCocoa

final class LookupHeaderView: UIView {
    
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var teamLabel: UILabel!
    
    @IBOutlet weak var starRatingView: StarRatingView!
    @IBOutlet weak var ratingCountLabel: UILabel!
    
    @IBOutlet weak var actionButton: UIButton!
    @IBOutlet weak var advisoryRatingButton: UIButton!
    
    fileprivate var disposeBag = DisposeBag()
    
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
        layoutStyle()
    }
    
    private func layoutStyle() {
        imageView.layer.borderWidth = 1/UIScreen.main.scale
        imageView.layer.borderColor = UIColor.lightGray.cgColor
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
        disposeBag = DisposeBag()
        
        let input = viewModel.input
        
        actionButton
            .rx.tap
            .bind(to: input.actionDidTap)
            .disposed(by: disposeBag)
        
        let output = viewModel.output
        
        output.artworkURL
            .drive(self.imageView.rx.afImageURL)
            .disposed(by: disposeBag)
        
        output.title
            .drive(self.titleLabel.rx.text)
            .disposed(by: disposeBag)
        
        output.artistName
            .drive(self.teamLabel.rx.text)
            .disposed(by: disposeBag)
        
        output.advisoryRating
            .drive(self.advisoryRatingButton.rx.title(for: .normal))
            .disposed(by: disposeBag)
        
        output.averageUserRating
            .drive(weak: self, type(of: self).updateRating)
            .disposed(by: disposeBag)
        
        output.userRatingCount
            .drive(self.ratingCountLabel.rx.text)
            .disposed(by: disposeBag)
        
        output.isStarRatingHidden
            .drive(self.starRatingView.rx.isHidden)
            .disposed(by: disposeBag)
        
        output.isAdvisoryRatingHidden
            .drive(self.advisoryRatingButton.rx.isHidden)
            .disposed(by: disposeBag)
        
        output.isRatingCountHidden
            .drive(self.ratingCountLabel.rx.isHidden)
            .disposed(by: disposeBag)
        
        
        output.openURL
            .drive(onNext: { url in
                guard let url = url else { return }
                UIApplication.shared.openURL(url)
            }).disposed(by: disposeBag)
    }

    func updateRating(_ rating: Float) {
        self.starRatingView.currentRating = rating
    }
}
