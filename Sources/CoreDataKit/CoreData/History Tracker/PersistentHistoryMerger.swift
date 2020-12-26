//
//  PersistentHistoryMerger.swift
//  CoreDataKit
//
//  Created by Raghav Ahuja on 13/10/20.
//

import os.log
import CoreData

@available(iOS 13.0, *)
struct PersistentHistoryMerger {

    let backgroundContext: NSManagedObjectContext
    let viewContext: NSManagedObjectContext
    let currentTarget: CKAppTarget
    let userDefaults: CKUserDefaults
//    let logger: OSLog

    func merge() throws {
        let fromDate = userDefaults.lastHistoryTransactionTimestamp(for: currentTarget) ?? .distantPast
        let fetcher = PersistentHistoryFetcher(context: backgroundContext, fromDate: fromDate)
        let history = try fetcher.fetch()

        guard !history.isEmpty else {
//            os_log
            print("No history transactions found to merge for target \(currentTarget)")
            return
        }

        print("Merging \(history.count) persistent history transactions for target \(currentTarget)")

        history.merge(into: backgroundContext)

        viewContext.perform {
            history.merge(into: self.viewContext)
        }

        guard let lastTimestamp = history.last?.timestamp else {
            return
        }
        
        userDefaults.updateLastHistoryTransactionTimestamp(for: currentTarget, to: lastTimestamp)
    }
}

@available(iOS 11.0, *)
extension Collection where Element == NSPersistentHistoryTransaction {

    /// Merges the current collection of history transactions into the given managed object context.
    /// - Parameter context: The managed object context in which the history transactions should be merged.
    func merge(into context: NSManagedObjectContext) {
        forEach { transaction in
            guard let userInfo = transaction.objectIDNotification().userInfo else { return }
            NSManagedObjectContext.mergeChanges(fromRemoteContextSave: userInfo, into: [context])
        }
    }
}
