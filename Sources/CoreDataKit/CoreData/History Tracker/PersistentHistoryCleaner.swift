//
//  PersistentHistoryCleaner.swift
//  CoreDataKit
//
//  Created by Raghav Ahuja on 13/10/20.
//

import CoreData

@available(iOS 13.0, *)
struct PersistentHistoryCleaner {

    let context: NSManagedObjectContext
    let targets: [CKAppTarget]
    let userDefaults: CKUserDefaults

    /// Cleans up the persistent history by deleting the transactions that have been merged into each target.
    func clean() throws {
        guard let timestamp = userDefaults.lastCommonTransactionTimestamp(in: targets) else {
            print("Cancelling deletions as there is no common transaction timestamp")
            return
        }

        let deleteHistoryRequest = NSPersistentHistoryChangeRequest.deleteHistory(before: timestamp)
        print("Deleting persistent history using common timestamp \(timestamp)")
        try context.execute(deleteHistoryRequest)

        targets.forEach { target in
            /// Reset the dates as we would otherwise end up in an infinite loop.
            userDefaults.updateLastHistoryTransactionTimestamp(for: target, to: nil)
        }
    }
}
