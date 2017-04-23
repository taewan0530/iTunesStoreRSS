//
//  LookupScreenshotTableViewCell.swift
//  iTunesStoreRss
//
//  Created by taewan on 2017. 4. 23..
//  Copyright © 2017년 taewan. All rights reserved.
//

import UIKit

import RxSwift
import RxCocoa
import RxDataSources


final class LookupScreenshotTableViewCell: UITableViewCell {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    fileprivate var disposeBag = DisposeBag()
    
    let dataSource = RxCollectionViewSectionedReloadDataSource<SectionModel<Void, URL>>()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setup()
    }
    
    private func setup() {
        dataSource.configureCell = { (datasource, collectionView, indexPath, item) in
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath)
            
            if let imageCell = cell as? LookupScreenshotImageCell {
                imageCell.imageView.af_setImage(withURL: item,
                                      imageTransition: .crossDissolve(0.3))
            }
            
            return cell
        }

    }
    
    
}


extension LookupScreenshotTableViewCell: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 196, height: min(collectionView.bounds.height, 348))
    }
    
    
}



// MARK: - ViewModel
extension LookupScreenshotTableViewCell: Configurable, ConfigureCell {
    func configure(by viewModel: LookupScreenshotCellModelType) {
        
        disposeBag = DisposeBag()
        
        collectionView
            .rx.setDelegate(self)
            .disposed(by: disposeBag)
        
        Observable.just(viewModel.urls)
            .map { [SectionModel(model: Void(), items: $0)] }
            .asDriver(onErrorJustReturn: [])
            .drive(collectionView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
        
    }
    
}


final class LookupScreenshotImageCell: UICollectionViewCell {
    
    @IBOutlet weak var imageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.backgroundColor = .lightGray
        self.layer.borderColor = UIColor.lightGray.cgColor
        self.layer.borderWidth = 1/UIScreen.main.scale
    }
    
    
}
