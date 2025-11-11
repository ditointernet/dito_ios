//
//  CoreDataManager.swift
//  DitoSDK
//
//  Created by Mateus Rodrigues on 12/01/21.
//

import Foundation
import CoreData

class DitoCoreDataManager {

    /// Singleton of its class
    public static let shared = DitoCoreDataManager()

    /// Model name
    private let model: String = "DitoDataModel"

    /// Persistent Container to manage Core Data stack
    /// Thread-safe and properly initialized for iOS 16+
    private(set) lazy var persistentContainer: NSPersistentContainer? = {
        return createPersistentContainer()
    }()

    /// Main view context - should only be accessed from main thread
    /// iOS 16+ requires strict concurrency checking
    @MainActor
    var viewContext: NSManagedObjectContext? {
        return persistentContainer?.viewContext
    }

    private init() {
        // Private initializer for singleton
    }

    /// Creates and configures the persistent container
    /// Returns nil if setup fails to avoid force unwrapping
    private func createPersistentContainer() -> NSPersistentContainer? {
        // Use Bundle(for:) instead of identifier to avoid hardcoding
        guard let frameworkBundle = Bundle(for: type(of: self)).url(forResource: self.model, withExtension: "momd"),
              let managedObjectModel = NSManagedObjectModel(contentsOf: frameworkBundle) else {
            DitoLogger.error("Failed to load Core Data model '\(self.model)'")
            return nil
        }

        let container = NSPersistentContainer(name: self.model, managedObjectModel: managedObjectModel)

        // Configure container for better concurrency support (iOS 16+)
        let description = container.persistentStoreDescriptions.first
        description?.setOption(true as NSNumber, forKey: NSPersistentHistoryTrackingKey)
        description?.setOption(true as NSNumber, forKey: NSPersistentStoreRemoteChangeNotificationPostOptionKey)

        var loadError: Error?
        let semaphore = DispatchSemaphore(value: 0)

        container.loadPersistentStores { (storeDescription, error) in
            if let error = error {
                DitoLogger.error("Failed to load persistent store: \(error.localizedDescription)")
                loadError = error
            } else {
                DitoLogger.information("Persistent store loaded successfully")
            }
            semaphore.signal()
        }

        semaphore.wait()

        if loadError != nil {
            return nil
        }

        // Configure view context for iOS 16+ concurrency
        container.viewContext.automaticallyMergesChangesFromParent = true
        container.viewContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy

        // Set quality of service for better performance
        container.viewContext.undoManager = nil
        container.viewContext.shouldDeleteInaccessibleFaults = true

        return container
    }

    /// Performs a task on a background context (thread-safe)
    /// This is the recommended way to perform Core Data operations in iOS 16+
    func performBackgroundTask(_ block: @escaping (NSManagedObjectContext) -> Void) {
        guard let container = persistentContainer else {
            DitoLogger.error("Cannot perform background task: persistent container not available")
            return
        }
        container.performBackgroundTask(block)
    }

    /// Creates a new background context for batch operations
    /// Use this for operations that don't need to be performed immediately
    func newBackgroundContext() -> NSManagedObjectContext? {
        guard let container = persistentContainer else {
            DitoLogger.error("Cannot create background context: persistent container not available")
            return nil
        }
        let context = container.newBackgroundContext()
        context.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        context.undoManager = nil
        return context
    }
}

// MARK: - UserDefaults Support Models
struct NotificationDefaults: Codable {
    var retry: Int16
    var json: String?
}

struct IdentifyDefaults: Codable {
    var id: String?
    var json: String?
    var reference: String?
    var send: Bool
}
