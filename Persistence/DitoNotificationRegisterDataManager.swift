//
//  DitoNotificationRegisterDataManager.swift
//  DitoSDK
//
//  Created by Rodrigo Damacena Gamarra Maciel on 01/02/21.
//

import Foundation
import CoreData

struct DitoNotificationRegisterDataManager {
    
    @discardableResult
    func save(with json: String?, retry: Int16 = 1) -> Bool {
        
        let newNotificationRegister = NotificationDefaults(retry: retry, json: json)
        UserDefaults.notificationRegister = newNotificationRegister
        
        //TODO: Alterar para nenhum retorno
        return true
    }
    
    @discardableResult
    func update(id: NSManagedObjectID? = nil, retry: Int16) -> Bool {
        save(with: nil, retry: retry)
    }
    
    var fetch: NotificationDefaults? {
        
        guard let notificationRegisterSaved = UserDefaults.notificationRegister else {return nil}
//        
//        var notificationObject = NotificationRegister()
//        
//        notificationObject.json = notificationRegisterSaved.json
//        notificationObject.retry = notificationRegisterSaved.retry
        
        return notificationRegisterSaved
    }
    
    @discardableResult
    func delete() -> Bool {
        
        UserDefaults.notificationRegister = nil
        
        //TODO: Alterar para nenhum retorno
        return true
    }
}
