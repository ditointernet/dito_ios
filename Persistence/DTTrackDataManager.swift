//
//  ActionDataManager.swift
//  DitoSDK
//
//  Created by Mateus Rodrigues on 12/01/21.
//

import Foundation
import CoreData

struct DTTrackDataManager {
    
    @discardableResult
    func save(event: String?, retry: Int16) -> Bool {

        guard let context = DTCoreDataManager.shared.container?.viewContext else { return false }
        guard let track = NSEntityDescription.insertNewObject(forEntityName: "Track", into: context) as? Track
        else {
            DTLogger.error("Failed to save Track")
            return false
        }
        
        track.event = event
        track.retry = retry
        
        do {
            try context.save()
            DTLogger.information("Track Saved Successfully!!!")
            
            return true
        } catch let error {
            DTLogger.error("Failed to save Track: \(error.localizedDescription)")
            
            return false
        }
    }
    
    @discardableResult
    func update(id: NSManagedObjectID, event: String?, retry: Int16) -> Bool {
        
        guard let context = DTCoreDataManager.shared.container?.viewContext else { return false }
        let fetchRequest = NSFetchRequest<Track>(entityName: "Track")
        let predicate = NSPredicate(format: "SELF = %@", id)
        fetchRequest.predicate = predicate
        
        do {
            let resultFetch = try context.fetch(fetchRequest).first
            resultFetch?.event = event
            resultFetch?.retry = retry
            
            try context.save()
            
            DTLogger.information("Track Updated Successfully!!!")
            return true
            
        } catch let error {
            
            DTLogger.error("Failed to update Track: \(error.localizedDescription)")
            return false
        }
         
    }
    
    var fetchAll: [Track] {
        
        let resultFetch: [Track]
        
        guard let context = DTCoreDataManager.shared.container?.viewContext else { return []
        }
        
        let fetchRequest = NSFetchRequest<Track>(entityName: "Track")
        
        do {
            
            resultFetch = try context.fetch(fetchRequest)
            
            DTLogger.information("\(resultFetch.count) Tracks found - Successfully!!!")
            
            return resultFetch
        
        } catch let fetchErr {
            
            DTLogger.error("Error to Track Identify: \(fetchErr.localizedDescription)")
            return []
        }

    }

    @discardableResult
    func delete(with id: NSManagedObjectID) -> Bool {
        
        guard let context = DTCoreDataManager.shared.container?.viewContext else { return false }
        let fetchRequest = NSFetchRequest<Track>(entityName: "Track")
        let predicate = NSPredicate(format: "SELF = %@", id)
        fetchRequest.predicate = predicate
        
        do {
            
            guard let track = try context.fetch(fetchRequest).first else { throw DTErrorType.objectError }
            
            context.delete(track)
            try context.save()
            
            DTLogger.information("Track Deleted - Successfully!!!")
            return true
        
        } catch let fetchErr {
            
            DTLogger.error("Error to Delete Track: \(fetchErr.localizedDescription)")
            
            return false
        }
    }
}
