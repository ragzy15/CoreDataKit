//
//  CoreDatabase.swift
//  CoreDatabase
//
//  Created by Raghav Ahuja on 18/10/19.
//  Copyright © 2019 Raghav Ahuja. All rights reserved.
//

import CoreData

public class CoreDatabase {
    
    public static var shared: CoreDatabase!
    public let coreDataModelName: String
    internal let stack: CoreDataStack
    
    internal var viewContext: NSManagedObjectContext {
        return stack.viewContext
    }
    
    public required init(modelName: String, completion: @escaping (CoreDataStackResultType) -> Void) {
        coreDataModelName = modelName
        stack = CoreDataStack(name: modelName)
        addStores(completion: completion)
    }
    
    public static func initializeSharedInstance(modelName: String,
                                                completion: @escaping (CoreDataStackResultType) -> Void) {
        var database: CoreDatabase!
        
        database = CoreDatabase(modelName: modelName) { (result) in
            switch result {
            case .success(let stores):
                CoreDatabase.shared = database
                completion(.success(stores))
                
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    @inline(__always)
    internal func addStores(completion: @escaping (CoreDataStackResultType) -> ()) {
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
