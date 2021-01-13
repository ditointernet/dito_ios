//
//  IdentifyDataManager.swift
//  DitoSDK
//
//  Created by Mateus Rodrigues on 12/01/21.
//

import Foundation
import CoreData


struct DTIdentifyDataManager {
    
    ///Singlenton of its class
    public static let shared = DTIdentifyDataManager()
    
    func save(id:Int, reference: String, signedRequest: String) -> Bool{
        
        let context = DTCoreDataManager.shared.persistentContainer.viewContext
        let client = NSEntityDescription.insertNewObject(forEntityName: "Identify", into: context) as! Identify
        client.id = Int16(id)
        client.reference = reference
        client.signedRequest = signedRequest
        
        
        do {
            try context.save()
            DTLogger.information("Identify Saved Successfully!!!")
            
            return true
        } catch let error {
            DTLogger.error("Failed to save Identify: \(error.localizedDescription)")
            
            return false
        }
    }
    
    func fetch() -> Identify? {
        
        let resultFetch:[Identify]
        
        let context = DTCoreDataManager.shared.persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<Identify>(entityName: "Identify")
        
        do{
            
            resultFetch = try context.fetch(fetchRequest)
            
            guard let identify = resultFetch.first else{ return nil }
            
            DTLogger.information("Identify Fetch Successfully!!!")
            
            return identify
        
        }catch let fetchErr {
            
            DTLogger.error("Error to fetch Identify: \(fetchErr.localizedDescription)")
        }
    
        return nil
    }

}
