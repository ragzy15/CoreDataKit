//
//  Insert.swift
//  CoreDatabase
//
//  Created by Raghav Ahuja on 18/10/19.
//  Copyright © 2019 Raghav Ahuja. All rights reserved.
//

import CoreData

internal class Insert<T: NSManagedObject> {
    
    private let entity: T
    
    internal init(stack: CoreDataStack, _ insertions: (T) -> Void) throws {
        let context = stack.newBackgroundTask()
        entity = T(context: context)
        
        insertions(entity)
        try context.save()
    }

    internal init(stack: CoreDataStack, _ insertions: (T, NSManagedObjectContext) -> Void) throws {
        let context = stack.newBackgroundTask()
        entity = T(context: context)
        
        insertions(entity, context)
        try context.save()
    }
}
