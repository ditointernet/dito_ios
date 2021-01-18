//
//  ActionDataManager.swift
//  DitoSDK
//
//  Created by Mateus Rodrigues on 12/01/21.
//

import Foundation
import CoreData

public struct DTTrackDataManager {
    

    public static func save(event: String, retry: Int16) -> Bool {

        guard let context = DTCoreDataManager.shared.container?.viewContext else { return false }
        guard let client = NSEntityDescription.insertNewObject(forEntityName: "Track", into: context) as? Track
        else {
            DTLogger.error("Failed to save Track")
            return false
        }
        
        client.event = event
        client.retry = retry
        
        do {
            try context.save()
            DTLogger.information("Track Saved Successfully!!!")
            
            return true
        } catch let error {
            DTLogger.error("Failed to save Track: \(error.localizedDescription)")
            
            return false
        }
    }
    
    public static func fetch() -> [Track] {
        
        let resultFetch: [Track]
        
        guard let context = DTCoreDataManager.shared.container?.viewContext else { return [] }
        
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

    public static func deleteBySend(send: Bool) -> Bool {
        
        guard let context = DTCoreDataManager.shared.container?.viewContext else { return false }
        let fetchRequest = NSFetchRequest<Track>(entityName: "Track")
        
        do {
            
            let tracks = try context.fetch(fetchRequest)
            
            for track in tracks {
                context.delete(track)
            }
            
            try context.save()
            
            DTLogger.information("Tracks Deleted - Successfully!!!")
            
            return true
        
        } catch let fetchErr {
            
            DTLogger.error("Error to Delete Identify: \(fetchErr.localizedDescription)")
            
            return false
        }
    }
}
