//
//  AppRssTableViewCell.swift
//  iTunesStoreRss
//
//  Created by taewan on 2017. 4. 20..
//  Copyright © 2017년 taewan. All rights reserved.
//

import UIKit

import AlamofireImage
import RxSwift
import RxCocoa
import RxBindNext

final class ItemTableViewCell: UITableViewCell {
    
    @IBOutlet weak var rankLabel: UILabel!
    @IBOutlet weak var thumbnailImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    
    fileprivate var disposeBag = DisposeBag()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.layoutStyle()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        thumbnailImageView.af_cancelImageRequest()
        thumbnailImageView.image = nil
    }
    
    private func layoutStyle() {
        thumbnailImageView.layer.borderWidth = 1/UIScreen.main.scale
        thumbnailImageView.layer.borderColor = UIColor.lightGray.cgColor
        thumbnailImageView.layer.cornerRadius = 16
    }
}



// MARK: - ViewModel Configurable
extension ItemTableViewCell: Configurable, ConfigureCell {
    
    
    func configure(by viewModel: ItemTableCellModelType) {
        disposeBag = DisposeBag()
       
        let output = viewModel.output
        output.rank
            .drive(self.rankLabel.rx.text)
            .disposed(by: disposeBag)
        
        output.title
            .drive(self.titleLabel.rx.text)
            .disposed(by: disposeBag)
        
        output.imageURL
            .drive(self.thumbnailImageView.rx.afImageURL)
            .disposed(by: disposeBag)   
    }
}
