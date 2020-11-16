//
//  Base Operation.swift
//  CoreDataKit
//
//  Created by Raghav Ahuja on 18/10/19.
//  Copyright © 2019 Raghav Ahuja. All rights reserved.
//

import Foundation

public class /*abstract*/ CKBaseOperation {
    
    /// A Boolean value that indicates whether the operation has uncommitted changes.
    public var hasChanges: Bool { context.hasChanges }
    
    let context: CKContext
    let queue: DispatchQueue
    
    let logger: CKLogger
    
    var isCommitted: Bool
    
    var isRunningInAllowedQueue: Bool { queue.isCurrentExecutionContext() }
    
    /// The merge policy of the operation.
    /// A policy that you use to resolve conflicts between the persistent store and in-memory versions of managed objects.
    /// The default is `.errorMergePolicyType`.
    public var mergePolicy: CKMergePolicyType = .errorMergePolicyType {
        willSet {
            context.mergePolicy = CKMergePolicy(merge: newValue)
        }
    }
    
    private let runningCondition = " outside its designated queue."
    private lazy var committedCondition = " from an already committed \(String(reflecting: Self.self))."
    
    /// Initalizes a task to perform Core Data operations.
    /// - Parameters:
    ///   - context: `CKContext` to perform operations with.
    ///   - queue: `DispatchQueue` on which this task will work.
    ///   - logger: `CKLogger` to check conditions and log errors and success.
    public init(context moc: CKContext, queue q: DispatchQueue, logger l: CKLogger) {
        context = moc
        queue = q
        logger = l
        isCommitted = false
        context.automaticallyMergesChangesFromParent = true
    }
}

// MARK: INSERT METHODS
public extension CKBaseOperation {
    
    /// Insert an object for an entity in `CKContext`.
    /// - Parameter entityType: A `CKObject` type to insert.
    /// - Returns: An object of `CKObject` type.
    func insert<Object: CKObject>(_ entityType: Object.Type) -> Object {
        precondition("Attempted to insert an entity of type '\(logger.typeName(entityType))'")
        
        let object = Object(context: context)
        context.insert(object)
        return object
    }
    
    /// Batch insert of data in a persistent store without loading any data or object into memory.
    /// - Parameter object: `CKBatchInsert` object containing the batch data to be inserted.
    /// - Returns: Type of `CKResult`. It can be `Int` for count, `Bool` for status or an array of `CKObjectId` indicating Ids for deleted objects.
    @available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
    func batchInsert<Object: CKObject, ResultType: CKResult>(into object: CKBatchInsert<Object, ResultType>) throws -> ResultType.CKType {
        precondition("Attempted to batch insert an entity of type '\(logger.typeName(Object.self))'")
        
        let result = try context.batchInsert(object)
        return result.result as! ResultType.CKType
    }
}

// MARK: UPDATE METHODS
public extension CKBaseOperation {
    
    /// Returns an editable copy of a specified `CKObject` type array.
    /// - Parameter objects: An array of `CKObject`type  to be updated.
    /// - Returns: Returns an editable copy of a specified `CKObject`type array.
    func update<Object: CKObject>(_ objects: [Object]) -> [Object] {
        precondition("Attempted to update an entities")
        
        return objects.compactMap { context.fetchExisting($0) }
    }
    
    /// Returns an editable copy of a specified `CKObject` type.
    /// - Parameter object: A `CKObject` type to be updated.
    /// - Returns: Returns an editable copy of a specified `CKObject` type.
    func update<Object: CKObject>(_ object: Object?) -> Object? {
        precondition("Attempted to update an entity of type '\(logger.typeName(object))'")
        
        guard let object = object else { return nil }
        return context.fetchExisting(object)
    }
    
    /// Batch update of data in a persistent store without loading any data into memory.
    /// - Parameter object: A `CKBatchUpdate` containing the configuarion.
    /// - Returns: Type of `CKResult`. It can be `Int` for count, `Bool` for status or an array of `CKObjectId` indicating Ids for deleted objects.
    func batchUpdate<Object: CKObject, Result: CKResult>(into object: CKBatchUpdate<Object, Result>) throws -> Result.CKType {
        precondition("Attempted to batch update an entity of type \(logger.typeName(Object.self))")
        
        let result = try context.batchUpdate(object)
        return result.result as! Result.CKType
    }
}

// MARK: DELETE METHODS
public extension CKBaseOperation {
    
