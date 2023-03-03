//
//  DTIdentifyOffline.swift
//  DitoSDK
//
//  Created by Rodrigo Damacena Gamarra Maciel on 13/01/21.
//

import Foundation


struct DitoIdentifyOffline {
    
    private var identifyDataManager: DitoIdentifyDataManager
    
    init(identifyDataManager: DitoIdentifyDataManager = .init()) {
        self.identifyDataManager = identifyDataManager
    }
    
    func initiateIdentify() {
        self.identifyDataManager.saveIdentifyStamp()
    }
    
    func finishIdentify() {
        self.identifyDataManager.deleteIdentifyStamp()
    }
    
    func setIdentityCompletionClosure(_ closure: @escaping () -> Void) {
        self.identifyDataManager.identitySaveCallback = closure
    }
    
    func getIdentifyCompletionClosure() -> (() -> Void)? {
        return self.identifyDataManager.identitySaveCallback
    }
    
    func identify(id: String, params: DitoSignupRequest, reference: String?, send: Bool) {
        let json = params.toString
        self.identifyDataManager.save(id: id, reference: reference, json: json, send: send)
    }
     
    var getSavingState: Bool {
        guard let savingState = identifyDataManager.fetchSavingState else {return false}
        
        let savingStamp = NSDate(timeIntervalSince1970: savingState)
        if savingStamp.timeIntervalSinceNow.isLess(than: -60.0) {
            identifyDataManager.deleteIdentifyStamp()
            return false
        }
        return true
    }
    
    var getIdentify: IdentifyDefaults? {
        return identifyDataManager.fetch
    }
    
    func update(id: String, params: DitoSignupRequest, reference: String?, send: Bool) {
        let json = params.toString
        identifyDataManager.update(id: id, reference: reference, json: json, send: send)
    }
}
