//
//  DitoNotificationOffline.swift
//  DitoSDK
//
//  Created by Rodrigo Damacena Gamarra Maciel on 26/01/21.
//

import Foundation
import CoreData

struct DitoNotificationOffline {
    
    private var notificationRegisterDataManager: DitoNotificationRegisterDataManager
    private var notificationUnregisterDataManager: DitoNotificationUnregisterDataManager
    private var notificationDataManager: DitoNotificationReadDataManager
    private let identifyOffline: DitoIdentifyOffline
    
    init(notificationReadDataManager: DitoNotificationReadDataManager = .init(),
         notificationRegisterDataManager: DitoNotificationRegisterDataManager = .init(),
         notificationUnregisterDataManager: DitoNotificationUnregisterDataManager = .init(),
         identifyOffline: DitoIdentifyOffline = .init()) {
        
        self.notificationUnregisterDataManager = notificationUnregisterDataManager
        self.notificationRegisterDataManager = notificationRegisterDataManager
        self.notificationDataManager = notificationReadDataManager
        self.identifyOffline = identifyOffline
    }
    
    func notificationRegister(_ notification: DitoTokenRequest) {
        DispatchQueue.global().async {
            let json = notification.toString
            notificationRegisterDataManager.save(with: json)
        }
    }
    
    func notificationUnregister(_ notification: DitoTokenRequest) {
        DispatchQueue.global().async {
            let json = notification.toString
            notificationUnregisterDataManager.save(with: json)
        }
    }
    
    func notificationRead(_ notification: DitoNotificationOpenRequest) {
        DispatchQueue.global().async {
            let json = notification.toString
            notificationDataManager.save(with: json)
        }
    }
    
    var reference: String? {
        return identifyOffline.getIdentify?.reference
    }
    
    //MARK: - notification Register
    var getNotificationRegister: NotificationRegister? {
        return notificationRegisterDataManager.fetch
    }
    
    func updateRegister(id: NSManagedObjectID, retry: Int16) {
        notificationRegisterDataManager.update(id: id, retry: retry)
    }
    
    func deleteRegister() {
        notificationRegisterDataManager.delete()
    }
    
    //MARK: - notification Unregister
    var getNotificationUnregister: NotificationUnregister? {
        return notificationUnregisterDataManager.fetch
    }
    
    func updateUnregister(id: NSManagedObjectID, retry: Int16) {
        notificationUnregisterDataManager.update(id: id, retry: retry)
    }
    
    func deleteUnregister() {
        notificationUnregisterDataManager.delete()
    }
    
    //MARK: - notification Read
    var getNotificationRead: [NotificationRead] {
        return notificationDataManager.fetchAll
    }
    
    func updateRead(id: NSManagedObjectID, retry: Int16) {
        notificationDataManager.update(id: id, retry: retry)
    }
    
    func deleteRead(id: NSManagedObjectID) {
        notificationDataManager.delete(with: id)
    }
}