    /// Specifies an object that should be removed from its persistent store when changes are committed.
    ///
    /// When changes are committed, object will be removed from the uniquing tables. If object has not yet been saved to a persistent store, it is simply removed from the receiver.
    ///
    /// - Parameter object: A `CKObject`.
    func delete<Object: CKObject>(_ object: Object?) {
        precondition("Attempted to delete from entity of type '\(logger.typeName(object))'")
        
        guard let object = object else { return }
        delete([object])
    }
    
    /// Specifies objects that should be removed from its persistent store when changes are committed.
    ///
    /// When changes are committed, objects will be removed from the uniquing tables. If the objects has not yet been saved to a persistent store, they are simply removed from the receiver.
    ///
    /// - Parameter objects: One or more `CKObject`s.
    func delete<Object: CKObject>(_ objects: Object...) {
        precondition("Attempted to delete from entities")
        
        objects.compactMap { context.fetchExisting($0) }.forEach { context.delete($0) }
    }
    
    /// Specifies objects that should be removed from its persistent store when changes are committed.
    ///
    /// When changes are committed, objects will be removed from the uniquing tables. If the objects has not yet been saved to a persistent store, they are simply removed from the receiver.
    ///
    /// - Parameter objects: An array of `CKObject`s.
    func delete<Object: CKObject>(_ objects: [Object]) {
        precondition("Attempted to delete from entities")
        
        objects.compactMap { context.fetchExisting($0) }.forEach { context.delete($0) }
    }
    
    /// Specifies objects that should be removed from its persistent store when changes are committed with the given `CKFetch` request.
    /// - Parameter request: A `CKFetch` request indicating the entity type and clauses.
    func delete<Object>(_ request: CKFetch<Object>) throws {
        precondition("Attempted to delete from entity of type '\(logger.typeName(Object.self))'")
        
        try context.delete(request)
    }
    
    /// A request to do a batch delete of data in a persistent store without loading any data into memory.
    /// - Parameter request: A `CKFetch` request indicating the entity type and clauses.
    /// - Returns: Type of `CKResult`. It can be `Int` for count, `Bool` for status or an array of `CKObjectId` indicating Ids for deleted objects.
    func batchDelete<Result: CKResult>(_ request: CKBatchDelete<Result>) throws -> Result.CKType {
        precondition("Attempted to delete from entity of type '\(request.type)'")
        
        let result = try context.batchDelete(request)
        return result.result as! Result.CKType
    }
}

// MARK: FETCH METHODS
extension CKBaseOperation: FetchClause {
    
    public func fetch<Object>(_ request: CKFetch<Object>) throws -> [Object] where Object : CKObject {
        precondition("Attempted to fetch from a \(logger.typeName(Object.self))")
        
        return try context.fetch(request)
    }
    
    public func fetchFirst<Object>(_ request: CKFetch<Object>) throws -> Object? where Object : CKObject {
        precondition("Attempted to fetch from a \(String(reflecting: Object.self))")
        
        return try context.fetchFirst(request)
    }
    
    public func fetchExisting<Object>(_ object: Object) -> Object? where Object : CKObject {
        context.fetchExisting(object)
    }
    
    public func fetchExisting<Object>(with objectId: CKObjectId) -> Object? where Object : CKObject {
        context.fetchExisting(with: objectId)
    }
    
    public func fetchExisting<Object, S>(_ objects: S) -> [Object] where Object : CKObject, Object == S.Element, S : Sequence {
        context.fetchExisting(objects)
    }
    
    public func fetchExisting<Object, S>(_ objectIds: S) -> [Object] where Object : CKObject, S : Sequence, S.Element == CKObjectId {
        context.fetchExisting(objectIds)
    }
    
    public func fetchIds<Object>(_ request: CKFetch<Object>) throws -> [CKObjectId] where Object : CKObject {
        precondition("Attempted to fetch from a \(logger.typeName(Object.self))")
        
        return try context.fetchIds(request)
    }
    
    public func query<Object>(_ request: CKFetch<Object>) throws -> [NSDictionary] where Object : CKObject {
        precondition("Attempted to fetch from a \(String(reflecting: Object.self))")
        
        return try context.query(request)
    }
    
    public func count<Object>(for request: CKFetch<Object>) throws -> Int where Object : CKObject {
        precondition("Attempted to fetch from a \(logger.typeName(Object.self))")
        
        return try context.count(for: request)
    }
    
    public var unsafeContext: CKContext {
        context
    }
}

// MARK: LOGGING
private extension CKBaseOperation {
    
    func precondition(_ message: String, file: StaticString = #file, line: UInt = #line, function: StaticString = #function) {
//        dispatchPrecondition(condition: .onQueue(queue))
        
//        logger.assert(!isCommitted, message + committedCondition, file: file, line: line, function: function)
    }
}
