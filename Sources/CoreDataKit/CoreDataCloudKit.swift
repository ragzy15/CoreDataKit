//
//  CoreDataCloudKit.swift
//  CoreDataKit
//
//  Created by Raghav Ahuja on 06/01/20.
//  Copyright © 2019 Raghav Ahuja. All rights reserved.
//

import Foundation

@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
public final class CKCloudManager: CKManager {
    
    /// The default instance with database name being application's name.
    private static let `internalDefault` = CKCloudManager()
    
    /// The default instance with database name being application's name.
    public override class var `default`: CKCloudManager {
        internalDefault
    }
    
    private let stack: CKCoreDataCloudStack
    
    /// Intializes an instance of `CoreDataCloudKit` with the given model name.
    /// - Parameter name: Core Data Model name.
    public override init(model name: String) {
        let stack = CKCoreDataCloudStack(modelName: name)
        let queue = DispatchQueue(label: "com.CoreDataKit.cloud-contextQueue", qos: .default,
                              attributes: [], autoreleaseFrequency: .inherit, target: nil)
        self.stack = stack
        super.init(stack: stack, queue: queue)
    }
    
    public convenience init() {
        let databaseName = Bundle.main.infoDictionary?[kCFBundleNameKey as String] as? String ?? "Database"
        self.init(model: databaseName)
    }
    
    public func initializeCloudKitSchema(options: CKCloudSchemaInitializationOptions = []) throws {
        try stack.initializeCloudKitSchema(options: options)
    }
}
