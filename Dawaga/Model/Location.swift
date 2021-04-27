//
//  Location.swift
//  Dawaga
//
//  Created by 김민국 on 2021/04/27.
//

import Foundation
import SwiftyJSON

class Location {
    
    static func getLocationBy(json: JSON) -> LocationEntity {
        
        return LocationEntity.init(json: json)
    }
}
