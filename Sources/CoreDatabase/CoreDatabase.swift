//
//  CoreDatabase.swift
//  CoreDatabase
//
//  Created by Raghav Ahuja on 18/10/19.
//  Copyright © 2019 Raghav Ahuja. All rights reserved.
//

import CoreData

public class CoreDatabase {
    
    static internal var shared: CoreDatabase?
    public let coreDataModelName: String
    internal let stack: CoreDataStack
    
    internal var viewContext: NSManagedObjectContext {
        return stack.viewContext
    }
    
    static func initializeSharedInstance(modelName: String) {
        CoreDatabase.shared = CoreDatabase(modelName: modelName)
    }
    
    required init(modelName: String) {
        coreDataModelName = modelName
        stack = CoreDataStack(name: modelName)
    }
    
    func addStores(completion: @escaping (Result<[NSPersistentStoreDescription], NSError>) -> ()) {
        stack.loadPersistentStores(completion: completion)
    }
    
    @discardableResult
    public func perform<T: NSManagedObject>(_ builder: () -> FetchRequest<T>) -> Perform<T> {
        let perform = Perform<T>(stack: stack, builder: builder)
        return perform
    }
    
    public func performInsert<T: NSManagedObject>(_ insertions: (T) -> Void) throws {
        _ = try Insert<T>(stack: stack, insertions)
    }
    
    public func performInsert<T: NSManagedObject>(_ insertions: (T, NSManagedObjectContext) -> Void) throws {
        _ = try Insert<T>(stack: stack, insertions)
    }
}
