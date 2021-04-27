//
//  LocationNotificationEntity.swift
//  Dawaga
//
//  Created by 김민국 on 2021/04/27.
//

import CoreLocation

struct LocationNotificationEntity {
    
    let notificationId: String
    let locationId: String
    
    let title: String
    let body: String
    let data: [String: Any]?
}
