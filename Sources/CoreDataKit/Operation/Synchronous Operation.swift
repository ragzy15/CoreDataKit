//
//  Synchronous Operation.swift
//  CoreDataKit
//
//  Created by Raghav Ahuja on 18/10/19.
//  Copyright © 2019 Raghav Ahuja. All rights reserved.
//

import Foundation

public class CKSynchronousOperation: CKBaseOperation {

    public func save() -> Result<Bool, NSError> {
        isCommitted = true
        
        let result = context.saveContextSync()
        return result
    }
}
