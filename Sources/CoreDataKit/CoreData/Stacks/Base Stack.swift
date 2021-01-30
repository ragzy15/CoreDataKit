//
//  Base Stack.swift
//  CoreDataKit
//
//  Created by Raghav Ahuja on 06/01/20.
//  Copyright © 2019 Raghav Ahuja. All rights reserved.
//

import CoreData

class CKBaseStack<Container: CKContainer & CKContainerType>: CKStack {
    
    var viewContext: CKContext {
        persistentContainer.viewContext
    }
    
    let persistentContainer: Container
    
    private lazy var parentBagroundContext: CKContext = {
        let context = newBackgroundTask()
        context.automaticallyMergesChangesFromParent = true
        context.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        return context
    }()
    
    init(modelName name: String) {
        persistentContainer = Container(with: name)
        
        persistentContainer.persistentStoreDescriptions.forEach { (storeDescription) in
            if #available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *) {
                storeDescription.setOption(true as NSNumber, forKey: NSPersistentStoreRemoteChangeNotificationPostOptionKey)
            }
            
            if #available(iOS 11.0, macOS 10.13, tvOS 11.0, *) {
                storeDescription.setOption(true as NSNumber, forKey: NSPersistentHistoryTrackingKey)
            }
        }
    }
    
    func getPersistentContainer() -> _Container {
        persistentContainer
    }
}

// MARK: CORE SPOTLIGHT
extension CKBaseStack: CKCoreSpotlight {
    
    @available(iOS 11.0, *)
    func setCoreDataCoreSpotlightExporter(for exporter: ([CKStoreDescription], CKObjectModel) -> Void) {
        exporter(persistentContainer.persistentStoreDescriptions, persistentContainer.managedObjectModel)
    }
}

// MARK: MIGRATION
extension CKBaseStack: CKStoreDescriptionMethods {
    
    @inline(__always)
    func addStoreDescriptions(_ descriptions: [CKStoreDescription]) {
        persistentContainer.persistentStoreDescriptions.append(contentsOf: descriptions)
    }
    
    @inline(__always)
    func addStoreDescriptions(_ descriptions: CKStoreDescription...) {
        persistentContainer.persistentStoreDescriptions.append(contentsOf: descriptions)
    }
    
    @inline(__always)
    func replaceStoreDescriptions(with descriptions: [CKStoreDescription]) {
        persistentContainer.persistentStoreDescriptions = descriptions
    }
    
    @inline(__always)
    func replaceStoreDescriptions(with descriptions: CKStoreDescription...) {
        persistentContainer.persistentStoreDescriptions = descriptions.map { $0 }
    }
    
    @inline(__always)
    func loadPersistentStores(block: ((Result<CKStoreDescription, NSError>) -> Void)?) {
        persistentContainer.persistentStoreCoordinator.performAndWait {
            
            persistentContainer.loadPersistentStores { [weak self] (storeDescription, error) in
                
                if let error = error as NSError? {
                    CKManager.default.logger.log(error: error)
                    
                    block?(.failure(error))
                    
                    // Replace this implementation with code to handle the error appropriately.
                    // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                    
                    /*
                     Typical reasons for an error here include:
                     * The parent directory does not exist, cannot be created, or disallows writing.
                     * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                     * The device is out of space.
                     * The store could not be migrated to the current model version.
                     Check the error message to determine what the actual problem was.
                     */
                    CKManager.default.logger.fatalError("Unresolved error \(error), \(error.userInfo)")
                } else {
                    self?.persistentContainer.updateContexts()
                    block?(.success(storeDescription))
                }
            }
        }
    }
}

// MARK: NEW BACKGROUND CONTEXT
extension CKBaseStack {
    
    /// Causes the persistent container to execute the block against a new private queue context.
    /// - Parameter block: A block that is executed by the persistent container against a newly created private context. The private context is passed into the block as part of the execution of the block.
    func performBackgroundTask(_ block: @escaping (CKContext) -> Void) {
        persistentContainer.performBackgroundTask { (context) in
            block(context)
        }
    }
    
    /// Creates a private managed object context.
    /// - Returns: A newly created private managed object context.
    func newBackgroundTask() -> CKContext {
        let context = persistentContainer.newBackgroundContext()
        return context
    }
    
    /// Creates a main managed object context.
    /// - Returns: A newly created private managed object context.
    func newMainThreadChildTask() -> CKContext {
        let context = CKContext(concurrencyType: .mainQueueConcurrencyType)
        context.parent = parentBagroundContext
        context.automaticallyMergesChangesFromParent = true
        return context
    }
    
    /// Creates a private managed object context.
    /// - Returns: A newly created private managed object context.
    func newBackgroundThreadChildTask() -> CKContext {
        let context = CKContext(concurrencyType: .privateQueueConcurrencyType)
        context.parent = parentBagroundContext
        context.automaticallyMergesChangesFromParent = true
        return context
    }
}
