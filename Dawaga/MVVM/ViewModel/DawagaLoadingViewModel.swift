//
//  DawagaLoadingViewModel.swift
//  Dawaga
//
//  Created by 김민국 on 2021/04/27.
//

import RxSwift
import CoreLocation

class DawagaLoadingViewModel {
    
    // MARK: - Property
    
    private var model: DawagaLoadingModel!
    private let disposeBag = DisposeBag()
    
    private var destination: CLLocation!
    private var distance: Int!
    
    let didArrivedLocation = PublishSubject<Void>()
    
    let authorization = PublishSubject<CLAuthorizationStatus>()
    
    // MARK: - Lifecycle
    
    init(model: DawagaLoadingModel, destination: CLLocation, distance: Int) {
        self.model = model
        self.destination = destination
        self.distance = distance
        
        self.configureLocationManager()
    }
    
    
    // MARK: - Function

    private func configureLocationManager() {
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
            .map { $0.locations.last }
            .flatMap(Observable.from(optional: ))
            .flatMap({ (loc) -> Observable<Void?> in
                let dis = loc.distance(from: self.destination)
                guard dis <= Double(self.distance) else { return Observable.just(nil)}

                self.model.stopUpdateLocation()
                return Observable.just(())
            })
            .flatMap(Observable.from(optional: ))
            .bind(to: didArrivedLocation)
            .disposed(by: disposeBag)
    }
}
