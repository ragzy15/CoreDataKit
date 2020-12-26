//
//  CoreDataKit.swift
//  CoreDataKit
//
//  Created by Raghav Ahuja on 18/10/19.
//  Copyright © 2019 Raghav Ahuja. All rights reserved.
//

import Foundation

public class CKManager {
    
    /// The default instance with database name being application's name.
    private static let `internalDefault` = CKManager()
    
    public class var `default`: CKManager {
        internalDefault
    }
    
    /// Core Data Stack associated with this instance.
    private let stack: CKStack
    
    /// Allows the `CoreDataKit` to log errors and other information in the debug console.
    public var isLoggingEnabled: Bool {
        get {
            logger.isEnabled
        } set {
            logger.isEnabled = newValue
        }
    }
    
    public let queue: DispatchQueue
    
    public let logger: CKLogger
    
    init(stack: CKStack, queue: DispatchQueue) {
        self.stack = stack
        self.queue = queue
        logger = CKLogger(isEnabled: true)
    }
    
    /// Intializes an instance of `CoreDataKit` with the given model name.
    /// - Parameter name: Core Data Model name.
    public init(model name: String) {
        stack = CKCoreDataStack(modelName: name)
        queue = DispatchQueue(label: "com.CoreDataKit.\(name)-context-thread", qos: .default, attributes: .concurrent, autoreleaseFrequency: .inherit, target: nil)
        logger = CKLogger(isEnabled: true)
//        stack.loadPersistentStores(block: nil)
    }
    
    public convenience init() {
        let databaseName = Bundle.main.infoDictionary?[kCFBundleNameKey as String] as? String ?? "Database"
        self.init(model: databaseName)
    }
    
    func getStack() -> CKStack {
        stack
    }
    
    public func newBackgroundContext() -> CKContext {
        stack.newBackgroundTask()
    }
    
    public func newMainThreadChildTask() -> CKContext {
        stack.newMainThreadChildTask()
    }
    
    public func newBackgroundThreadChildTask() -> CKContext {
        stack.newBackgroundThreadChildTask()
    }
}

// MARK: CORE SPOTLIGHT
extension CKManager: CKCoreSpotlight {
    
    @available(iOS 11.0, *)
    public func setCoreDataCoreSpotlightExporter(for exporter: ([CKStoreDescription], CKObjectModel) -> Void) {
        stack.setCoreDataCoreSpotlightExporter(for: exporter)
    }
}

// MARK: STORE DESCRIPTIONS
extension CKManager: CKStoreDescriptionMethods {
    
    public func addStoreDescriptions(_ descriptions: [CKStoreDescription]) {
        stack.addStoreDescriptions(descriptions)
    }
    
    public func addStoreDescriptions(_ descriptions: CKStoreDescription...) {
        stack.addStoreDescriptions(descriptions)
    }
    
    public func replaceStoreDescriptions(with descriptions: [CKStoreDescription]) {
        stack.replaceStoreDescriptions(with: descriptions)
    }
    
    public func replaceStoreDescriptions(with descriptions: CKStoreDescription...) {
        stack.replaceStoreDescriptions(with: descriptions)
    }
    
    public func loadPersistentStores(block: ((Result<CKStoreDescription, NSError>) -> Void)? = nil) {
        stack.loadPersistentStores(block: block)
    }
}

// MARK: DATABASE OPERATIONS
public extension CKManager {

    func performOnMain<T>(synchronous workItem: (CKSynchronousOperation) throws -> T) throws -> T {
        let operation = CKSynchronousOperation(context: stack.viewContext, queue: .main, logger: logger)
        
        let output: T

        do {
            output = try workItem(operation)
        }
        catch let error as NSError {
            throw error
        }
        if let error = operation.save().getError() {
            throw error as NSError
        }
        else {
            return output
        }
    }

    func perform<T>(synchronous workItem: (CKSynchronousOperation) throws -> T) throws -> T {
        let operation = CKSynchronousOperation(context: stack.newBackgroundTask(), queue: queue, logger: logger)

        return try operation.queue.sync {

            defer {
                withExtendedLifetime((self, operation), {})
            }

            let output: T

            do {
                output = try workItem(operation)
            }
            catch let error as NSError {
                throw error
            }
            if let error = operation.save().getError() {
                throw error as NSError
            }
            else {
                return output
            }
        }
    }
    
    func perform<T>(asynchronous workItem: @escaping (CKAsynchronousOperation) throws -> T, completion: @escaping (Result<T, NSError>) -> Void) {
        let operation = CKAsynchronousOperation(context: stack.newBackgroundTask(), queue: queue, logger: logger)

        operation.queue.async {

            let output: T

            do {
                output = try workItem(operation)
            }
            catch let error as NSError {
                DispatchQueue.main.async { completion(.failure(error)) }
                return
            }

            operation.save { (result) in
                defer {
                    withExtendedLifetime((self, operation), {})
                }

                switch result {
                case .success:
                    completion(.success(output))
                    
                case .failure(let error):
                    DispatchQueue.main.async { completion(.failure(error)) }
                }
            }
        }
    }
}

