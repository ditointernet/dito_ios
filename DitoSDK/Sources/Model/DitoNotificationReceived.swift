//
//  DitoNotificationReceived.swift
//  DitoSDK
//
//  Created by Rodrigo Damacena Gamarra Maciel on 29/01/21.
//

import Foundation

public struct DitoNotificationReceived {
    
    var reference: String = ""
    var identifier: String = ""
    var notification: String = ""
    var notificationLogId: String = ""
    public var deeplink: String = ""
    
    init(with userInfo: [AnyHashable: Any]) {
        
        if let notification = userInfo["notification"] as? String {
            self.notification = notification
        }
        
        if let link = userInfo["link"] as? String {
            self.deeplink = link
        }

        
        if let reference = userInfo["reference"] as? String {
            self.reference = reference
        }
        
        if let identifier = userInfo["user_id"] as? String {
            self.identifier = identifier
        }
        
        if let notificationLogId = userInfo["notification_log_id"] as? String {
            self.notificationLogId = notificationLogId
        }
    }
}
