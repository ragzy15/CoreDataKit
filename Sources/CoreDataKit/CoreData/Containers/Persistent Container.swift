//
//  Persistent Container.swift
//  CoreDataKit
//
//  Created by Raghav Ahuja on 06/01/20.
//  Copyright © 2019 Raghav Ahuja. All rights reserved.
//

import Foundation

final class CKPersistentContainer: CKContainer, CKContainerType {
    
    convenience init(with name: String) {
        self.init(name: name)
    }
    
    func updateContexts() {
        if #available(iOS 11.0, macOS 10.13, tvOS 11.0, *) {
            viewContext.transactionAuthor = "main_app"
            viewContext.name = "view_context"
        }
        
        viewContext.automaticallyMergesChangesFromParent = true
    }
}
