//
//  IdentifyDataManager.swift
//  DitoSDK
//
//  Created by Mateus Rodrigues on 12/01/21.
//

import Foundation
import CoreData


public struct DTIdentifyDataManager {
    
    
    public static func save(id:String, reference: String,json: String, send: Bool) -> Bool {
        
        guard let context = DTCoreDataManager.shared.container?.viewContext else { return false }
        let fetchRequest = NSFetchRequest<Identify>(entityName: "Identify")
        
        do {

            if try context.fetch(fetchRequest).count == 0 {
                
                guard let client = NSEntityDescription.insertNewObject(forEntityName: "Identify", into: context) as? Identify
                else{
                    
                    DTLogger.error("Failed to save Identify")
                    return false
        
                }
                
                client.id = id
                client.json = json
                client.reference = reference
                client.send = send
                
                
                
                try context.save()
                
                DTLogger.information("Identify Saved Successfully!!!")
                
                return true
            } else {

                DTLogger.error("An identify record already exists!!!")

                return false
            }

            
        } catch let error {
            DTLogger.error("Failed to save Identify: \(error.localizedDescription)")
            
            return false
        }
    }
    
    public static func fetch() -> Identify? {
        
        let resultFetch:[Identify]
        
        guard let context = DTCoreDataManager.shared.container?.viewContext else { return nil }
        
        let fetchRequest = NSFetchRequest<Identify>(entityName: "Identify")
        
        do {
            
            resultFetch = try context.fetch(fetchRequest)
            
            guard let identify = resultFetch.first else{ return nil }
            
            DTLogger.information("\(resultFetch.count) Identify Fetch - Successfully!!!")
            
            return identify
        
        } catch let fetchErr {
            
            DTLogger.error("Error to fetch Identify: \(fetchErr.localizedDescription)")
            
            return nil
        }
    }
    
    
    public static func delete() -> Bool {
        
        guard let context = DTCoreDataManager.shared.container?.viewContext else { return false }
        
        let fetchRequest = NSFetchRequest<Identify>(entityName: "Identify")
        
        do {
            
            let resultFetch = try context.fetch(fetchRequest)
            
            var countDelete:Int = 0
            
            for identify in resultFetch{
                context.delete(identify)
               
                countDelete = countDelete + 1
            }
            
            try context.save()
            
            DTLogger.information("\(countDelete) Identify Deleted - Successfully!!!")
            
            return true
        
        } catch let fetchErr {
            
            DTLogger.error("Error to fetch Identify: \(fetchErr.localizedDescription)")
            
            return false
        }
    }

}
