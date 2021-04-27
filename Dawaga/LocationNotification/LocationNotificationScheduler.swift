//
//  LocationNotificationScheduler.swift
//  Dawaga
//
//  Created by 김민국 on 2021/04/27.
//

import CoreLocation
import UserNotifications

protocol LocationNotificationSchedulerDelegate: UNUserNotificationCenterDelegate {
    
    func notificationPermissionDenied()

    func notificationScheduled(error: Error?)
}

class LocationNotificationScheduler: NSObject {
    
    weak var delegate: LocationNotificationSchedulerDelegate?
    
    func request(with notificationInfo: LocationNotificationEntity) {
        askForNotificationPermissions(notificationInfo: notificationInfo)
    }
}

// MARK: - Private Functions
private extension LocationNotificationScheduler {
    
    func askForNotificationPermissions(notificationInfo: LocationNotificationEntity) {
        UNUserNotificationCenter.current().requestAuthorization(
            options: [.alert, .sound, .badge],
            completionHandler: { [weak self] granted, _ in
                guard granted else {
                    self?.delegate?.notificationPermissionDenied()
                    return
                }
                self?.requestNotification(notificationInfo: notificationInfo)
        })
    }
    
    func requestNotification(notificationInfo: LocationNotificationEntity) {
        let notification = notificationContent(notificationInfo: notificationInfo)
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
        let request = UNNotificationRequest(identifier: notificationInfo.notificationId,
                                            content: notification,
                                            trigger: trigger)
        UNUserNotificationCenter.current().add(request) { [weak self] (error) in
            self?.delegate?.notificationScheduled(error: error)
        }
    }
    
    func notificationContent(notificationInfo: LocationNotificationEntity) -> UNMutableNotificationContent {
        let notification = UNMutableNotificationContent()
        notification.title = notificationInfo.title
        notification.body = notificationInfo.body
        notification.sound = UNNotificationSound.default
        notification.badge = 1
        
        if let data = notificationInfo.data {
            notification.userInfo = data
        }
        return notification
    }
}
