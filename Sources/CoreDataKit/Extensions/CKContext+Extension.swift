//
//  CKContext+Extension.swift
//  CoreDataKit
//
//  Created by Raghav Ahuja on 18/10/19.
//  Copyright © 2019 Raghav Ahuja. All rights reserved.
//

import Foundation

// MARK: ASYNCHRONOUS FETCH
extension CKContext: AsynchronousFetchClause {
    
    public func fetch<Object>(_ request: CKFetch<Object>, completion: @escaping (Result<[Object], NSError>) -> Void) where Object : CKObject {
        
        let fetchRequest = request.format(to: Object.self)
        
        var nsError: NSError?
        
        let asyncFetchRequest = AsynchronousFetchRequest<Object>(fetchRequest: fetchRequest) { (result) in
            if let error = nsError {
                completion(.failure(error))
            } else if let finalResult = result.finalResult {
                completion(.success(finalResult))
            }
        }
        
        do {
            try execute(asyncFetchRequest)
        } catch {
            nsError = error as NSError?
        }
    }
    
    public func fetchFirst<Object>(_ request: CKFetch<Object>, completion: @escaping (Result<Object, NSError>) -> Void) where Object : CKObject {
        
        request.fetchRequest.fetchLimit = 1
        fetch(request) { (result) in
            do {
                if let object = try result.get().first {
                    completion(.success(object))
                }
            } catch {
                completion(.failure(error as NSError))
            }
        }
    }
    
    public func fetchExisting<Object>(_ object: Object, completion: @escaping (Result<Object, NSError>) -> Void) where Object : CKObject {

        if object.objectID.isTemporaryID {
            do {
                try withExtendedLifetime(self) { (context: CKContext) -> Void in
                    try context.obtainPermanentIDs(for: [object])
                }
            }
            catch {
                completion(.failure(error as NSError))
                return
            }
        }

        do {
            let existingObject = try self.existingObject(with: object.objectID) as! Object
            if existingObject === object {
                completion(.success(object))
            } else {
                completion(.success(existingObject))
            }
        } catch {
            completion(.failure(error as NSError))
        }
    }
    
    public func fetchExisting<Object>(with objectId: CKObjectId, completion: @escaping (Result<Object, NSError>) -> Void) where Object : CKObject {
        
        do {
            let object = try existingObject(with: objectId) as! Object
            completion(.success(object))
        } catch {
            completion(.failure(error as NSError))
        }
    }
    
    public func fetchExisting<Object, S>(_ objects: S, completion: @escaping (Result<[Object], NSError>) -> Void) where Object : CKObject, Object == S.Element, S : Sequence {
        
        let objects = fetchExisting(objects)
        completion(.success(objects))
    }
    
    public func fetchExisting<Object, S>(_ objectIds: S, completion: @escaping (Result<[Object], NSError>) -> Void) where Object : CKObject, S : Sequence, S.Element == CKObjectId {
        
        let objects: [Object] = fetchExisting(objectIds)
        completion(.success(objects))
    }
    
    public func fetchIds<Object>(_ request: CKFetch<Object>, completion: @escaping (Result<[CKObjectId], NSError>) -> Void) where Object : CKObject {
        
        let fetchRequest = request.format(to: CKObjectId.self)
        
        var nsError: NSError?
        
        let asyncFetchRequest = AsynchronousFetchRequest<CKObjectId>(fetchRequest: fetchRequest) { (result) in
            if let error = nsError {
                completion(.failure(error as NSError))
            } else if let finalResult = result.finalResult {
                completion(.success(finalResult))
            }
        }
        
        do {
            try execute(asyncFetchRequest)
        } catch {
            nsError = error as NSError?
        }
    }
    
    public func query<Object>(_ request: CKFetch<Object>, completion: @escaping (Result<[NSDictionary], NSError>) -> Void) where Object : CKObject {
        
        let fetchRequest = request.format(to: NSDictionary.self)
        
        var nsError: NSError?
        
        let asyncFetchRequest = AsynchronousFetchRequest<NSDictionary>(fetchRequest: fetchRequest) { (result) in
            if let error = nsError {
                completion(.failure(error as NSError))
            } else if let finalResult = result.finalResult {
                completion(.success(finalResult))
            }
        }
        
        do {
            try execute(asyncFetchRequest)
        } catch {
            nsError = error as NSError?
        }
    }
    
