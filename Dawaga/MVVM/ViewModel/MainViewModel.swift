//
//  MainViewModel.swift
//  Dawaga
//
//  Created by 김민국 on 2021/04/27.
//

import RxSwift
import RxCocoa

class MainViewModel {
    
    // MARK: - Property
    
    let disposeBag = DisposeBag()
    
    let bookMarks = BehaviorRelay<[MarkRealmEntity]>(value: [])
    
    let model: MainModel!
    
    
    // MARK: - Lifecycle
    init(model: MainModel) {
        self.model = model
    }
    
    
    // MARK: - Function

    func fetchBookMarks() {
        model.fetchBookMarks()
            .bind(to: bookMarks)
            .disposed(by: disposeBag)
    }
}
