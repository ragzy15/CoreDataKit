//
//  Fetch.swift
//  CoreDataKit
//
//  Created by Raghav Ahuja on 18/10/19.
//  Copyright © 2019 Raghav Ahuja. All rights reserved.
//

import Foundation

public final class CKFetch<Object: CKObject> {
    
    public let fetchRequest: NSFetchRequest<CKFetchResult>
    
    /// Creates a default `NSFetchRequest` for the given `CKObject`.`
    public init() {
        fetchRequest = Object.self.fetchRequest()
    }
}

extension CKFetch {
    
    // MARK: FETCH BATCH SIZE CLAUSE
    
    /// The batch size of the objects specified in the fetch request.
    ///
    /// The default value is 0. A batch size of 0 is treated as infinite, which disables the batch faulting behavior.
    ///
    /// If you set a nonzero batch size, the collection of objects returned when an instance of NSFetchRequest is executed is broken into batches. When the fetch is executed, the entire request is evaluated and the identities of all matching objects recorded, but only data for objects up to the batchSize will be fetched from the persistent store at a time. The array returned from executing the request is a proxy object that transparently faults batches on demand. (In database terms, this is an in-memory cursor.)
    ///
    /// You can use this feature to restrict the working set of data in your application. In combination with fetchLimit, you can create a subrange of an arbitrary result set.
    ///
    /// - Parameter fetchBatchSize: The batch size of the objects specified in the fetch request.
    public func batchSize(_ fetchBatchSize: Int) -> Self {
        fetchRequest.fetchBatchSize = fetchBatchSize
        return self
    }
    
    // MARK: FETCH LIMIT CLAUSE
    
    /// The fetch limit of the fetch request.
    ///
    /// The fetch limit specifies the maximum number of objects that a request should return when executed.
    ///
    /// If you set a fetch limit, the framework makes a best effort to improve efficiency, but does not guarantee it. For every object store except the SQL store, a fetch request executed with a fetch limit in effect simply performs an unlimited fetch and throws away the unasked for rows.
    ///
    /// - Parameter fetchLimit: The fetch limit of the fetch request.
    public func limit(_ fetchLimit: Int) -> Self {
        fetchRequest.fetchLimit = fetchLimit
        return self
    }
}

// MARK: CUSTOMISE CLAUSE
extension CKFetch {
    
    /// Customise `NSFetchRequest`.
    /// - Parameter requestBlock: The block to customize the `NSFetchRequest`.
    public func customise(_ requestBlock: (NSFetchRequest<CKFetchResult>) -> Void) -> Self {
        requestBlock(fetchRequest)
        return self
    }
}

// MARK: ORDER BY CLAUSE
extension CKFetch {
    
    /// `OrderBy` clause to create a `FetchRequest` with.
    /// - Parameter sortKeys: Array of `OrderBy` clauses with KeyPath.
    public func orderBy<Value>(_ sortKeys: OrderBy<Object, Value>...) -> Self {
        fetchRequest.sortDescriptors = sortKeys.map { $0.descriptor }
        return self
    }
    
    /// `OrderBy` clause to create a `FetchRequest` with.
    /// - Parameter sortKeys: Array of `OrderBy` clauses with KeyPath.
    public func orderBy<Value>(_ sortKeys: [OrderBy<Object, Value>]) -> Self {
        fetchRequest.sortDescriptors = sortKeys.map { $0.descriptor }
        return self
    }
    
    /// The sort descriptors of the fetch request.
    ///
    /// The sort descriptors specify how the objects returned when the FetchRequest is issued should be ordered—for example, by last name and then by first name. The sort descriptors are applied in the order in which they appear in the sortDescriptors array (serially in lowest-array-index-first order).
    ///
    /// A value of nil is treated as no sort descriptors.
    ///
    /// - Parameter sortDescriptors: The sort descriptors of the fetch request.
    public func orderBy(sortDescriptors: NSSortDescriptor...) -> Self {
        fetchRequest.sortDescriptors = sortDescriptors.map { $0 }
        return self
    }
    
    /// The sort descriptors of the fetch request.
    ///
    /// The sort descriptors specify how the objects returned when the FetchRequest is issued should be ordered—for example, by last name and then by first name. The sort descriptors are applied in the order in which they appear in the sortDescriptors array (serially in lowest-array-index-first order).
    ///
    /// A value of nil is treated as no sort descriptors.
    ///
    /// - Parameter sortDescriptors: The sort descriptors of the fetch request.
    public func orderBy(sortDescriptors: [NSSortDescriptor]) -> Self {
        fetchRequest.sortDescriptors = sortDescriptors
        return self
    }
}

