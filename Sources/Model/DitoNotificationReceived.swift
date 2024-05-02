
//
//  DitoNotificationReceived.swift
//  DitoSDK
//
//  Created by Rodrigo Damacena Gamarra Maciel on 29/01/21.
//

import Foundation

public struct DitoNotificationReceived {
    var notification: String = ""
    var deeplink: String = ""
    var notificationLogId: String = ""

    init(with userInfo: [AnyHashable: Any]) {
        if let notification = userInfo["notification"] as? String {
            self.notification = notification
        } else if let notification = userInfo["notification"] as? Int {
            self.notification = notification.toString
        }

        if let deeplink = userInfo["link"] as? String {
            self.deeplink = deeplink
        }

        if let notificationLogId = userInfo["notification_log_id"] as? Int {
            self.notificationLogId = String(notificationLogId)
        }
    }

}
