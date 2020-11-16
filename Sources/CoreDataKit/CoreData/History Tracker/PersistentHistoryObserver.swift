//
//  PersistentHistoryObserver.swift
//  CoreDataKit
//
//  Created by Raghav Ahuja on 13/10/20.
//

import CoreData

@available(iOS 13.0, *)
public enum CKAppTarget: String, CaseIterable {
    case app
    case shareExtension
}

@available(iOS 13.0, *)
public final class CKPersistentHistoryObserver {
    
    public static let defaultApp = CKPersistentHistoryObserver(target: .app,
                                                               persistentContainer: CoreDataKit.default.getStack().getPersistentContainer(),
                                                               userDefaults: UserDefaults.standardAppGroup)

    private let target: CKAppTarget
    private let userDefaults: UserDefaults
    private let persistentContainer: NSPersistentContainer

    /// An operation queue for processing history transactions.
    private lazy var historyQueue: OperationQueue = {
        let queue = OperationQueue()
        queue.qualityOfService = .background
        queue.maxConcurrentOperationCount = 1
        return queue
    }()

    public init(target: CKAppTarget, persistentContainer: NSPersistentContainer, userDefaults: UserDefaults) {
        self.target = target
        self.userDefaults = userDefaults
        self.persistentContainer = persistentContainer
    }

    public func startObserving() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(processStoreRemoteChanges),
                                               name: .NSPersistentStoreRemoteChange,
                                               object: persistentContainer.persistentStoreCoordinator)
    }
    
    public func stopObserving() {
        NotificationCenter.default.removeObserver(self,
                                                  name: .NSPersistentStoreRemoteChange,
                                                  object: persistentContainer.persistentStoreCoordinator)
    }

    /// Process persistent history to merge changes from other coordinators.
    @objc private func processStoreRemoteChanges(_ notification: Notification) {
        historyQueue.addOperation { [weak self] in
            self?.processPersistentHistory()
        }
    }

    private func processPersistentHistory() {
        let context = persistentContainer.newBackgroundContext()
        
        context.performAndWait {
            do {
                let merger = PersistentHistoryMerger(backgroundContext: context,
                                                     viewContext: persistentContainer.viewContext,
                                                     currentTarget: target, userDefaults: userDefaults)
                try merger.merge()

                let cleaner = PersistentHistoryCleaner(context: context,
                                                       targets: CKAppTarget.allCases,
                                                       userDefaults: userDefaults)
                try cleaner.clean()
            } catch {
                print("Persistent History Tracking failed with error \(error)")
            }
        }
    }
}

@available(iOS 13.0, *)
extension UserDefaults {

    func lastHistoryTransactionTimestamp(for target: CKAppTarget) -> Date? {
        let key = "lastHistoryTransactionTimeStamp-\(target.rawValue)"
        return object(forKey: key) as? Date
    }

    func updateLastHistoryTransactionTimestamp(for target: CKAppTarget, to newValue: Date?) {
        let key = "lastHistoryTransactionTimeStamp-\(target.rawValue)"
        set(newValue, forKey: key)
    }

    func lastCommonTransactionTimestamp(in targets: [CKAppTarget]) -> Date? {
        let timestamp = targets
            .map { lastHistoryTransactionTimestamp(for: $0) ?? .distantPast }
            .min() ?? .distantPast
        return timestamp > .distantPast ? timestamp : nil
    }
}