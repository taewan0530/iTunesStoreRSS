//
//  AppLookupViewController.swift
//  iTunesStoreRss
//
//  Created by taewan on 2017. 4. 20..
//  Copyright © 2017년 taewan. All rights reserved.
//

import UIKit

import RxSwift
import RxCocoa
import RxDataSources
import RxBindNext

final class AppLookupViewController: RxViewController {
    
    @IBOutlet weak var lookupHeaderView: LookupHeaderView!
    
    @IBOutlet var sectionHeaderView: UIView!
    @IBOutlet weak var sectionHeaderSegmentedControl: UISegmentedControl!
    
    @IBOutlet weak var tableView: UITableView!
    
    let dataSource = RxTableViewSectionedReloadDataSource<LookupSectionData>()
    
    var viewModel: LookupViewModelType!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        rxSetup()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.setNeedsLayout()
        tableView.layoutIfNeeded()
        tableView.reloadData()
    }
    
    private func setup() {
        tableView.alpha = 0
        tableView.estimatedRowHeight = 128//200//
        tableView.rowHeight = UITableViewAutomaticDimension
        
        dataSource.configureCell = { (datasource, tableView, indexPath, item) in
            let cell = tableView.dequeueReusableCell(withIdentifier: item.type.identifier, for: indexPath)
            (cell as? ConfigureCell)?.configure(by: item)
            return cell
        }
    }
    
    private func rxSetup() {
        assert(viewModel != nil, "viewModel을 선언해서 넣어주세요!")
        tableView
            .rx.setDelegate(self)
            .disposed(by: disposeBag)
        
        //input
        let input = self.viewModel.input
        
        self.navigationItem.rightBarButtonItem?
            .rx.tap
            .bind(to: input.shareDidTap)
            .disposed(by: disposeBag)
        
        let appearLoad = self.rx.viewWillAppear
            .map { _ in LookupServiceType.lookup }
            .take(1)
        
        let segmentChanged = self.sectionHeaderSegmentedControl
            .rx.controlEvent(.valueChanged)
            .map { [weak self] _ -> LookupServiceType in
                let index = self?.sectionHeaderSegmentedControl.selectedSegmentIndex ?? 0
                return index == 0 ? .lookup : .review
        }
        
        Observable.from([appearLoad, segmentChanged])
            .merge()
            .bind(to: input.refresh)
            .disposed(by: disposeBag)
        
        // output
        
        let output = self.viewModel.output
        
        output.loadCompleted
            .observeOn(AnimateScheduler(withDuration: 0.3, options:[.curveEaseOut]))
            .map { _ in 1 }
            .bind(to: self.tableView.rx.alpha)
            .disposed(by: disposeBag)
        
        output.sections
            .drive(tableView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
        
        output.header
            .drive(weak: self, type(of: self).updateHeader)
            .disposed(by: disposeBag)
        
        output.shareToURL
            .drive(weak: self, type(of: self).share)
            .disposed(by: disposeBag)
    }
    
    func share(url: URL?) {
        guard let url = url else { return }
        
        let activityViewController = UIActivityViewController(activityItems: [url],
                                                              applicationActivities: nil)
        self.present(activityViewController, animated: true, completion: nil)
    }
    
    func updateHeader(by viewModel: LookupHeaderViewModelType?) {
        self.lookupHeaderView.configure(by: viewModel)
    }
}


extension AppLookupViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 44
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView?  {
        return sectionHeaderView
    }
    
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let y = sectionHeaderView.frame.origin.y
        let isHidden = y == lookupHeaderView.frame.height || y == 0
        
        sectionHeaderView.subviews
            .filter { $0 is UIVisualEffectView }
            .forEach { $0.isHidden = isHidden }
    }
    
}


extension LookupCellType {
    var identifier: String {
        switch self {
        case .screenshot:
            return "ScreenShotCell"
        case .content:
            return "ContentCell"
        case .review:
            return "ReviewCell"
        }
    }
    
}

/*
 let myWebsite = NSURL(string:"http://www.google.com/")
 let img: UIImage = image!
 
 guard let url = myWebsite else {
 print("nothing found")
 return
 }
 
 let shareItems:Array = [img, url]
 let activityViewController:UIActivityViewController = UIActivityViewController(activityItems: shareItems, applicationActivities: nil)
 activityViewController.excludedActivityTypes = [UIActivityTypePrint, UIActivityTypePostToWeibo, UIActivityTypeCopyToPasteboard, UIActivityTypeAddToReadingList, UIActivityTypePostToVimeo]
 self.presentViewController(activityViewController, animated: true, completion: nil)
 
 
 */