// MARK: FETCH CLAUSE
extension CKManager: FetchClause {
    
    public func fetch<Object>(_ request: CKFetch<Object>) throws -> [Object] where Object : CKObject {
        precondition()
        
        return try stack.viewContext.fetch(request)
    }
    
    public func fetchFirst<Object>(_ request: CKFetch<Object>) throws -> Object? where Object : CKObject {
        precondition()
        
        return try stack.viewContext.fetchFirst(request)
    }
    
    public func fetchExisting<Object>(_ object: Object) -> Object? where Object : CKObject {
        stack.viewContext.fetchExisting(object)
    }
    
    public func fetchExisting<Object>(with objectId: CKObjectId) -> Object? where Object : CKObject {
        stack.viewContext.fetchExisting(with: objectId)
    }
    
    public func fetchExisting<Object, S>(_ objects: S) -> [Object] where Object : CKObject, Object == S.Element, S : Sequence {
        stack.viewContext.fetchExisting(objects)
    }
    
    public func fetchExisting<Object, S>(_ objectIds: S) -> [Object] where Object : CKObject, S : Sequence, S.Element == CKObjectId {
        stack.viewContext.fetchExisting(objectIds)
    }
    
    public func fetchIds<Object>(_ request: CKFetch<Object>) throws -> [CKObjectId] where Object : CKObject {
        precondition()
        
        return try stack.viewContext.fetchIds(request)
    }
    
    public func query<Object>(_ request: CKFetch<Object>) throws -> [NSDictionary] where Object : CKObject {
        precondition()
        
        return try stack.viewContext.query(request)
    }
    
    public func count<Object>(for request: CKFetch<Object>) throws -> Int where Object : CKObject {
        precondition()
        
        return try stack.viewContext.count(for: request)
    }
    
    public var unsafeContext: CKContext {
        stack.viewContext
    }
}

// MARK: LOGGING
private extension CKManager {
    
    func precondition(file: StaticString = #file, line: UInt = #line, function: StaticString = #function) {
//        dispatchPrecondition(condition: DispatchPredicate.onQueue(.main))
        logger.assert(
            Thread.isMainThread,
            "Attempted to fetch using \(function) outside the main thread.",
            file: file,
            line: line,
            function: function
        )
    }
}

// MARK: ASYNCHRONOUS FETCH CLAUSE
extension CKManager: AsynchronousFetchClause {
    
    public func fetch<Object>(_ request: CKFetch<Object>, completion: @escaping (Result<[Object], NSError>) -> Void) where Object : CKObject {
        precondition()
        
        stack.viewContext.fetch(request, completion: completion)
    }
    
    public func fetchFirst<Object>(_ request: CKFetch<Object>, completion: @escaping (Result<Object, NSError>) -> Void) where Object : CKObject {
        precondition()
        
        stack.viewContext.fetchFirst(request, completion: completion)
    }
    
    public func fetchExisting<Object>(_ object: Object, completion: @escaping (Result<Object, NSError>) -> Void) where Object : CKObject {
        precondition()
        
        stack.viewContext.fetchExisting(object, completion: completion)
    }
    
    public func fetchExisting<Object>(with objectId: CKObjectId, completion: @escaping (Result<Object, NSError>) -> Void) where Object : CKObject {
        precondition()
        
        stack.viewContext.fetchExisting(with: objectId, completion: completion)
    }
    
    public func fetchExisting<Object, S>(_ objects: S, completion: @escaping (Result<[Object], NSError>) -> Void) where Object : CKObject, Object == S.Element, S : Sequence {
        precondition()
        
        stack.viewContext.fetchExisting(objects, completion: completion)
    }
    
    public func fetchExisting<Object, S>(_ objectIds: S, completion: @escaping (Result<[Object], NSError>) -> Void) where Object : CKObject, S : Sequence, S.Element == CKObjectId {
        precondition()
        
        stack.viewContext.fetchExisting(objectIds, completion:  completion)
    }
    
    public func fetchIds<Object>(_ request: CKFetch<Object>, completion: @escaping (Result<[CKObjectId], NSError>) -> Void) where Object : CKObject {
        precondition()
        
        stack.viewContext.fetchIds(request, completion: completion)
    }
    
    public func query<Object>(_ request: CKFetch<Object>, completion: @escaping (Result<[NSDictionary], NSError>) -> Void) where Object : CKObject {
        precondition()
        
        stack.viewContext.query(request, completion: completion)
    }
    
    public func count<Object>(for request: CKFetch<Object>, completion: @escaping (Result<Int, NSError>) -> Void) where Object : CKObject {
        precondition()
        
        stack.viewContext.count(for: request, completion: completion)
    }
}