// MARK: WHERE CLAUSE
extension CKFetch {
    
    /// Initializes a predicate by substituting the values in a given array into a format string and parsing the result.
    /// - Parameter format: The format string for the new predicate.
    /// - Parameter args: The arguments to substitute into predicateFormat. Values are substituted in the order they appear in the array.
    public func `where`(_ format: String, args: CVarArg...) -> Self {
        let predicate = NSPredicate(format: format, args)
        fetchRequest.predicate = predicate
        return self
    }
    
    /// Creates and returns a predicate that always evaluates to a given Boolean value.
    /// - Parameter value: The Boolean value to which the new predicate should evaluate.
    public func `where`(_ value: Bool) -> Self {
        let predicate = NSPredicate(value: value)
        fetchRequest.predicate = predicate
        return self
    }
    
    /// Initializes a predicate by substituting the values in a given array into a format string and parsing the result.
    /// - Parameter format: The format string for the new predicate.
    /// - Parameter args: The arguments to substitute into predicateFormat. Values are substituted in the order they appear in the array.
    public func `where`(_ format: String, argumentArray: [Any]?) -> Self {
        let predicate = NSPredicate(format: format, argumentArray: argumentArray)
        fetchRequest.predicate = predicate
        return self
    }
    
    /// The predicate of the fetch request.
    /// - Parameter predicate: The predicate instance constrains the selection of objects the `FetchRequest` instance is to fetch.
    public func `where`(_ predicate: NSPredicate?) -> Self {
        fetchRequest.predicate = predicate
        return self
    }
    
    /// The predicate of the fetch request.
    /// - Parameter clause: `CKPredicate` clause to create a `FetchRequest` with.
    public func `where`(_ clause: CKPredicate<Object>) -> Self {
        fetchRequest.predicate = clause.predicate
        return self
    }
}

// MARK: FETCH PROPERTIES CLAUSE
extension CKFetch {
    
    /// A collection of either property descriptions or string property names that specify which properties should be returned by the fetch.
    ///
    /// Property descriptions can either be instances of NSPropertyDescription or NSString. The property descriptions may represent attributes, to-one relationships, or expressions. The name of an attribute or relationship description must match the name of a description on the fetch request’s entity.
    /// - Parameter propertiesToFetch: A collection of either property descriptions or string property names that specify which properties should be returned by the fetch.
    public func properties(_ propertiesToFetch: [Any]) -> Self {
        fetchRequest.propertiesToFetch = propertiesToFetch
        return self
    }
    
    /// A collection of either property descriptions or string property names that specify which properties should be returned by the fetch.
    ///
    /// Property descriptions can either be instances of NSPropertyDescription or NSString. The property descriptions may represent attributes, to-one relationships, or expressions. The name of an attribute or relationship description must match the name of a description on the fetch request’s entity.
    /// - Parameter propertiesToFetch: A collection of either property descriptions or string property names that specify which properties should be returned by the fetch.
    public func properties(_ propertiesToFetch: Any...) -> Self {
        fetchRequest.propertiesToFetch = propertiesToFetch.map { $0 }
        return self
    }
    
    /// A collection of either property descriptions or string property names that specify which properties should be returned by the fetch.
    ///
    /// Property descriptions can either be instances of NSPropertyDescription or NSString. The property descriptions may represent attributes, to-one relationships, or expressions. The name of an attribute or relationship description must match the name of a description on the fetch request’s entity.
    /// - Parameter propertiesToFetch: A collection of either property descriptions or string property names that specify which properties should be returned by the fetch.
    @discardableResult
    public func properties(_ propertiesToFetch: PartialKeyPath<Object>...) -> Self {
        let propertiesToFetch = propertiesToFetch.compactMap { $0._objcStringValue }
        fetchRequest.propertiesToFetch = propertiesToFetch
        return self
    }
    
    /// A collection of either property descriptions or string property names that specify which properties should be returned by the fetch.
    ///
    /// Property descriptions can either be instances of NSPropertyDescription or NSString. The property descriptions may represent attributes, to-one relationships, or expressions. The name of an attribute or relationship description must match the name of a description on the fetch request’s entity.
    /// - Parameter propertiesToFetch: A collection of either property descriptions or string property names that specify which properties should be returned by the fetch.
    public func properties(_ propertiesToFetch: [PartialKeyPath<Object>]) -> Self {
        let propertiesToFetch = propertiesToFetch.compactMap { $0._objcStringValue }
        fetchRequest.propertiesToFetch = propertiesToFetch
        return self
    }
}

