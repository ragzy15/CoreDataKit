//
//  Keychain Storage.swift
//  CoreDatabase
//
//  Created by Raghav Ahuja on 08/11/19.
//  Copyright © 2019 Raghav Ahuja. All rights reserved.
//

import Foundation

@propertyWrapper
public struct KeychainStorage<Value: Queryable> {
    
    private let key: StorageKeys
    private var value: Value
    
    public init(key initialKey: StorageKeys, initialValue: Value) {
        key = initialKey
        value = initialValue
    }
    
    public var wrappedValue: Value {
        get {
            guard let data = Keychain.standard.data(for: key.value) else {
                return value
            }
            
            let unarchiveObject = try? NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(data)
            
            return unarchiveObject as? Value ?? value
        }
        set {
            guard let data = newValue.data else {
                print("Cannot save value for key: \(key.value) due to `data` value being nil")
                return
            }
            
            guard Keychain.standard.set(data, for: key.value) else {
                print("Could not save value for key: \(key.value) in keychain.")
                return
            }
            
            value = newValue
        }
    }
    
    public func delete() {
        Keychain.standard.removeObject(for: key.value)
    }
}
