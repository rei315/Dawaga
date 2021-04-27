//
//  App.swift
//  Dawaga
//
//  Created by 김민국 on 2021/04/27.
//

import Foundation

enum App {}
extension App {

}

enum AppString {}
extension AppString {
    static let Destination = "Destination"
    static let NotificationID = "reach_notification_id"
    static let LocationID = "reach_location_id"
    static let NotificationTitle = "DawagaNotificationTitle"
    static let NotificationBody = "DawagaNotificationBody"
    static let NotificationPermissionTitle = "NotificationPermissionTitle"
    static let NotificationPermissionMessage = "NotificationPermissionBody"
    static let LocationDeniedTitle = "LocationDeniedTitle"
    static let LocationDeniedMessage = "LocationDeniedBody"
    static let NotificationErrorTitle = "NotificationErrorTitle"
    static let NotificationErrorMessage = "NotificationErrorBody"
    
    static let Fifty = "50M"
    static let Hundred = "100M"
    static let Thousand = "1000M"
    
    static let DistanceEdit = "DawagaMapDistanceEdit"
    static let DawagaMapStart = "DawagaMapStart"
    static let DawagaMapEditValuePlaceHolder = "DawagaMapEditValuePlaceHolder"
    static let DawagaMapAddBookMark = "DawagaMapAddBookMark"
    static let DawagaMapDeleteBookMark = "DawagaMapDeleteBookMark"
    static let DawagaMapModifyBookMark = "DawagaMapModifyBookMark"
    static let DawagaMapEditViewPlaceHolder = "DawagaMapEditViewPlaceHolder"
    
    static let AddressPlaceHolder = "AddressPlaceHolder"
    static let HomeTitle = "HomeTitle"
    static let BookMarkTitle = "BookMarkTitle"
    
    static let InputError = "InputError"
    static let BookMarkAddressEmptyAlertMessage = "BookMarkAddressEmptyAlertMessage"
    static let BookMarkNameEmptyAlertMessage = "BookMarkNameEmptyAlertMessage"
    static let BookMarkImageEmptyAlertMessage = "BookMarkImageEmptyAlertMessage"
    static let BookMarkRealmErrorAlertMessage = "BookMarkRealmErrorAlertMessage"
    
    static let CreatedComplete = "CreatedComplete"
    static let UpdateComplete = "UpdateComplete"
    static let BookMarkCreated = "BookMarkCreated"
    static let BookMarkUpdated = "BookMarkUpdated"
    
    static let TutorialDoneTitle = "TutorialDoneTitle"
    
    static let Enter = "Enter"
}

enum Url {}
extension Url {
    static let AutoCompleteUrl = "https://maps.googleapis.com/maps/api/place/autocomplete/json"
    static let DetailUrl = "https://maps.googleapis.com/maps/api/place/details/json"
    static let ReverseGeocodeUrl = "https://maps.googleapis.com/maps/api/geocode/json"
}

enum NavigationTitle {}
extension NavigationTitle {
    static let DestinationAddress = "SearchAddressTitle"
}
