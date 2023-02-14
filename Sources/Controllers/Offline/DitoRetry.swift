//
//  DTRetry.swift
//  DitoSDK
//
//  Created by Rodrigo Damacena Gamarra Maciel on 14/01/21.
//

import Foundation


class DitoRetry {
    
    private var identifyOffline: DitoIdentifyOffline
    private var trackOffline: DitoTrackOffline
    private var notificationReadOffline: DitoNotificationOffline
    private let serviceIdentify: DitoIdentifyService
    private let serviceTrack: DitoTrackService
    private let serviceNotification: DitoNotificationService
    
    init(identifyOffline: DitoIdentifyOffline = .init(), trackOffline: DitoTrackOffline = .init(),
         notificationOffline: DitoNotificationOffline = .init(), serviceNotification: DitoNotificationService = .init(),
         serviceIdentify: DitoIdentifyService = .init(), serviceTrack: DitoTrackService = .init()) {
        
        self.identifyOffline = identifyOffline
        self.trackOffline = trackOffline
        self.notificationReadOffline = notificationOffline
        self.serviceIdentify = serviceIdentify
        self.serviceTrack = serviceTrack
        self.serviceNotification = serviceNotification
    }
    
    func loadOffline() {
        checkIdentify() { [weak self] finish in
            guard let self = self else { return }
            if finish {
                self.checkTrack()
                self.checkNotification()
                self.checkNotificationRegister()
                self.checkNotificationUnregister()
            }
        }
    }
    
    private func checkIdentify(completion: @escaping (_ executed: Bool)->()) {
        DispatchQueue.global().async {
            
            guard let identify = self.identifyOffline.getIdentify,
                  let id = identify.id,
                  let signupRequest = identify.json?.convertToObject(type: DitoSignupRequest.self) else { return }
            
            if !identify.send {
                
                self.serviceIdentify.signup(network: "portal", id: id, data: signupRequest) { [weak self] (identify, error) in
                    
                    guard let self = self else { return }
                    if let error = error {
                        DitoLogger.error(error.localizedDescription)
                        completion(false)
                    } else {
                        if let reference = identify?.reference {
                            self.identifyOffline.update(id: id, params: signupRequest, reference: reference, send: true)
                            DitoLogger.information("Identify realizado")
                            completion(true)
                        }
                    }
                }
            } else {
                completion(true)
            }
        }
    }
    
    private func checkTrack() {
        DispatchQueue.global(qos: .background).async {
            
            let tracks = self.trackOffline.getTrack
            
            tracks.forEach { track in
                self.sendEvent(track: track)
            }
        }
    }
    
    private func sendEvent(track: Track) {
        
        guard let event = track.event, let eventRequest = event.convertToObject(type: DitoEventRequest.self) else { return }
        let id = track.objectID
        
        if let reference = trackOffline.reference, !reference.isEmpty {
            serviceTrack.event(reference: reference, data: eventRequest) { [weak self] (_, error) in
                
                guard let self = self else { return }
                if let error = error {
                    self.trackOffline.update(id: id, event: eventRequest, retry: track.retry + 1)
                    DitoLogger.error(error.localizedDescription)
                } else {
                    self.trackOffline.delete(id: id)
                    DitoLogger.information("Track - Evento enviado")
                }
            }
        } else {
            trackOffline.update(id: id, event: eventRequest, retry: track.retry + 1)
            DitoLogger.warning("Track - Antes de enviar um evento é preciso identificar o usuário.")
        }
    }
    
    private func checkNotification() {
        DispatchQueue.global(qos: .background).async {
            
            let notifications = self.notificationReadOffline.getNotificationRead
            notifications.forEach { notification in
                self.sendNotificationRead(notification)
            }
        }
    }
    
    private func sendNotificationRead(_ notification: NotificationRead) {
        
        guard let notificationRead = notification.json,
              let notificationRequest = notificationRead.convertToObject(type: DitoNotificationOpenRequest.self) else {
                return
        }
        
        if let reference = notificationReadOffline.reference, !reference.isEmpty, !notificationRequest.data.identifier.isEmpty {
            
            serviceNotification.read(notificationId: notificationRequest.data.identifier, data: notificationRequest) { (register, error) in
                
                if let error = error {
                    self.notificationReadOffline.updateRead(id: notification.objectID, retry: notification.retry + 1)
                    DitoLogger.error(error.localizedDescription)
                } else {
                    self.notificationReadOffline.deleteRead(id: notification.objectID)
                    DitoLogger.information("Notification Read - Deletado")
                }
            }
            
        } else {
            DitoLogger.warning("Notification Read - Antes de informar uma notifição lida é preciso identificar o usuário.")
        }
    }
    
    private func checkNotificationRegister() {
        DispatchQueue.global(qos: .background).async {
            
            if let reference = self.notificationReadOffline.reference, !reference.isEmpty {
                
                
                guard let notificationRegister = self.notificationReadOffline.getNotificationRegister,
                      let registerJson = notificationRegister.json,
                      let registerRequest = registerJson.convertToObject(type: DitoTokenRequest.self),
                      let tokenType = DitoTokenType(rawValue: registerRequest.tokenType) else {
                        return
                }
                
                let tokenRequest = DitoTokenRequest(platformApiKey: registerRequest.platformApiKey,
                                                    sha1Signature: registerRequest.sha1Signature,
                                                    token: registerRequest.token, tokenType: tokenType)
                
                self.serviceNotification.register(reference: reference, data: tokenRequest) { [weak self] (register, error) in
                    
                    guard let self = self else { return }
                    if let error = error {
                        self.notificationReadOffline.updateRegister(id: nil, retry: notificationRegister.retry + 1)
                        DitoLogger.error(error.localizedDescription)
                    } else {
                        self.notificationReadOffline.deleteRegister()
                        DitoLogger.information("Notification - Token registrado")
                    }
                }
    
            } else {
                DitoLogger.warning("Register Token - Antes de registrar o token é preciso identificar o usuário.")
            }
        }
    }
    
    private func checkNotificationUnregister() {
        DispatchQueue.global(qos: .background).async {
            
            if let reference = self.notificationReadOffline.reference, !reference.isEmpty {
                
                
                guard let notificationRegister = self.notificationReadOffline.getNotificationUnregister,
                      let registerJson = notificationRegister.json,
                      let registerRequest = registerJson.convertToObject(type: DitoTokenRequest.self),
                      let tokenType = DitoTokenType(rawValue: registerRequest.tokenType) else {
                        return
                }
                
                let tokenRequest = DitoTokenRequest(platformApiKey: registerRequest.platformApiKey,
                                                    sha1Signature: registerRequest.sha1Signature,
                                                    token: registerRequest.token, tokenType: tokenType)
                
                self.serviceNotification.unregister(reference: reference, data: tokenRequest) { [weak self] (register, error) in
                    
                    guard let self = self else { return }
                    if let error = error {
                        self.notificationReadOffline.updateUnregister(id: notificationRegister.objectID, retry: notificationRegister.retry + 1)
                        DitoLogger.error(error.localizedDescription)
                    } else {
                        self.notificationReadOffline.deleteUnregister()
                        DitoLogger.information("Notification - Token registrado")
                    }
                }
    
            } else {
                DitoLogger.warning("Register Token - Antes de registrar o token é preciso identificar o usuário.")
            }
        }
    }
}
