//
//  DTRetry.swift
//  DitoSDK
//
//  Created by Rodrigo Damacena Gamarra Maciel on 14/01/21.
//

import Foundation


struct DitoRetry {
    
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
        checkIdentify() { finish in
            if finish {
                checkTrack()
                checkNotification()
            }
        }
    }
    
    private func checkIdentify(completion: @escaping (_ executed: Bool)->()) {
        DispatchQueue.global().async {
            
            guard let identify = identifyOffline.getIdentify,
                  let id = identify.id,
                  let signupRequest = identify.json?.convertToObject(type: DitoSignupRequest.self) else { return }
            
            if !identify.send {
                
                serviceIdentify.signup(network: "portal", id: id, data: signupRequest) { (identify, error) in
                    
                    if let error = error {
                        DitoLogger.error(error.localizedDescription)
                        completion(false)
                    } else {
                        if let reference = identify?.reference {
                            identifyOffline.update(id: id, params: signupRequest, reference: reference, send: true)
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
            
            let tracks = trackOffline.getTrack
            
            tracks.forEach { track in
                sendEvent(track: track)
            }
        }
    }
    
    private func sendEvent(track: Track) {
        
        guard let event = track.event, let eventRequest = event.convertToObject(type: DitoEventRequest.self) else { return }
        let id = track.objectID
        
        if let reference = trackOffline.reference, !reference.isEmpty {
            serviceTrack.event(reference: reference, data: eventRequest) { (_, error) in
                
                if let error = error {
                    trackOffline.update(id: id, event: eventRequest, retry: track.retry + 1)
                    DitoLogger.error(error.localizedDescription)
                } else {
                    trackOffline.delete(id: id)
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
            
            let notifications = notificationReadOffline.getNotification
            notifications.forEach { notification in
                sendNotificationRead(notification)
            }
        }
    }
    
    private func sendNotificationRead(_ notification: NotificationRead) {
        
        guard let notificationRead = notification.json,
              let notificationRequest = notificationRead.convertToObject(type: DitoNotificationOpenRequest.self) else {
                return
        }
        
        if let reference = notificationReadOffline.reference, !reference.isEmpty, !notificationRequest.data.identifier.isEmpty {
            
            serviceNotification.read(reference: reference, data: notificationRequest) { (register, error) in
                
                if let error = error {
                    notificationReadOffline.update(id: notification.objectID, retry: notification.retry + 1)
                    DitoLogger.error(error.localizedDescription)
                } else {
                    notificationReadOffline.delete(id: notification.objectID)
                    DitoLogger.information("Notification Read - Deletado")
                }
            }
            
        } else {
            DitoLogger.warning("Notification Read - Antes de informar uma notifição lida é preciso identificar o usuário.")
        }
    }
}
