//
//  IdentifyDataManager.swift
//  DitoSDK
//
//  Created by Mateus Rodrigues on 12/01/21.
//

import Foundation
import CoreData

class DitoIdentifyDataManager {
    
    var identitySaveCallback: (() -> ())? = nil
    
    func setIdentitySaveCallback(_ callback: @escaping () -> Void) {
        self.identitySaveCallback = callback
    }
    
    @discardableResult
    func saveIdentifyStamp() -> Bool {
        
        guard let context = DitoCoreDataManager.shared.container?.viewContext else { return false }
        
        do {
            guard let identifyStamp = NSEntityDescription.insertNewObject(forEntityName: "IdentifySaveStamp", into: context) as? IdentifySaveStamp
            else {
                DitoLogger.error("Failed to save IdentifySaveStamp")
                return false
            }
            
            identifyStamp.timeStamp = NSDate().timeIntervalSince1970
            
            try context.save()
            
            DitoLogger.information("IdentifySaveStamp Saved Successfully!!!")
            return true
        } catch let error {
            
            DitoLogger.error("Failed to save IdentifySaveStamp: \(error.localizedDescription)")
            return false
        }
    }
    
    var fetchSavingState: IdentifySaveStamp? {
        
        guard let context = DitoCoreDataManager.shared.container?.viewContext else { return nil }
        
        let fetchRequest = NSFetchRequest<IdentifySaveStamp>(entityName: "IdentifySaveStamp")
        
        do {
            
            guard let identifyStamp: IdentifySaveStamp = try context.fetch(fetchRequest).last else { return nil }
            
            DitoLogger.information("IdentifyStamp Fetch - Successfully!!!")
            
            return identifyStamp
        
        } catch let fetchErr {
            
            DitoLogger.error("Error to fetch Identify: \(fetchErr.localizedDescription)")
            return  nil
        }
    }
    
    @discardableResult
    func deleteIdentifyStamp() -> Bool {
        
        guard let context = DitoCoreDataManager.shared.container?.viewContext else { return false }
        
        do {
            
            let fetchRequest = NSFetchRequest<IdentifySaveStamp>(entityName: "IdentifySaveStamp")
            let savedStamps: [IdentifySaveStamp] = try context.fetch(fetchRequest)
    
            for stamp in savedStamps {
                context.delete(stamp)
            }
            try context.save()
            if let callback = self.identitySaveCallback {
                callback()
            }
            
            DitoLogger.information("IdentifyStamp Deleted - Successfully!!!")
            return true
            
        } catch let fetchErr {
            
            DitoLogger.error("Error to Delete IdentifyStamp: \(fetchErr.localizedDescription)")
            return false
        }
    }
    
    @discardableResult
    func save(id: String, reference: String?, json: String?, send: Bool) -> Bool {
        
        guard let context = DitoCoreDataManager.shared.container?.viewContext else { return false }
        delete(id: id)
        
        do {
            guard let identify = NSEntityDescription.insertNewObject(forEntityName: "Identify", into: context) as? Identify
            else {
                DitoLogger.error("Failed to save Identify")
                return false
            }
            
            identify.id = id
            identify.reference = reference
            identify.json = json
            identify.send = send
            
            try context.save()
            
            DitoLogger.information("Identify Saved Successfully!!!")
            return true
            
        } catch let error {
            
            DitoLogger.error("Failed to save Identify: \(error.localizedDescription)")
            return false
        }
    }
    
    @discardableResult
    func update(id: String, reference: String?, json: String?, send: Bool) -> Bool {
        
        guard let context = DitoCoreDataManager.shared.container?.viewContext else { return false }
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
            
            DitoLogger.information("Identify Updated Successfully!!!")
            return true
            
        } catch let error {
            
            DitoLogger.error("Failed to update Identify: \(error.localizedDescription)")
            return false
        }
    }
    
    var fetch: Identify? {
        
        guard let context = DitoCoreDataManager.shared.container?.viewContext else { return nil }
        
        let fetchRequest = NSFetchRequest<Identify>(entityName: "Identify")
        
        do {
            
            guard let identify: Identify = try context.fetch(fetchRequest).last else { return nil }
            
            DitoLogger.information("Identify Fetch - Successfully!!!")
            
            return identify
        
        } catch let fetchErr {
            
            DitoLogger.error("Error to fetch Identify: \(fetchErr.localizedDescription)")
            return nil
        }
    }
    
    @discardableResult
    func delete(id: String) -> Bool {
        
        guard let context = DitoCoreDataManager.shared.container?.viewContext else { return false }
        
        let fetchRequest = NSFetchRequest<Identify>(entityName: "Identify")
        let predicate = NSPredicate(format: "id = %@", id)
        fetchRequest.predicate = predicate
        
        do {
            
            guard let identify: Identify = try context.fetch(fetchRequest).first else { return false }
    
            context.delete(identify)
            try context.save()
            
            DitoLogger.information("Identify Deleted - Successfully!!!")
            
            return true
        
        } catch let fetchErr {
            
            DitoLogger.error("Error to fetch Identify: \(fetchErr.localizedDescription)")
            return false
        }
    }

}
