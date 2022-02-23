//
//  FilterViewModel.swift
//  SearchDaumBlog
//
//  Created by Terry on 2022/02/23.
//

import RxSwift
import RxCocoa

struct FilterViewModel {
    let sortButtonTapped = PublishRelay<Void>()
}
