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
    
    /// Create exporter by subclassing `CKCoreDataCoreSpotlightDelegate`, and call `setOption(exporter, forKey: NSCoreDataCoreSpotlightExporter)`
    @available(iOS 11.0, *)
    func setCoreDataCoreSpotlightExporter(for exporter: ([CKStoreDescription], CKObjectModel) -> Void)
    
    @available(iOS 13.0, *)
    func setCoreDataCoreSpotlightExporter(for exporter: ([CKStoreDescription], CKCoordinator) -> Void)
}
