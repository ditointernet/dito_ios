//
//  DTNotificationDataManager.swift
//  DitoSDK Tests
//
//  Created by Mateus Rodrigues on 12/01/21.
//

import Foundation
import CoreData

public struct DTNotificationReadDataManager {
    
    public static func save(reference: String,send: Bool,json:Data) -> Bool{
    
        let context = DTCoreDataManager.shared.persistentContainer.viewContext
        let client = NSEntityDescription.insertNewObject(forEntityName: "NotificationRead", into: context) as! NotificationRead
        client.reference = reference
        client.send = send
        client.json = json
    
        
        do {
            try context.save()
            DTLogger.information("Notification Saved Successfully!!!")
            
            return true
        } catch let error {
            DTLogger.error("Failed to Notification save: \(error.localizedDescription)")
            
            return false
        }
    }
    
    public static func fetch() -> [NotificationRead] {
        
        let resultFetch:[NotificationRead]
        
        let context = DTCoreDataManager.shared.persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<NotificationRead>(entityName: "NotificationRead")
        
        do{
            
            resultFetch = try context.fetch(fetchRequest)
            
            DTLogger.information("\(resultFetch.count) Notification found - Successfully!!!")
            
            return resultFetch
        
        }catch let fetchErr {
            
            DTLogger.error("Error to Notification fetch: \(fetchErr.localizedDescription)")
            
            return []
        }

    }
    
    public static func fetchBySend(send: Bool) -> [NotificationRead] {
        
        var resultFetch:[NotificationRead] = []
        
        let context = DTCoreDataManager.shared.persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<NotificationRead>(entityName: "NotificationRead")
        
        do{
            
            let notifications = try context.fetch(fetchRequest)
            var countFetch:Int = 0
            
            for notification in notifications{
                if notification.send == send{
                    resultFetch.append(notification)
                    countFetch += 1
                }
            }
            
            DTLogger.information("\(countFetch) Notification found - Successfully!!!")
            
            return resultFetch
        
        }catch let fetchErr {
            
            DTLogger.error("Error to Delete Identify: \(fetchErr.localizedDescription)")
            
            return []
        }

    }
    
    public static func deleteBySend(send: Bool) -> Bool {
        
        let context = DTCoreDataManager.shared.persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<NotificationRead>(entityName: "NotificationRead")
        
        do{
            
            let tracks = try context.fetch(fetchRequest)
            var countDeletes:Int = 0
            
            for track in tracks{
                if track.send == send{
                    context.delete(track)
                    countDeletes += 1
                }
            }
            
            try context.save()
            
            DTLogger.information("\(countDeletes) Notification Deleted - Successfully!!!")
            
            return true
        
        }catch let fetchErr {
            
            DTLogger.error("Error to Delete Identify: \(fetchErr.localizedDescription)")
            
            return false
        }
    }
}
