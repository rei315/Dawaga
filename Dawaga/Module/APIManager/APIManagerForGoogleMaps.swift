//
//  APIManagerForGoogleMaps.swift
//  Dawaga
//
//  Created by 김민국 on 2021/04/27.
//

import Foundation
import Alamofire
import SwiftyJSON
import CoreLocation
import RxSwift

class APIManagerForGoogleMaps {
    
    private let AutoCompleteUrl = "https://maps.googleapis.com/maps/api/place/autocomplete/json"
    private let DetailUrl = "https://maps.googleapis.com/maps/api/place/details/json"
    private let ReverseGeocodeUrl = "https://maps.googleapis.com/maps/api/geocode/json"
    
    private let key = GOOGLE_API_KEY
    
    
    // MARK: - Singleton Instance
    
    static let shared = APIManagerForGoogleMaps()
    
    private init() {}

    
    // MARK: - Function

    func getAutoCompleteList(address: String) -> Observable<JSON> {
        
        let parameters: [String : Any] = [
            "input"     :   address,
            "types"     :   "geocode|establishment",
            "key"       :   key
        ]
        
        return Observable.create { observer in
            AF.request(self.AutoCompleteUrl, method: .get, parameters: parameters).validate().responseJSON { response in
                
                switch response.result {
                case .success(let value):
                    let res = JSON(value)
                    let json = res["predictions"]
                    observer.onNext(json)
                    observer.onCompleted()
                    
                case .failure(let error):
                    observer.onError(error)
                }
            }
            
            return Disposables.create {}
        }
    }
    
    func getPlaceDetails(placeId: String) -> Observable<JSON> {
        
        let parameters: [String : Any] = [
            "place_id"  :   placeId,
            "key"       :   key
        ]
        
        return Observable.create { observer in
            AF.request(self.DetailUrl, method: .get, parameters: parameters).validate().responseJSON { response in
                switch response.result {
                case .success(let value):
                    let res = JSON(value)
                    let json = res["result"]
                    observer.onNext(json)
                    
                case .failure(let error):
                    observer.onError(error)
                }
            }
            
            return Disposables.create {}
        }
    }
    
    func getReverseGeocode(location: CLLocation) -> Observable<JSON> {
        
        let parameters: [String : Any] = [
            "latlng"            :      "\(location.coordinate.latitude),\(location.coordinate.longitude)",
            "key"               :      key,
            "location_type"     :      "ROOFTOP"
        ]
        
        return Observable.create { observer in
            AF.request(self.ReverseGeocodeUrl, method: .get, parameters: parameters).validate().responseJSON { response in
                switch response.result {
                case .success(let value):
                    let res = JSON(value)
                    
                    if let json = res["results"].arrayValue.first {
                        observer.onNext(json)
                    }
                    else {
                        let error: AFError.ResponseValidationFailureReason = .dataFileNil
                        observer.onError(AFError.responseValidationFailed(reason: error))
                    }
                                        
                case .failure(let error):
                    observer.onError(error)
                }
            }
            
            return Disposables.create {}
        }
    }
}
