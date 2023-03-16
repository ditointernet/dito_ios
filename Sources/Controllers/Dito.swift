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
            NotificationCenter.default.addObserver(self, selector: #selector(self.reachabilityChanged(_:)), name: .reachabilityChanged, object: nil)
            
            do{
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
    
    public static func registerDevice(token: String, tokenType: DitoTokenType) {
        let notification = DitoNotification()
        notification.registerToken(token: token, tokenType: tokenType)
    }
    
    public static func unregisterDevice(token: String, tokenType: DitoTokenType) {
        let notification = DitoNotification()
        notification.unregisterToken(token: token, tokenType: tokenType)
    }
    
    @discardableResult
    public static func notificationRead(with userInfo: [AnyHashable: Any],
                                        callback: ((String) -> Void)?) -> DitoNotificationReceived {
        
        let notificationReceived = DitoNotificationReceived(with: userInfo)
        let ditoNotification = DitoNotification()
        ditoNotification.notificationRead(identifier: notificationReceived.notification)
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
