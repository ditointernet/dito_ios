//
//  IdentifyDataManager.swift
//  DitoSDK
//
//  Created by Mateus Rodrigues on 12/01/21.
//

import Foundation
import CoreData


struct DTIdentifyDataManager {
    
    @discardableResult
    func save(id: String, reference: String?, json: String?, send: Bool) -> Bool {
        
        guard let context = DTCoreDataManager.shared.container?.viewContext else { return false }
        delete(id: id)
        
        do {
            guard let identify = NSEntityDescription.insertNewObject(forEntityName: "Identify", into: context) as? Identify
            else {
                DTLogger.error("Failed to save Identify")
                return false
            }
            
            identify.id = id
            identify.reference = reference
            identify.json = json
            identify.send = send
            
            try context.save()
            
            DTLogger.information("Identify Saved Successfully!!!")
            return true
            
        } catch let error {
            
            DTLogger.error("Failed to save Identify: \(error.localizedDescription)")
            return false
        }
    }
    
    @discardableResult
    func update(id: String, reference: String?, json: String?, send: Bool) -> Bool {
        
        guard let context = DTCoreDataManager.shared.container?.viewContext else { return false }
        let fetchRequest = NSFetchRequest<Identify>(entityName: "Identify")
        let predicate = NSPredicate(format: "id = %@", id)
        fetchRequest.predicate = predicate
        
        do {
            let identify = try context.fetch(fetchRequest).first
            identify?.id = id
            identify?.reference = reference
            identify?.json = json
            identify?.send = send
            
            try context.save()
            
            DTLogger.information("Identify Updated Successfully!!!")
            return true
            
        } catch let error {
            
            DTLogger.error("Failed to update Identify: \(error.localizedDescription)")
            return false
        }
    }
    
    var fetch: Identify? {
        
        
        guard let context = DTCoreDataManager.shared.container?.viewContext else { return nil }
        
        let fetchRequest = NSFetchRequest<Identify>(entityName: "Identify")
        
        do {
            
            guard let identify: Identify = try context.fetch(fetchRequest).first else { return nil }
            
            DTLogger.information("Identify Fetch - Successfully!!!")
            
            return identify
        
        } catch let fetchErr {
            
            DTLogger.error("Error to fetch Identify: \(fetchErr.localizedDescription)")
            return nil
        }
    }
    
    @discardableResult
    func delete(id: String) -> Bool {
        
        guard let context = DTCoreDataManager.shared.container?.viewContext else { return false }
        
        let fetchRequest = NSFetchRequest<Identify>(entityName: "Identify")
        let predicate = NSPredicate(format: "id = %@", id)
        fetchRequest.predicate = predicate
        
        do {
            
            guard let identify: Identify = try context.fetch(fetchRequest).first else { return false }
    
            context.delete(identify)
            try context.save()
            
            DTLogger.information("Identify Deleted - Successfully!!!")
            
            return true
        
        } catch let fetchErr {
            
            DTLogger.error("Error to fetch Identify: \(fetchErr.localizedDescription)")
            return false
        }
    }

}
