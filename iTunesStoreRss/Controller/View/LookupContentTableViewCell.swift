//
//  LookupContentTableViewCell.swift
//  iTunesStoreRss
//
//  Created by taewan on 2017. 4. 23..
//  Copyright © 2017년 taewan. All rights reserved.
//

import UIKit

import RxSwift
import RxCocoa

final class LookupContentTableViewCell: UITableViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var contentLabel: UILabel!
    
    fileprivate var disposeBag = DisposeBag()
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
}




// MARK: - ViewModel Configurable
extension LookupContentTableViewCell: Configurable, ConfigureCell {
    func configure(by viewModel: LookupContentCellModelType) {
        disposeBag = DisposeBag()
        
        let output = viewModel.output
        
        output.title
            .drive(self.titleLabel.rx.text)
            .addDisposableTo(disposeBag)
        
        output.content
            .drive(self.contentLabel.rx.text)
            .addDisposableTo(disposeBag)
    }
}