// MARK: GROUP BY CLAUSE
extension CKFetch {
    
    /// Returns / sets if the fetch request returns only distinct values for the fields specified by `properties`. This value is only used for NSDictionaryResultType. Defaults to NO.
    /// - Parameter value: Boolean value to return distinct results.
    func returnsDistinctResults(_ value: Bool) -> Self {
        fetchRequest.returnsDistinctResults = value
        return self
    }
    
    
    /// Returns/sets the result type of the fetch request (the instance type of objects returned from executing the request.) Setting the value to `managedObjectIDResultType` will demote any sort orderings to "best effort" hints if property values are not included in the request.  Defaults to `managedObjectResultType`.
    /// - Parameter type: Result type of the fetch request.
    private func resultType(_ type: CKFetchRequestResultType) -> Self {
        fetchRequest.resultType = type
        return self
    }
    
    /// An array of objects that indicates how data should be grouped before a select statement is run in a SQL database.
    ///
    /// An array of NSPropertyDescription or NSExpressionDescription objects or key-path strings that indicate how data should be grouped before a select statement is run in an SQL database.
    ///
    /// If you use this setting, you must set the resultType to dictionaryResultType, and the SELECT values must be literals, aggregates, or columns specified in propertiesToGroupBy.
    ///
    /// Aggregates will operate on the groups specified in propertiesToGroupBy rather than the whole table. If you set propertiesToGroupBy, you can also set a predicate to filter rows that are returned by propertiesToGroupBy.
    ///
    /// - Parameter propertiesToGroupBy: An array of objects that indicates how data should be grouped before a select statement is run in a SQL database.
    public func groupBy(_ propertiesToGroupBy: [Any]) -> Self {
        fetchRequest.propertiesToGroupBy = propertiesToGroupBy
        return self
    }
    
    /// An array of objects that indicates how data should be grouped before a select statement is run in a SQL database.
    ///
    /// An array of NSPropertyDescription or NSExpressionDescription objects or key-path strings that indicate how data should be grouped before a select statement is run in an SQL database.
    ///
    /// If you use this setting, you must set the resultType to dictionaryResultType, and the SELECT values must be literals, aggregates, or columns specified in propertiesToGroupBy.
    ///
    /// Aggregates will operate on the groups specified in propertiesToGroupBy rather than the whole table. If you set propertiesToGroupBy, you can also set a predicate to filter rows that are returned by propertiesToGroupBy.
    ///
    /// - Parameter propertiesToGroupBy: An array of objects that indicates how data should be grouped before a select statement is run in a SQL database.
    public func groupBy(_ propertiesToGroupBy: Any...) -> Self {
        fetchRequest.propertiesToGroupBy = propertiesToGroupBy
        return self
    }
    
    /// An array of objects that indicates how data should be grouped before a select statement is run in a SQL database.
    ///
    /// An array of NSPropertyDescription or NSExpressionDescription objects or key-path strings that indicate how data should be grouped before a select statement is run in an SQL database.
    ///
    /// If you use this setting, you must set the resultType to dictionaryResultType, and the SELECT values must be literals, aggregates, or columns specified in propertiesToGroupBy.
    ///
    /// Aggregates will operate on the groups specified in propertiesToGroupBy rather than the whole table. If you set propertiesToGroupBy, you can also set a predicate to filter rows that are returned by propertiesToGroupBy.
    ///
    /// - Parameter groupBy: An object that indicates how data should be grouped before a select statement is run in a SQL database.
    /// - Parameter propertiesToGroupBy: An array of objects that indicates how data should be grouped before a select statement is run in a SQL database.
    public func groupBy<Value>(_ groupBy: KeyPath<Object, Value>, _ propertiesToGroupBy: PartialKeyPath<Object>...) -> Self {
        let propertiesToGroupBy = ([groupBy] + propertiesToGroupBy).compactMap { $0.objcStringValue }
        fetchRequest.propertiesToGroupBy = propertiesToGroupBy
        return self
    }
    
