//
//  DitoNotificationOffline.swift
//  DitoSDK
//
//  Created by Rodrigo Damacena Gamarra Maciel on 26/01/21.
//

import Foundation

import CoreData

struct DitoNotificationOffline {
    
    private var notificationDataManager: DitoNotificationReadDataManager
    private let identifyOffline: DitoIdentifyOffline
    
    init(trackDataManager: DitoNotificationReadDataManager = .init(), identifyOffline: DitoIdentifyOffline = .init()) {
        self.notificationDataManager = trackDataManager
        self.identifyOffline = identifyOffline
    }
    
    func notificationRead(_ notification: DitoNotificationOpenRequest) {
        DispatchQueue.global().async {
            let json = notification.toString
            notificationDataManager.save(json: json)
        }
    }
    
    var reference: String? {
        return identifyOffline.getIdentify?.reference
    }
    
    var getNotification: [NotificationRead] {
        return notificationDataManager.fetchAll
    }
    
    func update(id: NSManagedObjectID, retry: Int16) {
        notificationDataManager.update(id: id, retry: retry)
    }
    
    func delete(id: NSManagedObjectID) {
        notificationDataManager.delete(with: id)
    }
}
