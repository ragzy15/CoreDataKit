//
//  Aliases.swift
//  CoreDataKit
//
//  Created by Raghav Ahuja on 18/10/19.
//  Copyright © 2019 Raghav Ahuja. All rights reserved.
//

import CoreData

public typealias CKContainer = NSPersistentContainer

@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
public typealias CKCloudContainer = NSPersistentCloudKitContainer

public typealias CKCloudSchemaInitializationOptions = NSPersistentCloudKitContainerSchemaInitializationOptions

public typealias CKStoreDescription = NSPersistentStoreDescription

public typealias CKObjectModel = NSManagedObjectModel

public typealias CKCoordinator = NSPersistentStoreCoordinator


public typealias CKObject = NSManagedObject

public typealias CKObjectId = NSManagedObjectID

public typealias CKContext = NSManagedObjectContext


public typealias AsynchronousFetchRequest<Result: CKFetchResult> = NSAsynchronousFetchRequest<Result>

public typealias AsynchronousFetchResult<Result: CKFetchResult> = NSAsynchronousFetchResult<Result>


public typealias NSFetchRequest<Result: CKFetchResult> = CoreData.NSFetchRequest<Result>

public typealias CKFetchRequestResultType = NSFetchRequestResultType

public typealias CKFetchResult = NSFetchRequestResult


public typealias CKBatchDeleteRequest = NSBatchDeleteRequest

public typealias CKBatchDeleteResultType = NSBatchDeleteRequestResultType

public typealias CKBatchDeleteResult = NSBatchDeleteResult


public typealias CKBatchUpdates = [AnyHashable : Any]

public typealias CKKeyPathBatchUpdates<Object: CKObject> = [PartialKeyPath<Object>: Any]

public typealias CKBatchUpdateRequest = NSBatchUpdateRequest

public typealias CKBatchUpdateResultType = NSBatchUpdateRequestResultType

public typealias CKBatchUpdateResult = NSBatchUpdateResult


@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
public typealias CKBatchInserts = [[String : Any]]

@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
public typealias CKBatchInsertRequest = NSBatchInsertRequest

@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
public typealias CKBatchInsertResultType = NSBatchInsertRequestResultType

@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
public typealias CKBatchInsertResult = NSBatchInsertResult


public typealias NSPredicate = CoreData.NSPredicate

public typealias CKFetchedResultsController<ResultType: CKFetchResult> = NSFetchedResultsController<ResultType>

/// Constants that define merge policy types.
public typealias CKMergePolicyType = NSMergePolicyType

/// A policy object that you use to resolve conflicts between the persistent store and in-memory versions of managed objects.
///
///A conflict is a mismatch between state held at two different layers in the Core Data stack. A conflict can arise when you save a managed object context and you have stale data at another layer. There are two places in which a conflict may occur:
/// * Between the managed object context layer and its in-memory cached state at the persistent store coordinator layer.
/// * Between the cached state at the persistent store coordinator and the external store (file, database, and so forth).
///
/// Conflicts are represented by instances of [NSMergeConflict](apple-reference-documentation://hstmK0FPJu).
public typealias CKMergePolicy = NSMergePolicy

public typealias CKSortDescriptor = NSSortDescriptor

public typealias CKEntityDescription = NSEntityDescription


@available(iOS 11.0, *)
public typealias CKCoreDataCoreSpotlightDelegate = NSCoreDataCoreSpotlightDelegate
