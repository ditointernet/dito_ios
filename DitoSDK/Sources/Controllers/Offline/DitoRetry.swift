import Foundation
import CoreData

extension DitoRetry {
    struct TrackData: Sendable {
        let id: NSManagedObjectID
        let eventJSON: String
        let retry: Int16
    }

    struct NotificationData: Sendable {
        let id: NSManagedObjectID
        let json: String?
        let retry: Int16
    }
}

@MainActor
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
        // TODO: Fix all offline retry methods - concurrency issues
        // checkIdentify() { [weak self] finish in
        //     guard let self = self else { return }
        //     if finish {
        //         // self.checkTrack()
        //         // self.checkNotification()
        //         self.checkNotificationRegister()
        //         self.checkNotificationUnregister()
        //     }
        // }
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
        let tracks = self.trackOffline.getTrack

        for track in tracks {
            guard let eventJSON = track.event else { continue }
            let trackId = track.objectID
            let currentRetry = track.retry

            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }

                guard let eventRequest = eventJSON.convertToObject(type: DitoEventRequest.self) else {
                    DitoLogger.error("Falha ao decodificar DitoEventRequest do JSON salvo")
                    return
                }

                var decodedEvent: DitoEvent? = nil
                if let base64Data = Data(base64Encoded: eventRequest.event) {
                    do {
                        decodedEvent = try JSONDecoder().decode(DitoEvent.self, from: base64Data)
                    } catch {
                        DitoLogger.error("Falha ao decodificar DitoEvent do base64: \(error.localizedDescription)")
                    }
                } else {
                    if let rawData = eventRequest.event.data(using: .utf8) {
                        do {
                            decodedEvent = try JSONDecoder().decode(DitoEvent.self, from: rawData)
                        } catch {
                            // Não é crítico para reenvio; apenas logamos
                            DitoLogger.warning("Campo 'event' não está em base64 ou JSON válido para DitoEvent")
                        }
                    }
                }

                if let reference = self.trackOffline.reference, !reference.isEmpty {
                    self.serviceTrack.event(reference: reference, data: eventRequest) { [weak self] (_, error) in
                        guard let self = self else { return }
                        if let error = error {
                            self.trackOffline.update(id: trackId, event: eventRequest, retry: currentRetry + 1)
                            DitoLogger.error(error.localizedDescription)
                        } else {
                            self.trackOffline.delete(id: trackId)
                            DitoLogger.information("Track - Evento enviado")
                        }
                    }
                } else {
                    self.trackOffline.update(id: trackId, event: eventRequest, retry: currentRetry + 1)
                    DitoLogger.warning("Track - Antes de enviar um evento é preciso identificar o usuário.")
                }
            }
        }
    }

    private func sendEvent(objectID: NSManagedObjectID, eventJSON: String, retry: Int16) {
        guard let eventRequest = eventJSON.convertToObject(type: DitoEventRequest.self) else { return }
        let id = objectID

        if let reference = trackOffline.reference, !reference.isEmpty {
            serviceTrack.event(reference: reference, data: eventRequest) { [weak self] (_, error) in


                guard let self = self else { return }
                if let error = error {
                    self.trackOffline.update(id: id, event: eventRequest, retry: retry + 1)
                    DitoLogger.error(error.localizedDescription)
                } else {
                    self.trackOffline.delete(id: id)
                    DitoLogger.information("Track - Evento enviado")
                }
            }
        } else {
            trackOffline.update(id: id, event: eventRequest, retry: retry + 1)
            DitoLogger.warning("Track - Antes de enviar um evento é preciso identificar o usuário.")
        }
    }


    private func checkNotification() {
        let notifications = self.notificationReadOffline.getNotificationRead

        for notification in notifications {
            let notifID = notification.objectID
            let jsonData = notification.json
            let notifRetry = notification.retry

            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                guard let notificationRead = jsonData,
                      let notificationRequest = notificationRead.convertToObject(type: DitoNotificationOpenRequest.self) else {
                          return
                }

                if let reference = self.notificationReadOffline.reference, !reference.isEmpty, !notificationRequest.data.identifier.isEmpty {
                    self.serviceNotification.read(notificationId: notificationRequest.data.identifier, data: notificationRequest) { (register, error) in

                        if let error = error {
                            self.notificationReadOffline.updateRead(id: notifID, retry: notifRetry + 1)
                            DitoLogger.error(error.localizedDescription)
                        } else {
                            self.notificationReadOffline.deleteRead(id: notifID)
                            DitoLogger.information("Notification Read - Deletado")
                        }
                    }

                } else {
                    DitoLogger.warning("Notification Read - Antes de informar uma notifição lida é preciso identificar o usuário.")
                }
            }
        }
    }


    private func checkNotificationRegister() {
        DispatchQueue.global(qos: .background).async {


            if let reference = self.notificationReadOffline.reference, !reference.isEmpty {




                guard let notificationRegister = self.notificationReadOffline.getNotificationRegister,
                      let registerJson = notificationRegister.json,
                      let registerRequest = registerJson.convertToObject(type: DitoTokenRequest.self) else {
                      let registerRequest = registerJson.convertToObject(type: DitoTokenRequest.self) else {
                        return
                }


                let tokenRequest = DitoTokenRequest(platformApiKey: registerRequest.platformApiKey,
                                                    sha1Signature: registerRequest.sha1Signature,
                                                    token: registerRequest.token)

                                                    token: registerRequest.token)

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
                      let registerRequest = registerJson.convertToObject(type: DitoTokenRequest.self) else {
                      let registerRequest = registerJson.convertToObject(type: DitoTokenRequest.self) else {
                        return
                }


                let tokenRequest = DitoTokenRequest(platformApiKey: registerRequest.platformApiKey,
                                                    sha1Signature: registerRequest.sha1Signature,
                                                    token: registerRequest.token)

                                                    token: registerRequest.token)

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