    public func count<Object>(for request: CKFetch<Object>, completion: @escaping (Result<Int, NSError>) -> Void) where Object : CKObject {
        
        do {
            let countValue = try count(for: request)
            completion(.success(countValue))
        } catch {
            completion(.failure(error as NSError))
        }
    }
}

// MARK: SYNCHRONOUS FETCH
extension CKContext: FetchClause {
    
    public func fetch<Object>(_ request: CKFetch<Object>) throws -> [Object] where Object : CKObject {
        
        let fetchRequest = request.format(to: Object.self)
        
        var objects: [Object] = []
        var error: NSError?
        
        performAndWait {
            do {
                objects = try fetch(fetchRequest)
            } catch let fetchError as NSError {
                error = fetchError
            }
        }
        
        if let fetchError = error {
            throw fetchError
        } else {
            return objects
        }
    }
    
    public func fetchFirst<Object>(_ request: CKFetch<Object>) throws -> Object? where Object : CKObject {
        
        let objects = try fetch(request)
        return objects.first
    }
    
    public func fetchExisting<Object>(with objectId: CKObjectId) -> Object? where Object : CKObject {
        
        do {
            let object = try existingObject(with: objectId) as! Object
            return object
        } catch {
            return nil
        }
    }
    
    public func fetchExisting<Object>(_ object: Object) -> Object? where Object : CKObject {
        
        if object.objectID.isTemporaryID {
            do {
                try withExtendedLifetime(self) { (context: CKContext) -> Void in
                    try context.obtainPermanentIDs(for: [object])
                }
            }
            catch {
                return nil
            }
        }
        do {
            let existingObject = try self.existingObject(with: object.objectID) as! Object
            if existingObject === object {
                return object
            }
            return existingObject
        }
        catch {
            return nil
        }
    }
    
    public func fetchExisting<Object, S>(_ objects: S) -> [Object] where Object : CKObject, Object == S.Element, S : Sequence {
        
        objects.compactMap { fetchExisting($0) }
    }
    
    public func fetchExisting<Object, S>(_ objectIds: S) -> [Object] where Object : CKObject, S : Sequence, S.Element == CKObjectId {
        
        objectIds.compactMap { fetchExisting(with: $0) }
    }
    
    public func fetchIds<Object>(_ request: CKFetch<Object>) throws -> [CKObjectId] where Object : CKObject {
        
        let fetchRequest = request.format(to: CKObjectId.self)
        
        var objectIds: [CKObjectId] = []
        var error: NSError?
        
        performAndWait {
            do {
                objectIds = try fetch(fetchRequest)
            } catch let fetchError as NSError {
                error = fetchError
            }
        }
        
        if let fetchError = error {
            throw fetchError
        } else {
            return objectIds
        }
    }
    
    public func query<Object>(_ request: CKFetch<Object>) throws -> [NSDictionary] where Object : CKObject {
        
        let fetchRequest = request.format(to: NSDictionary.self)
        
        var dictionary: [NSDictionary] = []
        var error: NSError?
        
        performAndWait {
            do {
                dictionary = try fetch(fetchRequest)
            } catch let fetchError as NSError {
                error = fetchError
            }
        }
        
        if let fetchError = error {
            throw fetchError
        } else {
            return dictionary
        }
    }
    
    public func count<Object>(for request: CKFetch<Object>) throws -> Int where Object : CKObject {
        
        let fetchRequest = request.format(to: NSNumber.self)
        
        var count: Int = 0
        var error: NSError?
        
        performAndWait {
            do {
                count = try self.count(for: fetchRequest)
            } catch let fetchError as NSError {
                error = fetchError
            }
        }
        
        if let fetchError = error {
            throw fetchError
        } else if count == NSNotFound {
            let error = NSError(domain: NSCocoaErrorDomain, code: NSNotFound, userInfo: [NSLocalizedDescriptionKey: "Cannot calculate count for the given `CKFetch` request."])
            throw error
        } else {
            return count
        }
    }
    
