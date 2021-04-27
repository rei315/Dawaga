//
//  DawagaMapModel.swift
//  Dawaga
//
//  Created by 김민국 on 2021/04/27.
//

import RxSwift
import CoreLocation
import RxCoreLocation

struct DawagaMapModel {
    
    // MARK: - Property
    
    let manager: CLLocationManager?
    
    
    // MARK: - Lifecycle
    
    init() {
        manager = CLLocationManager()
        configureManager()
    }
    
    
    // MARK: - LocationManager Function

    func configureManager() {
        manager?.desiredAccuracy = kCLLocationAccuracyBestForNavigation
        manager?.pausesLocationUpdatesAutomatically = false
        manager?.requestAlwaysAuthorization()
    }
    
    func requestLocation() {
        manager?.requestLocation()
    }
    
    
    // MARK: - API Function
    
    func fetchReverseGeocode(location: CLLocation) -> Observable<LocationEntity> {
        return APIManagerForGoogleMaps.shared.getReverseGeocode(location: location)
            .map { Location.getLocationBy(json: $0) }
    }
    
    func fetchAddressDetail(placeID: String) -> Observable<LocationEntity>{
        return APIManagerForGoogleMaps.shared.getPlaceDetails(placeId: placeID)
            .map { Location.getLocationBy(json: $0) }
    }
    
    
    // MARK: - BookMark Function
    
    func saveBookMark(mark: MarkRealmEntity) -> Observable<Void> {
        return MarkRealm.saveMarkRealm(mark: mark)
    }
    
    func editBookMark(identity: String, name: String, address: String, iconImage: String, latitude: Double, longitude: Double) -> Observable<Void> {
        return MarkRealm.editMarkRealm(identity: identity, name: name, address: address, iconImage: iconImage, latitude: latitude, longitude: longitude)
    }
    
    func removeBookMark(identity: String) -> Observable<Void> {
        return MarkRealm.removeMarkRealm(identity: identity)
    }
}
