//
//  DTNotificationDataManager.swift
//  DitoSDK Tests
//
//  Created by Mateus Rodrigues on 12/01/21.
//

import Foundation
import CoreData

struct DitoNotificationReadDataManager {
    
    static func save(reference: String, send: Bool, json:Data) -> Bool {
    
        guard let context = DitoCoreDataManager.shared.container?.viewContext else { return false }
        guard let client = NSEntityDescription.insertNewObject(forEntityName: "NotificationRead", into: context) as? NotificationRead
        else {

            DitoLogger.error("Failed to save Notification")
            return false
        }
        client.reference = reference
        client.send = send
        client.json = json
    
        
        do {
            try context.save()
            DitoLogger.information("Notification Saved Successfully!!!")
            
            return true
        } catch let error {
            DitoLogger.error("Failed to Notification save: \(error.localizedDescription)")
            
            return false
        }
    }
    
    static func fetch() -> [NotificationRead] {
        
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
    
    static func fetchBySend(send: Bool) -> [NotificationRead] {
        
        var resultFetch: [NotificationRead] = []
        
        guard let context = DitoCoreDataManager.shared.container?.viewContext else { return [] }
        
        let fetchRequest = NSFetchRequest<NotificationRead>(entityName: "NotificationRead")
        
        do {
            
            let notifications = try context.fetch(fetchRequest)
            var countFetch:Int = 0
            
            for notification in notifications{
                if notification.send == send{
                    resultFetch.append(notification)
                    countFetch += 1
                }
            }
            
            DitoLogger.information("\(countFetch) Notification found - Successfully!!!")
            
            return resultFetch
        
        } catch let fetchErr {
            
            DitoLogger.error("Error to Delete Identify: \(fetchErr.localizedDescription)")
            return []
        }
    }
    
    static func deleteBySend(send: Bool) -> Bool {
        
        guard let context = DitoCoreDataManager.shared.container?.viewContext else { return false }
        
        let fetchRequest = NSFetchRequest<NotificationRead>(entityName: "NotificationRead")
        
        do {
            
            let tracks = try context.fetch(fetchRequest)
            var countDeletes:Int = 0
            
            for track in tracks {
                if track.send == send {
                    context.delete(track)
                    countDeletes += 1
                }
            }
            
            try context.save()
            
            DitoLogger.information("\(countDeletes) Notification Deleted - Successfully!!!")
            
            return true
        
        } catch let fetchErr {
            
            DitoLogger.error("Error to Delete Identify: \(fetchErr.localizedDescription)")
            
            return false
        }
    }
}