    /// An array of objects that indicates how data should be grouped before a select statement is run in a SQL database.
    ///
    /// An array of NSPropertyDescription or NSExpressionDescription objects or key-path strings that indicate how data should be grouped before a select statement is run in an SQL database.
    ///
    /// If you use this setting, you must set the resultType to dictionaryResultType, and the SELECT values must be literals, aggregates, or columns specified in propertiesToGroupBy.
    ///
    /// Aggregates will operate on the groups specified in propertiesToGroupBy rather than the whole table. If you set propertiesToGroupBy, you can also set a predicate to filter rows that are returned by propertiesToGroupBy.
    ///
    /// - Parameter groupBy: An object that indicates how data should be grouped before a select statement is run in a SQL database.
    /// - Parameter propertiesToGroupBy: An array of objects that indicates how data should be grouped before a select statement is run in a SQL database.
    public func groupBy(_ propertiesToGroupBy: [PartialKeyPath<Object>]) -> Self {
        let propertiesToGroupBy = propertiesToGroupBy.compactMap { $0.objcStringValue }
        fetchRequest.propertiesToGroupBy = propertiesToGroupBy
        return self
    }
}

// MARK: HAVING CLAUSE
extension CKFetch {
    
    /// The predicate used to filter rows being returned by a query containing a `GROUP BY` directive.
    ///
    /// If a `havingPredicate` value is supplied, the predicate will be run after .Specifying a havingPredicate requires that propertiesToGroupBy also be specified.
    ///
    /// - Parameter format: The format string for the new predicate.
    /// - Parameter args: The arguments to substitute into predicateFormat. Values are substituted in the order they appear in the array.
    public func having(_ format: String, args: CVarArg...) -> Self {
        let predicate = NSPredicate(format: format, args)
        fetchRequest.havingPredicate = predicate
        return self
    }
    
    /// The predicate used to filter rows being returned by a query containing a `GROUP BY` directive.
    ///
    /// If a `havingPredicate` value is supplied, the predicate will be run after .Specifying a havingPredicate requires that propertiesToGroupBy also be specified.
    ///
    /// - Parameter value: The Boolean value to which the new predicate should evaluate.
    public func having(_ value: Bool) -> Self {
        let predicate = NSPredicate(value: value)
        fetchRequest.havingPredicate = predicate
        return self
    }
    
    /// The predicate used to filter rows being returned by a query containing a `GROUP BY` directive.
    ///
    /// If a `havingPredicate` value is supplied, the predicate will be run after .Specifying a havingPredicate requires that propertiesToGroupBy also be specified.
    ///
    /// - Parameter format: The format string for the new predicate.
    /// - Parameter argumentArray: The arguments to substitute into predicateFormat. Values are substituted in the order they appear in the array.
    public func having(_ format: String, argumentArray: [Any]?) -> Self {
        let predicate = NSPredicate(format: format, argumentArray: argumentArray)
        fetchRequest.havingPredicate = predicate
        return self
    }
    
    /// The predicate used to filter rows being returned by a query containing a `GROUP BY` directive.
    ///
    /// If a `havingPredicate` value is supplied, the predicate will be run after .Specifying a havingPredicate requires that propertiesToGroupBy also be specified.
    ///
    /// - Parameter predicate: The predicate instance constrains the selection of objects the `FetchRequest` instance is to fetch.
    public func having(_ predicate: NSPredicate) -> Self {
        fetchRequest.havingPredicate = predicate
        return self
    }
    
    /// The predicate used to filter rows being returned by a query containing a `GROUP BY` directive.
    ///
    /// If a `havingPredicate` value is supplied, the predicate will be run after .Specifying a havingPredicate requires that propertiesToGroupBy also be specified.
    ///
    /// - Parameter clause: `CKPredicate` clause to create a `FetchRequest` with.
    public func having(_ clause: CKPredicate<Object>) -> Self {
        fetchRequest.havingPredicate = clause.predicate
        return self
    }
}

extension CKFetch {
    
    public func format<Result: CKFetchResult>(to format: Result.Type) -> NSFetchRequest<Result> {
        
        switch format {
        case is NSNumber.Type:
            fetchRequest.resultType = .countResultType
            
        case is CKObject.Type:
            fetchRequest.resultType = .managedObjectResultType
            
        case is CKObjectId.Type:
            fetchRequest.resultType = .managedObjectIDResultType
            
        case is NSDictionary.Type:
            fetchRequest.resultType = .dictionaryResultType
            
        default:
            break
        }
        
        return fetchRequest as! NSFetchRequest<Result>
    }
}
