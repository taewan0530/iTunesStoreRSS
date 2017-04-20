//
//  AppRssTableViewCell.swift
//  iTunesStoreRss
//
//  Created by taewan on 2017. 4. 20..
//  Copyright © 2017년 taewan. All rights reserved.
//

import UIKit

final class AppRssTableViewCell: UITableViewCell {

    @IBOutlet weak var rankLabel: UILabel!
    @IBOutlet weak var thumbnailImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.updateStyle()
    }
    
    
    private func updateStyle() {
        self.thumbnailImageView.layer.borderWidth = 1
        self.thumbnailImageView.layer.borderColor = UIColor.SRGray.cgColor
        self.thumbnailImageView.layer.cornerRadius = 16
    }
}
