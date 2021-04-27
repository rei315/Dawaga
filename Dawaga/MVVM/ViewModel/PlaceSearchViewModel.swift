//
//  PlaceSearchViewModel.swift
//  Dawaga
//
//  Created by 김민국 on 2021/04/27.
//

import RxSwift
import RxCocoa

class PlaceSearchViewModel {
    
    private let disposeBag = DisposeBag()
    
    let searchText = BehaviorRelay<String?>(value: nil)
    let searchedPlace = BehaviorRelay<[PlaceEntity]>(value: [])
    
    private let model: PlaceSearchModel!
    
    init(model: PlaceSearchModel, address: String?) {
        self.model = model
        
        searchText.accept(address)
        
        self.configurePlace()
    }
    
    private func configurePlace() {
        searchText
            .flatMap(Observable.from(optional: ))
            .flatMap(model.fetchAutoCompleteList)
            .subscribe(onNext: { [unowned self] places in
                self.searchedPlace.accept(places)
            })
            .disposed(by: disposeBag)
    }
}
