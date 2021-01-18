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
    private let identifier: String = "br.com.dito.sdk.swift.DitoSDK"
    
    ///Model name
    private let model: String = "DitoDataModel"
    
    
    ///Persistent Container to mange Core Data stack
    lazy var container: NSPersistentContainer? = {
        
        //Validate if model archive is create before first save
        if !UserDefaults.firstSave {
            
            //if model archive is created them returns error
            if validateDataModel("DitoDataModel") {
                
                DTLogger.error("You can not create a data model with name 'DitoDataModel'")
                return nil
            }
            
            UserDefaults.firstSave = true
            return persistentContainer
        }
        return persistentContainer
    }()
    
    
    ///Persistent Container to mange Core Data stack
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

extension DTCoreDataManager{
    
    private func validateDataModel(_ modelName: String) -> Bool {
        do {
            
            let path = FileManager
                .default
                .urls(for: .applicationSupportDirectory, in: .userDomainMask)
                .last?
                .absoluteString
                .replacingOccurrences(of: "file://", with: "")
                .removingPercentEncoding
            
            
            let paths = try FileManager.default.contentsOfDirectory(atPath: path ?? " ")
            
            let dataModelPath = paths.map {
                (path) -> String in
                
                return path.hasPrefix("DitoDataModel") ? "nothing" : "have"
            }
            
            return dataModelPath[0] == "have"
            
        } catch let err {
            DTLogger.error(err.localizedDescription)
            return false
        }
    }
}
