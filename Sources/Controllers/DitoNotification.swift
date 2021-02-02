//
//  DitoNotification.swift
//  DitoSDK
//
//  Created by Rodrigo Damacena Gamarra Maciel on 27/01/21.
//

import Foundation

struct DitoNotification {
    
    private let service: DitoNotificationService
    private let notificationOffline: DitoNotificationOffline
    
    init(service: DitoNotificationService = .init(), trackOffline: DitoNotificationOffline = .init()) {
        self.service = service
        self.notificationOffline = trackOffline
    }
    
    func registerToken(token: String, tokenType: DitoTokenType) {
        
        DispatchQueue.global().async {
            
            let tokenRequest = DitoTokenRequest(platformApiKey: Dito.apiKey, sha1Signature: Dito.signature,
                                                token: token, tokenType: tokenType)
            
            if let reference = notificationOffline.reference, !reference.isEmpty {
                service.register(reference: reference, data: tokenRequest) { (register, error) in
                    
                    if let error = error {
                        notificationOffline.notificationRegister(tokenRequest)
                        DitoLogger.error(error.localizedDescription)
                    } else {
                        DitoLogger.information("Notification - Token registrado")
                    }
                }
                
            } else {
                notificationOffline.notificationRegister(tokenRequest)
                DitoLogger.warning("Register Token - Antes de registrar o token é preciso identificar o usuário.")
            }
        }
    }
    
    func unregisterToken(token: String, tokenType: DitoTokenType) {
        
        DispatchQueue.global().async {
            
            let tokenRequest = DitoTokenRequest(platformApiKey: Dito.apiKey,
                                                sha1Signature: Dito.signature,
                                                token: token, tokenType: tokenType)
            
            if let reference = notificationOffline.reference, !reference.isEmpty {
                service.register(reference: reference, data: tokenRequest) { (register, error) in
                    
                    if let error = error {
                        notificationOffline.notificationUnregister(tokenRequest)
                        DitoLogger.error(error.localizedDescription)
                    } else {
                        DitoLogger.information("Notification - Token cancelado")
                    }
                }
                
            } else {
                notificationOffline.notificationUnregister(tokenRequest)
                DitoLogger.warning("Unregister Token - Antes de cancelar um token é preciso identificar o usuário.")
            }
        }
    }
    
    func notificationRead(identifier: String) {
        
        DispatchQueue.global(qos: .background).async {
            
            if let reference = notificationOffline.reference, !reference.isEmpty, !identifier.isEmpty {
                
                let data = DitoDataNotification(identifier: identifier, reference: reference)
                
                let notificationRequest = DitoNotificationOpenRequest(platformApiKey: Dito.apiKey,
                                                                      sha1Signature: Dito.signature,
                                                                      data: data)
                
                service.read(notificationId: identifier, data: notificationRequest) { (register, error) in
                    
                    if let error = error {
                        notificationOffline.notificationRead(notificationRequest)
                        DitoLogger.error(error.localizedDescription)
                    } else {
                        DitoLogger.information("Notification - Registro do notification push enviado")
                    }
                }
                
            } else {
                DitoLogger.warning("Notification Read - Antes de informar uma notifição lida é preciso identificar o usuário.")
            }
        }
    }
}