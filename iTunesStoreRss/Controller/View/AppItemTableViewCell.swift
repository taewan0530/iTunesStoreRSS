//
//  AppRssTableViewCell.swift
//  iTunesStoreRss
//
//  Created by taewan on 2017. 4. 20..
//  Copyright © 2017년 taewan. All rights reserved.
//

import UIKit

import AlamofireImage


final class AppItemTableViewCell: UITableViewCell {
    
    @IBOutlet weak var rankLabel: UILabel!
    @IBOutlet weak var thumbnailImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.updateStyle()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        thumbnailImageView.af_cancelImageRequest()
        thumbnailImageView.image = nil
    }
    
    func configure(_ viewModel: AppItemTableViewModelType) {
        rankLabel.text = "\(viewModel.rank)"
        titleLabel.text = viewModel.title
        if let url = viewModel.imageURL {
            thumbnailImageView.af_setImage(withURL: url,
                                           imageTransition: .crossDissolve(0.3))
        }
    }
    
    private func updateStyle() {
        thumbnailImageView.layer.borderWidth = 1
        thumbnailImageView.layer.borderColor = UIColor.SRGray.cgColor
        thumbnailImageView.layer.cornerRadius = 16
    }
}
