//
//  ActionDataManager.swift
//  DitoSDK
//
//  Created by Mateus Rodrigues on 12/01/21.
//

import Foundation
import CoreData

public struct DTTrackDataManager {
    

    public static func save(action: String, reference: String, status:Int, send: Bool) -> Bool {
    
        let context = DTCoreDataManager.shared.persistentContainer.viewContext
        guard let client = NSEntityDescription.insertNewObject(forEntityName: "Track", into: context) as? Track else{
            
            DTLogger.error("Failed to save Track")
            return false

        }
        client.action = action
        client.reference = reference
        client.send = send
        
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
        
        let resultFetch:[Track]
        
        let context = DTCoreDataManager.shared.persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<Track>(entityName: "Track")
        
        do{
            
            resultFetch = try context.fetch(fetchRequest)
            
            DTLogger.information("\(resultFetch.count) Tracks found - Successfully!!!")
            
            return resultFetch
        
        } catch let fetchErr {
            
            DTLogger.error("Error to Track Identify: \(fetchErr.localizedDescription)")
            return []
        }

    }
    
    public static func fetchBySend(send: Bool) -> [Track] {
        
        let context = DTCoreDataManager.shared.persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<Track>(entityName: "Track")
        
        do {
            
            let tracks = try context.fetch(fetchRequest)
            var resultFetch:[Track] = []
            var countFetch:Int = 0
            
            for track in tracks {
                if track.send == send{
                    resultFetch.append(track)
                    countFetch += 1
                }
            }
            
            DTLogger.information("\(countFetch) Tracks found - Successfully!!!")
            
            return resultFetch
        
        } catch let fetchErr {
            
            DTLogger.error("Error to Track Identify: \(fetchErr.localizedDescription)")
            
            return []
        }
    }

    public static func deleteBySend(send: Bool) -> Bool {
        
        let context = DTCoreDataManager.shared.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<Track>(entityName: "Track")
        
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
            
            DTLogger.information("\(countDeletes) Tracks Deleted - Successfully!!!")
            
            return true
        
        } catch let fetchErr {
            
            DTLogger.error("Error to Delete Identify: \(fetchErr.localizedDescription)")
            
            return false
        }
    }
}
