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
    
    @discardableResult
    func saveIdentifyStamp() -> Bool {
        UserDefaults.savingState = NSDate().timeIntervalSince1970
        return true
    }
    
    var fetchSavingState: IdentifySaveStamp? {
        
        let stamp = UserDefaults.savingState
        if stamp == 0 { return nil }
        
        //TODO: Não é necessário converter caso o CoreData seja removido
        let identifyStamp = IdentifySaveStamp()
        identifyStamp.timeStamp = stamp
        return identifyStamp
    }
    
    @discardableResult
    func deleteIdentifyStamp() -> Bool {
        
        UserDefaults.savingState = -1
        return true
    }

    @discardableResult
    func save(id: String, reference: String?, json: String?, send: Bool) -> Bool {
        
        let newIdentify = IdentifyDefaults(id: id, json: json, reference: reference, send: send)
        UserDefaults.identify = newIdentify
        
        //TODO: Alterar para nenhum retorno
        return true
    }
    
    @discardableResult
    func update(id: String, reference: String?, json: String?, send: Bool) -> Bool {
        //TODO: Função update pode ser descartada ao utilizar UserDefaults
        save(id: id, reference: reference, json: json, send: send)
        return true
    }
    
    var fetch: Identify? {
        
        guard let savedIdentify = UserDefaults.identify else {return nil}
        
        //TODO: Não é necessário converter o objeto se substituirmos completamente o CoreData
        var identify = Identify()
        identify.id = savedIdentify.id
        identify.json = savedIdentify.json
        identify.reference = savedIdentify.reference
        identify.send = savedIdentify.send
        
        return identify
    }
    
    @discardableResult
    func delete(id: String) -> Bool {
        
        let checkIdentify = UserDefaults.identify
        if checkIdentify?.id == id {
            UserDefaults.identify = nil
        }
        return true
    }
}
