//
//  AppDelegate.swift
//  Dito test sdk
//
//  Created by Igor Duarte on 26/03/24.
//

import DitoSDK
import FirebaseAnalytics
import FirebaseCore
import FirebaseMessaging
import UIKit
import UserNotifications

@main
class AppDelegate: UIResponder, UIApplicationDelegate, MessagingDelegate {
    var fcmToken: String?

    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication
            .LaunchOptionsKey: Any]?
    ) -> Bool {
        // Configure Firebase first
        FirebaseApp.configure()
        Analytics.setAnalyticsCollectionEnabled(true)

        // Log app open event to Analytics
        Analytics.logEvent(AnalyticsEventAppOpen, parameters: nil)

        // Configure Messaging delegate
        Messaging.messaging().delegate = self

        // Configure Dito SDK
        Dito.shared.configure()

        // Setup notifications
        UNUserNotificationCenter.current().delegate = self
        registerForPushNotifications(application: application)

        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(
        _ application: UIApplication,
        configurationForConnecting connectingSceneSession: UISceneSession,
        options: UIScene.ConnectionOptions
    ) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(
            name: "Default Configuration",
            sessionRole: connectingSceneSession.role
        )
    }

    func application(
        _ application: UIApplication,
        didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data
    ) {
        // CRITICAL: Set APNS token to Firebase Messaging BEFORE requesting FCM token
        Messaging.messaging().apnsToken = deviceToken

        Messaging.messaging().token { [weak self] fcmToken, error in
            if let error = error {
                print("Error fetching FCM registration token: \(error)")
            } else if let fcmToken = fcmToken {
                self?.fcmToken = fcmToken
                print("FCM registration token: \(fcmToken)")
            }
        }
    }

    func application(
        _ application: UIApplication,
        didFailToRegisterForRemoteNotificationsWithError error: Error
    ) {
        print(
            "Failed to register for remote notifications: \(error.localizedDescription)"
        )
    }

    // MARK: Background remote notification (silent / content-available)
    func application(
        _ application: UIApplication,
        didReceiveRemoteNotification userInfo: [AnyHashable : Any],
        fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void
    ) {
        // Garantir que o evento de leitura seja disparado mesmo em background
        let callNotificationRead: (String) -> Void = { token in
            Dito.notificationRead(with: userInfo, token: token)
            Messaging.messaging().appDidReceiveMessage(userInfo)
            completionHandler(.newData)
        }

        if let token = self.fcmToken {
            callNotificationRead(token)
        } else {
            // Fallback: tentar obter o token se ainda não estiver armazenado
            Messaging.messaging().token { [weak self] token, error in
                if let token = token {
                    self?.fcmToken = token
                    callNotificationRead(token)
                } else {
                    print("FCM token unavailable in background: \(error?.localizedDescription ?? "unknown error")")
                    completionHandler(.noData)
                }
            }
        }
    }
}

extension AppDelegate: UNUserNotificationCenterDelegate {
    func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        willPresent notification: UNNotification,
        withCompletionHandler completionHandler:
            @escaping (UNNotificationPresentationOptions) -> Void
    ) {
        let userInfo = notification.request.content.userInfo
        // Notify Firebase Messaging
        Messaging.messaging().appDidReceiveMessage(userInfo)
        completionHandler([[.banner, .list, .sound, .badge]])
    }

    private func registerForPushNotifications(application: UIApplication) {
        let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]

        UNUserNotificationCenter.current().requestAuthorization(
            options: authOptions
        ) { granted, error in
            if let error = error {
                print(
                    "Error requesting notification authorization: \(error.localizedDescription)"
                )
                return
            }

            guard granted else {
                print("Notification authorization not granted")
                return
            }

            print("Notification authorization granted")

            // Register for remote notifications on main thread
            DispatchQueue.main.async {
                application.registerForRemoteNotifications()
            }
        }
    }

    func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        didReceive response: UNNotificationResponse,
        withCompletionHandler completionHandler: @escaping () -> Void
    ) {
        let userInfo = response.notification.request.content.userInfo
        Dito.notificationClick(with: userInfo)

        // Notify Firebase Messaging
        Messaging.messaging().appDidReceiveMessage(userInfo)

        completionHandler()
    }
}
