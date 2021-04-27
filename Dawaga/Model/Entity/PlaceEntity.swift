//
//  PlaceEntity.swift
//  Dawaga
//
//  Created by 김민국 on 2021/04/27.
//

import Foundation
import SwiftyJSON

struct PlaceEntity {
    let placeId: String
    let placeName: String
    
    init(json: JSON) {
        self.placeId = json["place_id"].string ?? ""
        self.placeName = json["description"].string ?? ""
    }
}
