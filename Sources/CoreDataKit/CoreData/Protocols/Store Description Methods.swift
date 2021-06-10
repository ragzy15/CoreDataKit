//
//  Store Description Methods.swift
//  CoreDataKit
//
//  Created by Raghav Ahuja on 06/01/20.
//  Copyright © 2019 Raghav Ahuja. All rights reserved.
//

import Foundation

public protocol CKStoreDescriptionMethods: AnyObject {
    
    func addStoreDescriptions(_ descriptions: [CKStoreDescription])
    
    func addStoreDescriptions(_ descriptions: CKStoreDescription...)
    
    func replaceStoreDescriptions(with descriptions: [CKStoreDescription])
    
    func replaceStoreDescriptions(with descriptions: CKStoreDescription...)
    
    func loadPersistentStores(block: ((Result<CKStoreDescription, NSError>) -> Void)?)
}

public protocol CKCoreSpotlight: AnyObject {
    
#if os(iOS) || os(macOS)
    @available(iOS 11.0, macOS 10.13, *)
    typealias SpotlightIndexModelHandler = (CKStoreDescription?, CKObjectModel) -> CKCoreDataCoreSpotlightDelegate
    
    @available(iOS 13.0, macOS 10.15, *)
    typealias SpotlightIndexCoordinatorHandler = (CKStoreDescription?, CKCoordinator) -> CKCoreDataCoreSpotlightDelegate
    
    @available(iOS 11.0, macOS 10.13, *)
    var spotlightIndexer: CKCoreDataCoreSpotlightDelegate? { get }
    
    /// Create exporter by subclassing `CKCoreDataCoreSpotlightDelegate`, and call `setOption(exporter, forKey: NSCoreDataCoreSpotlightExporter)`
    @available(iOS 11.0, macOS 10.13, *)
    func setCoreDataIndexer(for exporter: SpotlightIndexModelHandler)
    
    @available(iOS 13.0, macOS 10.15, *)
    func setCoreDataIndexer(using exporter: SpotlightIndexCoordinatorHandler)
#endif
}
