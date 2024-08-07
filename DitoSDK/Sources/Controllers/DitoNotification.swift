//
//  DitoNotification.swift
//  DitoSDK
//
//  Created by Rodrigo Damacena Gamarra Maciel on 27/01/21.
//

import Foundation

class DitoNotification {
    
    private let service: DitoNotificationService
    private let notificationOffline: DitoNotificationOffline
    
    init(service: DitoNotificationService = .init(), trackOffline: DitoNotificationOffline = .init()) {
        self.service = service
        self.notificationOffline = trackOffline
    }
    
    func registerToken(token: String, tokenType: DitoTokenType) {
        
        self.finishRegisterToken(token: token, tokenType: tokenType)
        //TODO: Analisar remoção do valor salvo
        
        /*
         if self.notificationOffline.isSaving {
         self.notificationOffline.setRegisterAsCompletion {
         self.finishRegisterToken(token: token, tokenType: tokenType)
         }
         } else {
         self.finishRegisterToken(token: token, tokenType: tokenType)
         }
         */
    }
    
    func finishRegisterToken(token: String, tokenType: DitoTokenType) {
        
        DispatchQueue.global().async {
            
            let tokenRequest = DitoTokenRequest(platformApiKey: Dito.apiKey, sha1Signature: Dito.signature, token: token, tokenType: tokenType)
            
            if let reference = self.notificationOffline.reference, !reference.isEmpty {
                
                self.service.register(reference: reference, data: tokenRequest) { (register, error) in
                    
                    if let error = error {
                        self.notificationOffline.notificationRegister(tokenRequest)
                        DitoLogger.error(error.localizedDescription)
                    } else {
                        DitoLogger.information("Notification - Token registrado")
                    }
                }
                
            } else {
                
                self.notificationOffline.notificationRegister(tokenRequest)
                DitoLogger.warning("Register Token - Antes de registrar o token é preciso identificar o usuário.")
            }
        }
    }
    
    func unregisterToken(token: String, tokenType: DitoTokenType) {
        
        DispatchQueue.global().async {
            
            let tokenRequest = DitoTokenRequest(platformApiKey: Dito.apiKey,
                                                sha1Signature: Dito.signature,
                                                token: token, tokenType: tokenType)
            
            if let reference = self.notificationOffline.reference, !reference.isEmpty {
                self.service.unregister(reference: reference, data: tokenRequest) { (register, error) in
                    
                    if let error = error {
                        self.notificationOffline.notificationUnregister(tokenRequest)
                        DitoLogger.error(error.localizedDescription)
                    } else {
                        DitoLogger.information("Notification - Token cancelado")
                    }
                }
                
            } else {
                self.notificationOffline.notificationUnregister(tokenRequest)
                DitoLogger.warning("Unregister Token - Antes de cancelar um token é preciso identificar o usuário.")
            }
        }
    }
    
    func notificationRead(notificationId: String, reference: String, identifier: String) {
        
        DispatchQueue.global(qos: .background).async {
            let data = DitoDataNotification(identifier: identifier, reference: reference)
            
            let notificationRequest = DitoNotificationOpenRequest(platformApiKey: Dito.apiKey,
                                                                  sha1Signature: Dito.signature,
                                                                  data: data)
            
            if(notificationId != ""){
            
                self.service.read(notificationId: notificationId, data: notificationRequest) { (register, error) in
                    
                    if let error = error {
                        self.notificationOffline.notificationRead(notificationRequest)
                        DitoLogger.error(error.localizedDescription)
                    } else {
                        DitoLogger.information("Notification - Registro do notification push enviado")
                    }
                }
           }
        }
    }
}
