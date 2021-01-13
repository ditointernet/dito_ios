//
//  ActionDataManager.swift
//  DitoSDK
//
//  Created by Mateus Rodrigues on 12/01/21.
//

import Foundation
import CoreData

struct DTTrackDataManager {
    
    ///Singlenton of its class
    public static let shared = DTTrackDataManager()
    
    func save(action: String, reference: String, status:Int, send: Bool) -> Bool{
    
        let context = DTCoreDataManager.shared.persistentContainer.viewContext
        let client = NSEntityDescription.insertNewObject(forEntityName: "Track", into: context) as! Track
        client.action = action
        client.reference = reference
        client.status = Int16(status)
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
    
    func fetch() -> [Track] {
        
        let resultFetch:[Track]
        
        let context = DTCoreDataManager.shared.persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<Track>(entityName: "Track")
        
        do{
            
            resultFetch = try context.fetch(fetchRequest)
            
            DTLogger.information("Track Fetch Successfully!!!")
            
            return resultFetch
        
        }catch let fetchErr {
            
            DTLogger.error("Error to Track Identify: \(fetchErr.localizedDescription)")
        }
    
        return []
    }
    
    func fetchBySend(send: Bool) -> [Track] {
        
        let context = DTCoreDataManager.shared.persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<Track>(entityName: "Track")
        
        do{
            
            let tracks = try context.fetch(fetchRequest)
            var resultFetch:[Track] = []
            
            for track in tracks{
                if track.send == send{
                    resultFetch.append(track)
                }
            }
            
            DTLogger.information("Track Fetch Successfully!!!")
            
            return resultFetch
        
        }catch let fetchErr {
            
            DTLogger.error("Error to Track Identify: \(fetchErr.localizedDescription)")
        }
    
        return []
    }

}
