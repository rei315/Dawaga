//
//  PlaceSearchModel.swift
//  Dawaga
//
//  Created by 김민국 on 2021/04/27.
//

import RxSwift

struct PlaceSearchModel {
    
    func fetchAutoCompleteList(address: String) -> Observable<[PlaceEntity]> {
        return APIManagerForGoogleMaps.shared.getAutoCompleteList(address: address)
            .map { Place.getPlaceListBy(json: $0) }
        
    }
}
