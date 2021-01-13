//
//  DTNotificationDataManager.swift
//  DitoSDK Tests
//
//  Created by Mateus Rodrigues on 12/01/21.
//

import Foundation
import CoreData

struct DTNotificationReadDataManager {
    
    ///Singlenton of its class
    public static let shared = DTNotificationReadDataManager()
    
    func save(reference: String,send: Bool,json:Data) -> Bool{
    
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
    
    func fetch() -> [NotificationRead] {
        
        let resultFetch:[NotificationRead]
        
        let context = DTCoreDataManager.shared.persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<NotificationRead>(entityName: "NotificationRead")
        
        do{
            
            resultFetch = try context.fetch(fetchRequest)
            
            DTLogger.information("Notification Fetch Successfully!!!")
            
            return resultFetch
        
        }catch let fetchErr {
            
            DTLogger.error("Error to Notification fetch: \(fetchErr.localizedDescription)")
        }
    
        return []
    }
}
