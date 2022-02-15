//
//  MainViewController.swift
//  SearchDaumBlog
//
//  Created by Terry on 2022/02/15.
//

import UIKit
import RxSwift
import RxCocoa

class MainViewController: UIViewController {

    let disposeBag = DisposeBag()
    
    let listView = BlogListView()
    let searchView = SearchBar()
    
    let alertActionTapped = PublishRelay<AlertAction>()
    
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        bind()
        attribute()
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func bind(){
        /// Rx코드
        /// ui 바인딩 작업
        
        let alertSheetForSorting = listView.headerView.sortButtonTapped
            .map { _ -> Alert in
                return (title:nil, message:nil, actions:[.title,.datetime,.cancel],style:.actionSheet)
            }
            
        alertSheetForSorting
            .asSignal(onErrorSignalWith: .empty())
            .flatMap { alert -> Signal<AlertAction> in
                let alertController = UIAlertController(title: alert.title, message: alert.message, preferredStyle: alert.style)
                return self.presentAlertController(alertController, actions: alert.actions)
            }.emit(to: alertActionTapped)
            .disposed(by: disposeBag)
    }
    
    private func attribute(){
        /// view attribute 함수
        title = "다음 블로그 검색"
        view.backgroundColor = .systemBackground
    }
    
    private func layout(){
        [searchView,listView].forEach{view.addSubview($0)}
        
        searchView.snp.makeConstraints{
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.leading.trailing.equalToSuperview()
        }
        listView.snp.makeConstraints{
            $0.top.equalTo(searchView.snp.bottom)
            $0.leading.trailing.bottom.equalToSuperview()
        }
        
    }
}
//MARK: - Alert
extension MainViewController {
    typealias Alert = (title: String?, message: String?, actions: [AlertAction], style: UIAlertController.Style)
    
    enum AlertAction: AlertActionConvertible {
        case title, datetime, cancel
        case confirm
        
        var title: String {
            switch self {
            case .title:
                return "Title"
            case .datetime:
                return "DateTime"
            case .cancel:
                return "취소"
            case .confirm:
                return "확인"
            }
        }
        
        var style: UIAlertAction.Style {
            switch self {
            case .title, .datetime :
                return .default
            case .cancel, .confirm:
                return .cancel
            }
        }
    }
    func presentAlertController<Action:AlertActionConvertible>(_ alertController: UIAlertController,actions:[Action]) -> Signal<Action>{
        if actions.isEmpty { return .empty() }
        return Observable
            .create { [weak self] observer in
                guard let self = self else { return Disposables.create() }
                for action in actions {
                    alertController.addAction(
                        UIAlertAction(title: action.title, style: action.style, handler: { _ in
                            observer.onNext(action)
                            observer.onCompleted()
                        })
                    )
                }
                self.present(alertController, animated: true, completion: nil)
                
                return Disposables.create {
                    alertController.dismiss(animated: true, completion: nil)
                }
            }
            .asSignal(onErrorSignalWith: .empty())
    }
}
