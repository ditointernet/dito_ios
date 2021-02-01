//
//  DitoNotificationReceived.swift
//  DitoSDK
//
//  Created by Rodrigo Damacena Gamarra Maciel on 29/01/21.
//

import Foundation

public struct DitoNotificationReceived {
    
    var notification: String = ""
    var notificationLogId: String = ""
    public let deeplink: String
    
    init(with userInfo: [AnyHashable: Any]) {
        
        let custom_data = userInfo["custom_data"] as? [String: Any]
        deeplink = custom_data?["link"] as? String ?? ""
        
        if let notification = custom_data?["notification"] as? String {
            self.notification = notification
        } else if let notification = custom_data?["notification"] as? Int {
            self.notification = notification.toString
        }
        
        if let notificationLogId = custom_data?["notification_log_id"] as? String {
            self.notificationLogId = notificationLogId
        } else if let notificationLogId = custom_data?["notification_log_id"] as? Int {
            self.notificationLogId = notificationLogId.toString
        }
    }
}
