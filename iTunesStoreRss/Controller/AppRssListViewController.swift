//
//  AppRssListViewController.swift
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

final class AppRssListViewController: RxViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    let refreshControl = UIRefreshControl()
    
    let dataSource = RxTableViewSectionedReloadDataSource<ItemSectionData>()
    
    var viewModel: AppItemListViewModelType!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
        rxSetup()
    }
    
    private func setup() {
        tableView.addSubview(refreshControl)
        dataSource.configureCell = { (datasource, tableView, indexPath, item) in
            let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
            if let rssCell = cell as? AppItemTableViewCell {
                //뷰모델 생성
                rssCell.configure(item)
                
            }
            //여기에서.
            return cell
        }
    }
    
    private func rxSetup() {
        assert(viewModel != nil, "viewModel을 선언해서 넣어주세요!")
        self.tableView
            .rx.setDelegate(self)
            .disposed(by: disposeBag)
        
        // input
        let input = self.viewModel.input
        
        let rxWillAppear = self.rx.viewWillAppear.map { _ in }
        let rxRefresh = self.refreshControl.rx.controlEvent(.valueChanged).map { _ in }
        
        Observable.from([rxWillAppear, rxRefresh])
            .merge()
            .bind(to: input.refresh)
            .disposed(by: disposeBag)
        
        self.tableView
            .rx.itemSelected
            .bind(to: input.itemDidSelect)
            .disposed(by: disposeBag)
        
        
        // output
        let output = self.viewModel.output
        output.sections
            .drive(tableView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
        
        output.refreshCompleted
            .drive(self.refreshControl.rx.isRefreshing)
            .disposed(by: disposeBag)
        
        output.selectedAppId
            .map { ("ToLookup", $0) }//음 이작업을 어디서 해줄까..
            .drive(weak: self, type(of: self).performSegue)
            .disposed(by: disposeBag)
        
    }
    
}


extension AppRssListViewController: UITableViewDelegate {
    
}