    public var unsafeContext: CKContext {
        self
    }
}

// MARK: BATCH UPDATE
extension CKContext {
    
    public func batchUpdate<Object, Result>(_ request: CKBatchUpdate<Object, Result>) throws -> CKBatchUpdateResult where Object : CKObject, Result: CKResult {
        
        let batchUpdateRequest = request.batchUpdateRequest
        batchUpdateRequest.resultType = Result.ckResultType.batchUpdate
        
        var result: CKBatchUpdateResult?
        var error: NSError?
        
        performAndWait {
            do {
                result = try execute(batchUpdateRequest) as? CKBatchUpdateResult
                
            } catch let fetchError as NSError {
                error = fetchError
            }
        }
        
        if let updateResult = result {
            return updateResult
        } else if let fetchError = error {
            throw fetchError
        } else {
            throw NSError(domain: NSError.errorDomain, code: 101, userInfo: nil)
        }
    }
}

// MARK: DELETE
extension CKContext {
    
    public func delete<Object>(_ request: CKFetch<Object>) throws where Object : CKObject {
        
        let fetchRequest = request.format(to: Object.self)
        
        fetchRequest.returnsObjectsAsFaults = true
        fetchRequest.includesPropertyValues = false
        
        var error: NSError?
        
        performAndWait {
            do {
                let objects = try fetch(fetchRequest)
                objects.forEach { delete($0) }
                
            } catch let fetchError as NSError {
                error = fetchError
            }
        }
        
        if let fetchError = error {
            throw fetchError
        }
    }
    
    // MARK: BATCH DELETE
    
    public func batchDelete<Result>(_ request: CKBatchDelete<Result>) throws -> CKBatchDeleteResult where Result : CKResult {
        
        let batchDeleteRequest = request.batchDeleteRequest
        batchDeleteRequest.resultType = Result.ckResultType.batchDelete
        
        shouldDeleteInaccessibleFaults = true
        
        var result: CKBatchDeleteResult?
        var error: NSError?
        
        performAndWait {
            do {
                result = try execute(batchDeleteRequest) as? CKBatchDeleteResult
                
            } catch let fetchError as NSError {
                error = fetchError
            }
        }
        
        if let deleteResult = result {
            return deleteResult
        } else if let fetchError = error {
            throw fetchError
        } else {
            throw NSError(domain: NSError.errorDomain, code: 101, userInfo: nil)
        }
    }
}

// MARK: BATCH INSERT
extension CKContext {

    @available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
    public func batchInsert<Object: CKObject, Result: CKResult>(_ object: CKBatchInsert<Object, Result>) throws -> CKBatchInsertResult {
        
        let batchInsertRequest = object.batchInsertRequest
        batchInsertRequest.resultType = Result.ckResultType.batchInsertValue()
        
        var result: CKBatchInsertResult?
        var error: NSError?
        
        performAndWait {
            do {
                result = try execute(batchInsertRequest) as? CKBatchInsertResult
                
            } catch let fetchError as NSError {
                error = fetchError
            }
        }
        
        if let insertResult = result {
            return insertResult
        } else if let fetchError = error {
            throw fetchError
        } else {
            throw NSError(domain: NSError.errorDomain, code: 101, userInfo: nil)
        }
    }
}

// MARK: SAVING
extension CKContext {
    
    func saveContextAsync(completion: @escaping (Result<Bool, NSError>) -> Void) {
        
        guard hasChanges else {
            completion(.success(false))
            return
        }
        
        perform {
            do {
                try self.save()
                
                if let parent = self.parent {
                    parent.saveContextAsync(completion: completion)
                } else {
                    completion(.success(true))
                }
            } catch {
                completion(.failure(error as NSError))
            }
        }
    }
    
    
    func saveContextSync() -> Result<Void, NSError> {
        
        var result: Result<Void, NSError> = .success(())
        
        guard hasChanges else {
            return result
        }
        
        performAndWait {
            do {
                try self.save()
                
                if let parent = self.parent {
                    result = parent.saveContextSync()
                } else {
                    result = .success(())
                }
            } catch {
                result = .failure(error as NSError)
            }
        }
        
        return result
    }
}
