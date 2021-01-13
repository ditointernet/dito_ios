//
//  CoreDataManager.swift
//  DitoSDK
//
//  Created by Mateus Rodrigues on 12/01/21.
//

import Foundation
import CoreData

public class DTCoreDataManager {
   
    ///Singlenton of its class
    public static let shared = DTCoreDataManager()
    
    ///Your framework bundle ID
    let identifier: String = "br.com.dito.sdk.swift.DitoSDK"
    
    ///Model name
    let model: String = "dataModel"
    
    lazy var persistentContainer: NSPersistentContainer = {
        
        let messageKitBundle = Bundle(identifier: self.identifier)
        let modelURL = messageKitBundle!.url(forResource: self.model, withExtension: "momd")!
        
        let managedObjectModel =  NSManagedObjectModel(contentsOf: modelURL)
        
        let container = NSPersistentContainer(name: self.model, managedObjectModel: managedObjectModel!)
        container.loadPersistentStores { (storeDescription, error) in
            
            if let err = error{
                DTLogger.error(err.localizedDescription)
            }
        }
        
        return container
    }()
    
    
    
    
}
