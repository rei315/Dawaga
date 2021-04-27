//
//  BookMarkIconSelectorViewModel.swift
//  Dawaga
//
//  Created by 김민국 on 2021/04/27.
//

import RxSwift
import RxCocoa

class BookMarkIconSelectorViewModel {
    
    // MARK: - Property
    
    let iconTitles = BehaviorRelay<[BookMarkIconSectionModel]>(value: [])
    
    let disposeBag = DisposeBag()
    
    let model: BookMarkIconSelectorModel!
    
    
    // MARK: - Lifecycle
    
    init(model: BookMarkIconSelectorModel) {
        self.model = model
        
        self.fetchIcons()
    }
    
    
    // MARK: - Function
    
    private func fetchIcons() {
        model.fetchIconTitles()
            .flatMap{Observable.from($0)}
            .map { BookMarkIconSectionItem.icon(iconURL: $0) }
            .toArray()
            .asObservable()
            .map { [BookMarkIconSectionModel(model: .icon, items: $0)] }
            .bind(to: iconTitles)
//            .subscribe(onNext: { [weak self] data in
//                self?.iconTitles.accept(data)
//            })
            .disposed(by: disposeBag)
    }
}
