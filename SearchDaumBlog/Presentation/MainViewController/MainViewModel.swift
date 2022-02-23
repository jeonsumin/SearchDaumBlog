//
//  MainViewModel.swift
//  SearchDaumBlog
//
//  Created by Terry on 2022/02/23.
//

import RxSwift
import RxCocoa
import UIKit

struct MainViewModel {
    let disposeBag = DisposeBag()
    
    let blogListViewModel = BlogListViewModel()
    let searchBarViewModel = SearchBarViewModel()
    
    let alertActionTapped = PublishRelay<MainViewController.AlertAction>()
    
    let shouldPresentAlert: Signal<MainViewController.Alert>
    
    init(model: MainModel = MainModel() ){
        let blogResult = searchBarViewModel.shouldLoadResult
            .flatMapLatest (model.searchBlog)
            .share()
        
        let blogValue = blogResult
            .compactMap(model.getBlogValue)
        
        let blogError = blogResult
            .compactMap(model.getBlogError)
        
        //네트워크를 통해 가져온 값을 Celldata로 변환
        let cellData = blogValue
            .map(model.getBlogListCellData)
    
        //FilterView를 선택했을때 표시되는 alertSheet Type설정
        let sortedType = alertActionTapped
            .filter {
                switch $0 {
                case .title, .datetime:
                    return true
                default:
                    return false
                }
            }
            .startWith(.title)
       
        //MainViewController -> ListView
        Observable.combineLatest(sortedType, cellData, resultSelector: model.sort)
            .bind(to: blogListViewModel.blogCellData)
            .disposed(by: disposeBag)
        
        
        let alertSheetForSorting = blogListViewModel.filterViewModel.sortButtonTapped
            .map { _ -> MainViewController.Alert in
                return (title:nil, message:nil, actions:[.title,.datetime,.cancel],style:.actionSheet)
            }
        
        let alertForErrorMessage = blogError
            .map { message -> MainViewController.Alert in
                return (
                    title: "앗!",
                    message: "예상치 못한 오류가 발생했습니다. 잠시후 다시 시도해 주세요. \(message)",
                    actions: [.confirm],
                    style: .alert)
            }
        self.shouldPresentAlert = Observable
            .merge(alertSheetForSorting, alertForErrorMessage)
            .asSignal(onErrorSignalWith: .empty())

    }
    
}
