//
//  Dito.swift
//  DitoSDK
//
//  Created by Rodrigo Damacena Gamarra Maciel on 21/01/21.
//

import Foundation

public class Dito {

    public static let shared = Dito()
    static var apiKey: String = ""
    static var apiSecret: String = ""
    static var signature: String = ""
    private var reachability = try! Reachability()
    private lazy var retry = DitoRetry()

    init() {
        Dito.apiKey = Bundle.main.apiKey
        Dito.apiSecret = Bundle.main.apiSecret
        Dito.signature = Bundle.main.apiSecret.sha1
    }

    public func configure() {

        DispatchQueue.main.async {
            NotificationCenter.default
                .addObserver(
                    self,
                    selector: #selector(self.reachabilityChanged(_:)),
                    name: .reachabilityChanged,
                    object: nil
                )

            do {
                try self.reachability.startNotifier()
            } catch let error {
                DitoLogger.error(error.localizedDescription)
            }
        }
    }

    public static func sha1(for email: String) -> String {
        return email.sha1
    }

    public static func identify(id: String, data: DitoUser) {
        let dtIdentify = DitoIdentify()
        dtIdentify.identify(id: id, data: data)
    }

    public static func track(event: DitoEvent) {
        let dtTrack = DitoTrack()
        dtTrack.track(data: event)
    }

    /// Registers a Firebase Cloud Messaging (FCM) token for push notifications
    /// - Parameter token: The FCM token obtained from Firebase Messaging
    public static func registerDevice(token: String) {
        let notification = DitoNotification()
        notification.registerToken(token: token)
    }

    /// Unregisters a Firebase Cloud Messaging (FCM) token
    /// - Parameter token: The FCM token to unregister
    public static func unregisterDevice(token: String) {
        let notification = DitoNotification()
        notification.unregisterToken(token: token)
    }

    /// Called when a notification arrives (before click)
    /// - Parameter userInfo: The notification data dictionary
    public static func notificationRead(with userInfo: [AnyHashable: Any], token: String) {
        let dtTrack = DitoTrack()
        let notificationReceived = DitoNotificationReceived(with: userInfo)
        let dtIdentify = DitoIdentify()


        // Ensure we have a valid email for identification
        let userEmail = notificationReceived.email ?? ""
        let ditoUser = DitoUser(id: notificationReceived.userId, email: userEmail)
        dtIdentify.identify(id: notificationReceived.userId, data: ditoUser)
        dtTrack.track(
            data: DitoEvent(
                action: "receive-ios-notification",
                customData: [
                    "canal": "mobile",
                    "token": token,
                    "id-disparo": notificationReceived.logId,
                    "id-notificacao": notificationReceived.notification,
                    "nome_notificacao": notificationReceived.notificationName,
                    "provedor": "firebase",
                    "sistema_operacional": "Apple iPhone",
                ]
            )
        )

    }

    /// Called when a notification is clicked
    /// - Parameters:
    ///   - userInfo: The notification data dictionary
    ///   - callback: Optional callback with deeplink
    @discardableResult
    public static func notificationClick(
        with userInfo: [AnyHashable: Any],
        callback: ((String) -> Void)? = nil
    ) -> DitoNotificationReceived {

        let notificationReceived = DitoNotificationReceived(with: userInfo)
        let ditoNotification = DitoNotification()
        ditoNotification
            .notificationClick(
                notificationId: notificationReceived.notification,
                reference: notificationReceived.reference,
                identifier: notificationReceived.identifier
            )
        callback?(notificationReceived.deeplink)
        return notificationReceived
    }
}

//MARK: - Network Connection
extension Dito {

    @objc func reachabilityChanged(_ note: Notification) {

        if self.reachability.connection != .unavailable {
            retry.loadOffline()
        }
    }
}
