//
//  Fetch Request.swift
//  CoreDataKit
//
//  Created by Raghav Ahuja on 06/01/20.
//  Copyright © 2019 Raghav Ahuja. All rights reserved.
//

import Foundation
import PublisherKit

@propertyWrapper
public struct CKFetchRequest<Result: CKFetchResult> {
    
    public var wrappedValue: CKFetchedResults<Result> {
        results
    }
    
    var results = CKFetchedResults<Result>(results: [])
    
    private let fetchRequest: FetchRequest<Result>
    
    /// Creates an instance by defining a fetch request based on the parameters.
    /// - Parameters:
    ///   - entity: The kind of modeled object to fetch.
    ///   - sortDescriptors: An array of sort descriptors defines the sort
    ///     order of the fetched results.
    ///   - predicate: An NSPredicate defines a filter for the fetched results.
    ///   - animation: The animation used for any changes to the fetched
    ///     results.
    public init(entity: CKEntityDescription, sortDescriptors: [CKSortDescriptor], predicate: NSPredicate? = nil) {
        fetchRequest = FetchRequest<Result>(entityName: entity.managedObjectClassName)
        fetchRequest.sortDescriptors = sortDescriptors
        fetchRequest.predicate = predicate
    }
    
    /// Creates an instance from a fetch request.
    /// - Parameters:
    ///   - fetchRequest: The request used to produce the fetched results.
    ///   - animation: The animation used for any changes to the fetched
    ///     results.
    public init<Object: CKObject>(fetchRequest: CKFetch<Object>) {
        self.fetchRequest = fetchRequest.format(to: Result.self)
    }
    
    /// Creates an instance from a fetch request.
    /// - Parameters:
    ///   - fetchRequest: The request used to produce the fetched results.
    public init(fetchRequest: FetchRequest<Result>) {
        self.fetchRequest = fetchRequest
    }
    
    public mutating func update() {
        let objects = try? CoreDataKit.default.unsafeContext.fetch(fetchRequest)
        results = .init(results: objects ?? [])
    }
}

extension CKFetchRequest where Result: CKObject {
    
    /// Creates an instance by defining a fetch request based on the parameters.
    /// The fetch request will automatically infer the entity using Result.entity().
    /// - Parameters:
    ///   - sortDescriptors: An array of sort descriptors defines the sort
    ///     order of the fetched results.
    ///   - predicate: An NSPredicate defines a filter for the fetched results.
    ///   - animation: The animation used for any changes to the fetched
    ///     results.
    public init(sortDescriptors: [CKSortDescriptor], predicate: NSPredicate? = nil) {
        fetchRequest = FetchRequest<Result>(entityName: Result.entity().managedObjectClassName)
        fetchRequest.sortDescriptors = sortDescriptors
        fetchRequest.predicate = predicate
    }
    
    public init(fetchRequest: (CKFetch<Result>) -> CKFetch<Result>) {
        let fetch = CKFetch<Result>()
        self.fetchRequest = fetchRequest(fetch).format(to: Result.self)
    }
}
//
//extension CKFetchRequest {
//    
//    class Inner<Downstream: NKSubscriber, Result: CKFetchResult>: NKSubscriber, NKSubscription where Downstream.Input == CKFetchedResults<Result>, Downstream.Failure == NSError {
//        
//        typealias Input = CKFetchedResults<Result>
//        
//        typealias Failure = NSError
//        
//        let downstream: Downstream
//        
//        init(downstream: Downstream) {
//            self.downstream = downstream
//        }
//        
//        func request(_ demand: NKSubscribers.Demand) {
//            
//        }
//        
//        func receive(subscription: NKSubscription) {
//            
//        }
//        
//        func receive(_ input: CKFetchedResults<Result>) -> NKSubscribers.Demand {
//            _ = downstream.receive(input)
//            return .unlimited
//        }
//        
//        func receive(completion: NKSubscribers.Completion<NSError>) {
//            downstream.receive(completion: completion)
//        }
//        
//        func cancel() {
//            
//        }
//    }
//    
//    public var publisher: Publisher<Result> {
//        Publisher(fetchRequest: fetchRequest)
//    }
//    
//    public struct Publisher<Result: CKFetchResult>: NKPublisher {
//        
//        public typealias Output = CKFetchedResults<Result>
//        
//        public typealias Failure = NSError
//        
//        let fetchRequest: FetchRequest<Result>
//        
//        public func receive<S: NKSubscriber>(subscriber: S) where Output == S.Input, Failure == S.Failure {
//            let subscription = Inner(downstream: subscriber)
//            subscriber.receive(subscription: subscription)
//            
//            do {
//                let objects = try CoreDataKit.default.unsafeContext.fetch(fetchRequest)
//                
//                _  = subscription.receive(.init(results: objects))
//                subscription.receive(completion: .finished)
//            } catch {
//                subscription.receive(completion: .failure(error as NSError))
//            }
//        }
//    }
//}


public struct CKFetchedResults<Result: CKFetchResult>: RandomAccessCollection {
    
    var results: [Result]
    
    public var startIndex: Int { results.startIndex }
    
    public var endIndex: Int { results.endIndex }
    
    public subscript(position: Int) -> Result { results[position] }
    
    public typealias Element = Result
    
    public typealias Index = Int
    
    public typealias SubSequence = Slice<CKFetchedResults<Result>>
    
    public typealias Indices = Range<Int>
    
    public typealias Iterator = IndexingIterator<CKFetchedResults<Result>>
}
