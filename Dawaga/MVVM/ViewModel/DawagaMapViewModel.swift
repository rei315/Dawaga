//
//  DawagaMapViewModel.swift
//  Dawaga
//
//  Created by 김민국 on 2021/04/27.
//

import RxSwift
import RxCocoa
import CoreLocation

class DawagaMapViewModel {
    
    // MARK: - Property
    
    private var model: DawagaMapModel!
    private let disposeBag = DisposeBag()
    
    
    var transitionType: DawagaMapViewController.TransitionType = .Quick
    
    var bookMark: MarkRealmEntity? = nil
    
    private var placeID: String? = nil
        
    let didRegionChanged = PublishSubject<CLLocation>()
    let didRegionChangedStr = BehaviorRelay<String>(value: "")
    
    let curDistance = BehaviorRelay<Int>(value: 0)
    
    let didUpdateLocation = PublishSubject<CLLocation>()
    
    let authorization = PublishSubject<CLAuthorizationStatus>()
    
    // MARK: - Lifecycle
    
    init(model: DawagaMapModel, transitionType: DawagaMapViewController.TransitionType, bookMark: MarkRealmEntity? = nil, placeID: String? = nil) {
        self.model = model
        self.transitionType = transitionType
        self.bookMark = bookMark
        self.placeID = placeID
        
        self.configureLocationManager()
    }

    
    // MARK: - Function

    func configureState() {
        switch transitionType {
        case .Quick:
            self.configureQuick()
        case .Search:
            guard let placeID = placeID else { return }
            self.configureSearch(placeId: placeID)
        case .BookMark:
            guard let bookMark = bookMark else { return }
            let location = CLLocation(latitude: bookMark.latitude, longitude: bookMark.longitude)
            self.configureBookMark(location: location)
        }
    }
    
    private func configureBookMark(location: CLLocation) {
        Observable.just(location)
            .bind(to: didUpdateLocation)
            .disposed(by: disposeBag)
    }
    
    private func configureSearch(placeId: String) {
        model.fetchAddressDetail(placeID: placeId)
            .map { ($0.location) }
            .bind(to: didUpdateLocation)
            .disposed(by: disposeBag)
    }
    
    private func configureQuick() {
        model.requestLocation()
    }
    
    private func configureLocationManager() {
        didRegionChanged
            .distinctUntilChanged()
            .flatMap { self.model.fetchReverseGeocode(location: $0) }
            .map { $0.title }
            .bind(to: didRegionChangedStr)
            .disposed(by: disposeBag)
        
        model.manager?.rx
            .didChangeAuthorization
            .map { $0.status }
            .bind(to: authorization)
            .disposed(by: disposeBag)
        
        model.manager?.rx.didError
            .subscribe(onNext: { error in
                print(error)
            })
            .disposed(by: disposeBag)
        
        model.manager?.rx
            .didUpdateLocations
            .map { ($0.locations.last ?? CLLocation(latitude: 0.0, longitude: 0.0)) }
            .bind(to: didUpdateLocation)
            .disposed(by: disposeBag)
    }
}
