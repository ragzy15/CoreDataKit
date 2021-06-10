//
//  Container Type.swift
//  CoreDataKit
//
//  Created by Raghav Ahuja on 06/01/20.
//  Copyright © 2019 Raghav Ahuja. All rights reserved.
//

import Foundation

protocol CKContainerType: AnyObject {
    init(with name: String)
    func updateContexts()
}
