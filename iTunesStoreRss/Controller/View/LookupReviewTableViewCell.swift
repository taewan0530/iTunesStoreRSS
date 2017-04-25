//
//  LookupReviewTableViewCell.swift
//  iTunesStoreRss
//
//  Created by taewan on 2017. 4. 24..
//  Copyright © 2017년 taewan. All rights reserved.
//

import UIKit

import RxSwift
import RxCocoa

final class LookupReviewTableViewCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var starRatingView: StarRatingView!
    
    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var contentLabel: UILabel!
    
    fileprivate var disposeBag = DisposeBag()
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
}


// MARK: - ViewModel Configurable
extension LookupReviewTableViewCell: Configurable, ConfigureCell {
    func configure(by viewModel: LookupReviewCellModelType) {
        disposeBag = DisposeBag()
        
        let output =  viewModel.output
        
        output.title
            .drive(self.titleLabel.rx.text)
            .disposed(by: disposeBag)
        
        output.rating
            .drive(self.starRatingView.rx.currentRating)
            .disposed(by: disposeBag)
        
        output.name
            .drive(self.authorLabel.rx.text)
            .disposed(by: disposeBag)
        
        output.content
            .drive(self.contentLabel.rx.text)
            .disposed(by: disposeBag)   
    }

}
