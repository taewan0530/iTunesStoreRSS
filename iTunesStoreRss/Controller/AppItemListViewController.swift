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

final class AppItemListViewController: RxViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    let refreshControl = UIRefreshControl()
    
    let dataSource = RxTableViewSectionedReloadDataSource<ItemSectionData>()
    
    var viewModel: ItemListViewModelType!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
        rxSetup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let indexPath = tableView.indexPathForSelectedRow {
            tableView.deselectRow(at: indexPath, animated: false)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        defer {
            super.prepare(for: segue, sender: sender)
        }
        
        switch segue.destination {
        case let controller as AppLookupViewController:
            controller.viewModel = sender as? LookupViewModelType
        default:
            break
        }
        
    }
    
    private func setup() {
        tableView.addSubview(refreshControl)
        
        dataSource.configureCell = { (datasource, tableView, indexPath, item) in
            let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
            (cell as? ConfigureCell)?.configure(by: item)
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
        
        let viewWillAppear = self.rx.viewWillAppear.map { _ in }.take(1)
        let refresh = self.refreshControl.rx.controlEvent(.valueChanged).map { _ in }
        
        Observable.from([viewWillAppear, refresh])
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
        
        output.performLookup
            .map { ("ToLookup", $0) }//음 이작업을 어디서 해줄까..
            .drive(weak: self, type(of: self).performSegue)
            .disposed(by: disposeBag)
        
    }
    
}


extension AppItemListViewController: UITableViewDelegate {
    
}
