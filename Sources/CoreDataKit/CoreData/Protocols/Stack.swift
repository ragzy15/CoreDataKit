//
//  Stack.swift
//  CoreDataKit
//
//  Created by Raghav Ahuja on 06/01/20.
//  Copyright © 2019 Raghav Ahuja. All rights reserved.
//

import Foundation

protocol CKStack: CKStoreDescriptionMethods, CKCoreSpotlight {
    
    typealias _Container = CKContainer & CKContainerType
    
    var viewContext: CKContext { get }
    
    func performBackgroundTask(_ block: @escaping (CKContext) -> Void)
    
    func newBackgroundTask() -> CKContext
    
    func newMainThreadChildTask() -> CKContext
    
    func newBackgroundThreadChildTask() -> CKContext
    
    func getPersistentContainer() -> _Container
}
