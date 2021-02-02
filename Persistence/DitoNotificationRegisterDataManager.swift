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
        
        guard let context = DitoCoreDataManager.shared.container?.viewContext else { return false }
        delete()
        
        do {
            guard let notificationRead = NSEntityDescription.insertNewObject(forEntityName: "NotificationRegister", into: context) as? NotificationRegister
            else {
                DitoLogger.error("Failed to save NotificationRegister")
                return false
            }
            
            notificationRead.retry = retry
            notificationRead.json = json
            
            try context.save()
            DitoLogger.information("NotificationRegister Saved Successfully!!!")
            
            return true
        } catch let error {
            
            DitoLogger.error("Failed to NotificationRegister save: \(error.localizedDescription)")
            return false
        }
    }
    
    @discardableResult
    func update(id: NSManagedObjectID, retry: Int16) -> Bool {
        
        guard let context = DitoCoreDataManager.shared.container?.viewContext else { return false }
        let fetchRequest = NSFetchRequest<NotificationRegister>(entityName: "NotificationRegister")
        let predicate = NSPredicate(format: "SELF = %@", id)
        fetchRequest.predicate = predicate
        
        do {
            let resultFetch = try context.fetch(fetchRequest).first
            resultFetch?.retry = retry
            
            try context.save()
            
            DitoLogger.information("NotificationRegister Updated Successfully!!!")
            return true
            
        } catch let error {
            
            DitoLogger.error("Failed to update NotificationRegister: \(error.localizedDescription)")
            return false
        }
    }
    
    var fetch: NotificationRegister? {
        
        
        guard let context = DitoCoreDataManager.shared.container?.viewContext else { return nil }
        
        let fetchRequest = NSFetchRequest<NotificationRegister>(entityName: "NotificationRegister")
        
        do {
            guard let register: NotificationRegister = try context.fetch(fetchRequest).first else { return nil }
            
            DitoLogger.information("NotificationRegister found - Successfully!!!")
            
            return register
            
        } catch let fetchErr {
            
            DitoLogger.error("Error to NotificationRegister fetch: \(fetchErr.localizedDescription)")
            return nil
        }
    }
    
    @discardableResult
    func delete() -> Bool {
        
        guard let context = DitoCoreDataManager.shared.container?.viewContext else { return false }
        
        do {
            let fetchRequest = NSFetchRequest<NotificationRegister>(entityName: "NotificationRegister")
            fetchRequest.returnsObjectsAsFaults = false
            
            let notificationRegisters = try context.fetch(fetchRequest)
            for managedObject in notificationRegisters
            {
                context.delete(managedObject)
            }
            
            try context.save()
            
            DitoLogger.information("NotificationRegister Deleted - Successfully!!!")
            return true
            
        } catch let fetchErr {
            
            DitoLogger.error("Error to Delete NotificationRegister: \(fetchErr.localizedDescription)")
            return false
        }
    }
}
