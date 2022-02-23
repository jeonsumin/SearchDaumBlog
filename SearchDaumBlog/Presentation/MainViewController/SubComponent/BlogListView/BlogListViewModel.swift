//
//  BlogListViewModel.swift
//  SearchDaumBlog
//
//  Created by Terry on 2022/02/23.
//

import RxSwift
import RxCocoa

struct BlogListViewModel {
 
    let filterViewModel = FilterViewModel()
    
    let blogCellData = PublishSubject<[BlogListCellData]>()
    let cellData: Driver<[BlogListCellData]>
    
    init(){
        self.cellData = blogCellData
            .asDriver(onErrorJustReturn: [])
    }
    
}
