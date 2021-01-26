//
//  DTNotificationDataManager.swift
//  DitoSDK Tests
//
//  Created by Mateus Rodrigues on 12/01/21.
//

import Foundation
import CoreData

struct DitoNotificationReadDataManager {
    
    @discardableResult
    func save(json: String?, retry: Int16 = 1) -> Bool {
    
        guard let context = DitoCoreDataManager.shared.container?.viewContext else { return false }
        guard let notificationRead = NSEntityDescription.insertNewObject(forEntityName: "NotificationRead", into: context) as? NotificationRead
        else {

            DitoLogger.error("Failed to save Notification")
            return false
        }
        
        do {
            notificationRead.retry = retry
            notificationRead.json = json

            try context.save()
            DitoLogger.information("Notification Saved Successfully!!!")
            
            return true
        } catch let error {
            DitoLogger.error("Failed to Notification save: \(error.localizedDescription)")
            
            return false
        }
    }
    
    @discardableResult
    func update(id: NSManagedObjectID, retry: Int16) -> Bool {
        
        guard let context = DitoCoreDataManager.shared.container?.viewContext else { return false }
        let fetchRequest = NSFetchRequest<NotificationRead>(entityName: "NotificationRead")
        let predicate = NSPredicate(format: "SELF = %@", id)
        fetchRequest.predicate = predicate
        
        do {
            let resultFetch = try context.fetch(fetchRequest).first
            resultFetch?.retry = retry
            
            try context.save()
            
            DitoLogger.information("NotificationRead Updated Successfully!!!")
            return true
            
        } catch let error {
            
            DitoLogger.error("Failed to update NotificationRead: \(error.localizedDescription)")
            return false
        }
         
    }
    
    var fetchAll: [NotificationRead] {
        
        let resultFetch: [NotificationRead]
        
        guard let context = DitoCoreDataManager.shared.container?.viewContext else { return [] }
        
        let fetchRequest = NSFetchRequest<NotificationRead>(entityName: "NotificationRead")
        
        do {
            
            resultFetch = try context.fetch(fetchRequest)
            
            DitoLogger.information("\(resultFetch.count) Notification found - Successfully!!!")
            
            return resultFetch
        
        } catch let fetchErr {
            
            DitoLogger.error("Error to Notification fetch: \(fetchErr.localizedDescription)")
            return []
        }

    }
    
    @discardableResult
    func delete(with id: NSManagedObjectID) -> Bool {
        
        guard let context = DitoCoreDataManager.shared.container?.viewContext else { return false
        }
        let fetchRequest = NSFetchRequest<NotificationRead>(entityName: "NotificationRead")
        let predicate = NSPredicate(format: "SELF = %@", id)
        fetchRequest.predicate = predicate
        
        do {
            
            guard let notificationRead = try context.fetch(fetchRequest).first else { throw DitoErrorType.objectError }
            
            context.delete(notificationRead)
            try context.save()
            
            DitoLogger.information("Notification Deleted - Successfully!!!")
            return true
        
        } catch let fetchErr {
            
            DitoLogger.error("Error to Delete NotificationRead: \(fetchErr.localizedDescription)")
            
            return false
        }
    }
}
