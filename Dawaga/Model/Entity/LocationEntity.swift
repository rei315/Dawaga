//
//  LocationEntity.swift
//  Dawaga
//
//  Created by 김민국 on 2021/04/27.
//

import Foundation
import CoreLocation
import SwiftyJSON

struct LocationEntity {
    var title: String
    let location: CLLocation
    
    init(json: JSON) {
        var fullAddress = json["formatted_address"].string ?? ""
        
        if let addressData = json["address_components"].arrayValue.filter({ $0["types"].arrayObject!.contains { $0 as! String == "country"} }).first {
            if let country = addressData["long_name"].string {
                fullAddress = fullAddress.replacingOccurrences(of: country, with: "")
            }
        }

        self.title = fullAddress
        
        if let geometry = json["geometry"].dictionary {
            if let location = geometry["location"]?.dictionary {
                let lat = location["lat"]?.double ?? 0
                let lon = location["lng"]?.double ?? 0
                
                self.location = CLLocation(latitude: lat, longitude: lon)
            } else {
                self.location = CLLocation(latitude: 0, longitude: 0)
            }
        } else {
            self.location = CLLocation(latitude: 0, longitude: 0)
        }
    }
}
