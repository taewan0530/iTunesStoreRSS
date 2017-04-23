//
//  LookupContentTableViewCell.swift
//  iTunesStoreRss
//
//  Created by taewan on 2017. 4. 23..
//  Copyright © 2017년 taewan. All rights reserved.
//

import UIKit

final class LookupContentTableViewCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var contentLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}




// MARK: - ViewModel
extension LookupContentTableViewCell: Configurable, ConfigureCell {
    func configure(by viewModel: LookupContentCellModelType) {
        self.titleLabel.text = viewModel.title
        self.contentLabel.text = viewModel.content
    }
    
}
