//
//  DitoNotificationUnregisterDataManager.swift
//  DitoSDK
//
//  Created by Rodrigo Damacena Gamarra Maciel on 01/02/21.
//

import Foundation
import CoreData

struct DitoNotificationUnregisterDataManager {
    
    @discardableResult
    func save(with json: String?, retry: Int16 = 1) -> Bool {
        
        guard let context = DitoCoreDataManager.shared.container?.viewContext else { return false }
        delete()
        
        do {
            guard let notificationRead = NSEntityDescription.insertNewObject(forEntityName: "NotificationUnregister", into: context) as? NotificationUnregister
            else {
                DitoLogger.error("Failed to save NotificationUnregister")
                return false
            }
            
            notificationRead.retry = retry
            notificationRead.json = json
            
            try context.save()
            DitoLogger.information("NotificationUnregister Saved Successfully!!!")
            
            return true
            
        } catch let error {
            
            DitoLogger.error("Failed to NotificationUnregister save: \(error.localizedDescription)")
            return false
        }
    }
    
    @discardableResult
    func update(id: NSManagedObjectID, retry: Int16) -> Bool {
        
        guard let context = DitoCoreDataManager.shared.container?.viewContext else { return false }
        let fetchRequest = NSFetchRequest<NotificationUnregister>(entityName: "NotificationUnregister")
        let predicate = NSPredicate(format: "SELF = %@", id)
        fetchRequest.predicate = predicate
        
        do {
            let resultFetch = try context.fetch(fetchRequest).first
            resultFetch?.retry = retry
            
            try context.save()
            
            DitoLogger.information("NotificationUnregister Updated Successfully!!!")
            return true
            
        } catch let error {
            
            DitoLogger.error("Failed to update NotificationUnregister: \(error.localizedDescription)")
            return false
        }
        
    }
    
    var fetch: NotificationUnregister? {
        
        guard let context = DitoCoreDataManager.shared.container?.viewContext else { return nil }
        
        let fetchRequest = NSFetchRequest<NotificationUnregister>(entityName: "NotificationUnregister")
        
        do {
            guard let unregister: NotificationUnregister = try context.fetch(fetchRequest).first else { return nil }
            
            DitoLogger.information("NotificationUnregister found - Successfully!!!")
            
            return unregister
            
        } catch let fetchErr {
            
            DitoLogger.error("Error to NotificationUnregister fetch: \(fetchErr.localizedDescription)")
            return nil
        }
    }
    
    @discardableResult
    func delete() -> Bool {
        
        guard let context = DitoCoreDataManager.shared.container?.viewContext else { return false }
        
        do {
            let fetchRequest = NSFetchRequest<NotificationUnregister>(entityName: "NotificationUnregister")
            fetchRequest.returnsObjectsAsFaults = false
            
            let notificationUnregistes = try context.fetch(fetchRequest)
            for managedObject in notificationUnregistes
            {
                context.delete(managedObject)
            }
            
            try context.save()
            
            DitoLogger.information("NotificationUnregister Deleted - Successfully!!!")
            return true
            
        } catch let fetchErr {
            
            DitoLogger.error("Error to Delete NotificationUnregister: \(fetchErr.localizedDescription)")
            return false
        }
    }
}
