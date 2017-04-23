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
    
    @IBOutlet weak var tableView: UITableView!
    
    let dataSource = RxTableViewSectionedReloadDataSource<LookupSectionData>()
    
    var viewModel: LookupViewModelType!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("AppLookupViewController - viewDidLoad")
        setup()
        rxSetup()
    }
    
    private func setup() {
        tableView.alpha = 0
        tableView.estimatedRowHeight = 200//128
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
        
        rx.viewDidLayoutSubviews
            .subscribe(onNext: { [weak self] _ in
                guard let tableView = self?.tableView else { return }
                tableView.setNeedsLayout()
                tableView.layoutIfNeeded()
                tableView.reloadData()
            }).disposed(by: disposeBag)
        
        
        //input
        let input = self.viewModel.input
        
        self.rx.viewWillAppear
            .map { _ in }
            .take(1)
            .bind(to: input.refresh)
            .disposed(by: disposeBag)
        
        // output
        
        let output = self.viewModel.output
        
        output.loadCompleted
            .observeOn(
                AnimateScheduler(withDuration: 0.3, options:[.curveEaseOut])
            ).map { _ in 1 }
            .bind(to: self.tableView.rx.alpha)
            .disposed(by: disposeBag)
        
     
        output.sections
            .drive(tableView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
        
        output.header
            .drive(weak: self, type(of: self).updateHeader)
            .disposed(by: disposeBag)
        
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
        default:
            return "ContentCell"
        }
    }
    
}
