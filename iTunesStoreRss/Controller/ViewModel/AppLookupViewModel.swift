//
//  AppLookupViewModel.swift
//  iTunesStoreRss
//
//  Created by taewan on 2017. 4. 20..
//  Copyright © 2017년 taewan. All rights reserved.
//

import Foundation


final class AppLookupViewModel: AppLookupViewModelType, AppLookupViewModelInputType , AppLookupViewModelOutputType{
    var input: AppLookupViewModelInputType { return self }
    var output: AppLookupViewModelOutputType { return self }
    
    init() {
        
    }
    
}
