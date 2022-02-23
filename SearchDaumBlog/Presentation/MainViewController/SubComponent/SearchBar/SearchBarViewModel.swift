//
//  SearchBarViewModel.swift
//  SearchDaumBlog
//
//  Created by Terry on 2022/02/23.
//

import RxSwift
import RxCocoa

struct SearchBarViewModel{
    let queryText = PublishRelay<String?>()
    let didTappedSearchButton = PublishRelay<Void>()
    let shouldLoadResult: Observable<String>
    
    init(){
        self.shouldLoadResult = didTappedSearchButton
            .withLatestFrom(queryText){ $1 ?? "" }
            .filter{ !$0.isEmpty}
            .distinctUntilChanged()
    }
}
