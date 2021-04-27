//
//  MarkRealm.swift
//  Dawaga
//
//  Created by 김민국 on 2021/04/27.
//

import Foundation
import RxSwift
import RxCocoa
import CoreLocation
import RealmSwift

class MarkRealm {
    
    static func getMarkRealmList() -> Observable<[MarkRealmEntity]> {
        return Observable.create { observer in
            do {
                let realm = try Realm()
                let markItems = realm.objects(MarkRealmEntity.self)
                observer.onNext(Array(markItems))
            }
            catch {
                observer.onError(error)
            }
            
            return Disposables.create {}
        }
    }
    
    static func saveMarkRealm(mark: MarkRealmEntity) -> Observable<Void> {
        return Observable.create { observer in
            do {
                let realm = try Realm()
                
                try realm.write {
                    realm.add(mark)
                    observer.onNext(())
                    observer.onCompleted()
                }
            } catch {
                observer.onError(error)
            }
            return Disposables.create {}
        }
    }
    
    static func removeMarkRealm(identity: String) -> Observable<Void> {
        return Observable.create { observer in
            
            do {
                let realm = try Realm()
                if let data = realm.object(ofType: MarkRealmEntity.self, forPrimaryKey: identity) {
                    try realm.write {
                        realm.delete(data)
                        observer.onNext(())
                        observer.onCompleted()
                    }
                }
                else {
                    print("removeMarkRealm error")
                }
            }
            catch {
                observer.onError(error)
            }
            
            return Disposables.create {}
        }
    }
    
    static func editMarkRealm(identity: String, name: String = "", address: String = "", iconImage: String = "", latitude: Double = 0, longitude: Double = 0) -> Observable<Void> {
        return Observable.create { observer in
            
            do {
                let realm = try Realm()
                if let data = realm.object(ofType: MarkRealmEntity.self, forPrimaryKey: identity) {
                    try realm.write {
                        let newData = MarkRealmEntity(
                            identity: data.identity,
                            name: name.isEmpty ? data.name : name,
                            latitude: latitude.isZero ? data.latitude : latitude,
                            longitude: longitude.isZero ? data.longitude : longitude,
                            address: address.isEmpty ? data.address : address,
                            iconImageUrl: iconImage.isEmpty ? data.iconImageUrl : iconImage
                        )
                        realm.add(newData, update: .modified)
                        observer.onNext(())
                        observer.onCompleted()
                    }
                }
                else {
                    print("editMarkRealm error")
                }
            }
            catch {
                observer.onError(error)
            }
            
            return Disposables.create {}
        }
    }
}
