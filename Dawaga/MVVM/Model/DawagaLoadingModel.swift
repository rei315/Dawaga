//
//  DawagaLoadingModel.swift
//  Dawaga
//
//  Created by 김민국 on 2021/04/27.
//

import RxSwift
import CoreLocation
import RxCoreLocation

struct DawagaLoadingModel {
    
    // MARK: - Property
    
    let manager: CLLocationManager?
    
    
    // MARK: - Lifecycle
    
    init() {
        manager = CLLocationManager()
        self.configureManager()
    }
    
    
    // MARK: - LocationManager Function

    func configureManager() {
        manager?.desiredAccuracy = kCLLocationAccuracyBestForNavigation
        manager?.pausesLocationUpdatesAutomatically = false
        manager?.requestAlwaysAuthorization()
    }
    
    func startUpdateLocation() {
        manager?.startUpdatingLocation()
    }
    
    func stopUpdateLocation() {
        manager?.stopUpdatingLocation()
    }
}
