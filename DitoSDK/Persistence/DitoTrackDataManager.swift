//
//  ActionDataManager.swift
//  DitoSDK
//
//  Created by Mateus Rodrigues on 12/01/21.
//

import Foundation
import CoreData

struct DitoTrackDataManager {
    
    @discardableResult
    func save(event: String?, retry: Int16 = 1) -> Bool {

        guard let context = DitoCoreDataManager.shared.container?.viewContext else { return false }
        guard let track = NSEntityDescription.insertNewObject(forEntityName: "Track", into: context) as? Track
        else {
            DitoLogger.error("Failed to save Track")
            return false
        }
        
        do {
            track.event = event
            track.retry = retry
        
            try context.save()
            DitoLogger.information("Track Saved Successfully!!!")
            
            return true
        } catch let error {
            DitoLogger.error("Failed to save Track: \(error.localizedDescription)")
            
            return false
        }
    }
    
    @discardableResult
    func update(id: NSManagedObjectID, event: String?, retry: Int16) -> Bool {
        
        guard let context = DitoCoreDataManager.shared.container?.viewContext else { return false }
        let fetchRequest = NSFetchRequest<Track>(entityName: "Track")
        let predicate = NSPredicate(format: "SELF = %@", id)
        fetchRequest.predicate = predicate
        
        do {
            let resultFetch = try context.fetch(fetchRequest).first
            resultFetch?.event = event
            resultFetch?.retry = retry
            
            try context.save()
            
            DitoLogger.information("Track Updated Successfully!!!")
            return true
            
        } catch let error {
            
            DitoLogger.error("Failed to update Track: \(error.localizedDescription)")
            return false
        }
         
    }
    
    var fetchAll: [Track] {
        
        let resultFetch: [Track]
        
        guard let context = DitoCoreDataManager.shared.container?.viewContext else {
            return []
        }
        
        let fetchRequest = NSFetchRequest<Track>(entityName: "Track")
        
        do {
            
            resultFetch = try context.fetch(fetchRequest)
            
            DitoLogger.information("\(resultFetch.count) Tracks found - Successfully!!!")
            
            return resultFetch
        
        } catch let fetchErr {
            
            DitoLogger.error("Error to Track Identify: \(fetchErr.localizedDescription)")
            return []
        }

    }

    @discardableResult
    func delete(with id: NSManagedObjectID) -> Bool {
        
        guard let context = DitoCoreDataManager.shared.container?.viewContext else { return false }
        let fetchRequest = NSFetchRequest<Track>(entityName: "Track")
        let predicate = NSPredicate(format: "SELF = %@", id)
        fetchRequest.predicate = predicate
        
        do {
            
            guard let track = try context.fetch(fetchRequest).first else { throw DitoErrorType.objectError }
            
            context.delete(track)
            try context.save()
            
            DitoLogger.information("Track Deleted - Successfully!!!")
            return true
        
        } catch let fetchErr {
            
            DitoLogger.error("Error to Delete Track: \(fetchErr.localizedDescription)")
            
            return false
        }
    }
}
