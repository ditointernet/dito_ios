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

  init(service: DitoNotificationService = .init(), trackOffline: DitoNotificationOffline = .init())
  {
    self.service = service
    self.notificationOffline = trackOffline
  }

  /// Registers a Firebase Cloud Messaging (FCM) token
  /// - Parameter token: The FCM token from Firebase Messaging
  func registerToken(token: String) {
    self.finishRegisterToken(token: token)
  }

  func finishRegisterToken(token: String) {
    // Capture main-actor isolated values before hopping to a background queue
    let apiKey = Dito.apiKey
    let signature = Dito.signature

    DispatchQueue.global().async {
      let tokenRequest = DitoTokenRequest(
        platformApiKey: apiKey, sha1Signature: signature, token: token)

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
        DitoLogger.warning(
          "Register Token - Antes de registrar o token é preciso identificar o usuário.")
      }
    }
  }

  /// Unregisters a Firebase Cloud Messaging (FCM) token
  /// - Parameter token: The FCM token to unregister
  func unregisterToken(token: String) {
    // Capture main-actor isolated values before hopping to a background queue
    let apiKey = Dito.apiKey
    let signature = Dito.signature

    DispatchQueue.global().async {
      let tokenRequest = DitoTokenRequest(
        platformApiKey: apiKey,
        sha1Signature: signature,
        token: token)

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
        DitoLogger.warning(
          "Unregister Token - Antes de cancelar um token é preciso identificar o usuário.")
      }
    }
  }

  /// Called when notification is received (before click)
  /// - Parameter userInfo: The notification data dictionary
  func notificationRead(with userInfo: [AnyHashable: Any]) {
    // Capture main-actor isolated values before hopping to a background queue
    let apiKey = Dito.apiKey
    let signature = Dito.signature

    DispatchQueue.global(qos: .background).async {
      let data = DitoDataNotification(from: userInfo)

      let notificationRequest = DitoNotificationOpenRequest(
        platformApiKey: apiKey,
        sha1Signature: signature,
        data: data)

      DitoLogger.information("Notification - Received: \(data.notification)")
      self.notificationOffline.notificationRead(notificationRequest)
    }
  }

  /// Called when notification is clicked
  /// - Parameters:
  ///   - notificationId: The notification ID
  ///   - reference: The user reference
  ///   - identifier: The identifier
  func notificationClick(notificationId: String, reference: String, identifier: String) {
    // Capture main-actor isolated values before hopping to a background queue
    let apiKey = Dito.apiKey
    let signature = Dito.signature

    DispatchQueue.global(qos: .background).async {
      let data = DitoDataNotification(identifier: identifier, reference: reference)

      let notificationRequest = DitoNotificationOpenRequest(
        platformApiKey: apiKey,
        sha1Signature: signature,
        data: data)

      if notificationId != "" {

        self.service.read(notificationId: notificationId, data: notificationRequest) {
          (register, error) in

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
