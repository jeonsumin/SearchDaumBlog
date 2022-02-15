//
//  SearchBar.swift
//  SearchDaumBlog
//
//  Created by Terry on 2022/02/15.
//

import RxSwift
import RxCocoa
import UIKit
import SnapKit

class SearchBar: UISearchBar {
    let disposeBag = DisposeBag()
    
    let searchButton = UIButton()
    
    //Searchbar 버튼 탭 이벤트
    let didTappedSearchButton = PublishRelay<Void>()
    
    //SearchBar 외부로 보낼 이벤트
    var shouldLoadResult = Observable<String>.of("")
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        bind()
        attribute()
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func bind(){
        //searchBar search button tapped
        //buttontapped
        
        Observable
            .merge(
                self.rx.searchButtonClicked.asObservable(),
                searchButton.rx.tap.asObservable()
            ).bind(to: didTappedSearchButton)
            .disposed(by: disposeBag)
        
        didTappedSearchButton
            .asSignal()
            .emit(to: self.rx.endEditing)
            .disposed(by: disposeBag)
        
        self.shouldLoadResult = didTappedSearchButton
            .withLatestFrom(self.rx.text){ $1 ?? "" }
            .filter{ !$0.isEmpty}
            .distinctUntilChanged()
    }
    private func attribute(){
        searchButton.setTitle("검색", for: .normal)
        searchButton.setTitleColor(.systemBlue, for: .normal)
        
    }
    private func layout(){
        addSubview(searchButton)
        searchTextField.snp.makeConstraints{
            $0.leading.equalToSuperview().offset(12)
            $0.trailing.equalTo(searchButton.snp.leading).offset(-12)
            $0.centerY.equalToSuperview()
        }
        searchButton.snp.makeConstraints{
            $0.centerY.equalToSuperview()
            $0.trailing.equalToSuperview().inset(12)
        }
        
    }
}

extension Reactive where Base:SearchBar {
    var endEditing: Binder<Void> {
        return Binder(base) { base ,_ in
            base.endEditing(true)
        }
    }
}
