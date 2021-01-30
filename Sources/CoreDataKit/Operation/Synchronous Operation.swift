//
//  Synchronous Operation.swift
//  CoreDataKit
//
//  Created by Raghav Ahuja on 18/10/19.
//  Copyright © 2019 Raghav Ahuja. All rights reserved.
//

import Foundation

public class CKSynchronousOperation: CKBaseOperation {

    public func save() -> Result<Void, NSError> {
        isCommitted = true
        
        let result = context.saveContextSync()
        return result
    }
    
    public func newChildOperation() -> CKSynchronousOperation {
        let childContext = CKContext(concurrencyType: .mainQueueConcurrencyType)
        childContext.parent = unsafeContext
        childContext.automaticallyMergesChangesFromParent = true
        return CKSynchronousOperation(context: childContext, queue: queue, logger: logger)
    }
}
