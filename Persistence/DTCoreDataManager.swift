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
        if !UserDefaults.firstSave{
            UserDefaults.firstSave = true
            
            //if model archive is created them returns error
            if validateDataModel("DitoDataModel"){
                
                DTLogger.error("You can not create a data model with name 'DitoDataModel'")
                
                return nil
            }else{
    
                return persistentContainer
            }
        }
        return persistentContainer
    }()
    
    ///Persistent Container to mange Core Data stack
    lazy private var persistentContainer: NSPersistentContainer = {

        let bundle = Bundle(identifier: self.identifier)
        let modelURL = bundle!.url(forResource: self.model, withExtension: "momd")!
 
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
                
                print(paths)
                
                let dataModelPath = paths.map {
                    (path) -> String in
                    
                    return path.hasPrefix("DitoDataModel") ? "nothing" : "have"
                }
            
                if dataModelPath[0] == "nothing" {
                    return false
                }
            
        } catch let err {
            DTLogger.error(err.localizedDescription)
        }
        
        return true
    }
}
