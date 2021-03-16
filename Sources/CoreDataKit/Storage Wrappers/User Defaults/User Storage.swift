//
//  User Storage.swift
//  CoreDataKit
//
//  Created by Raghav Ahuja on 18/10/19.
//  Copyright © 2019 Raghav Ahuja. All rights reserved.
//

import Foundation

@propertyWrapper
public struct UserStorage<Value> {
    
    private let key: String
    private var value: Value
    private let store: CKUserDefaults?
    
    private var userDefaults: CKUserDefaults {
        store ?? .standard
    }
    
    public init<Key: StorageKeys>(key k: Key, initialValue v: Value, store: CKUserDefaults? = nil) {
        key = k.key
        value = v
        self.store = store
    }
    
    public init(key k: String, initialValue v: Value, store: CKUserDefaults? = nil) {
        key = k
        value = v
        self.store = store
    }
    
    public var wrappedValue: Value {
        get {
            userDefaults.value(forKey: key) as? Value ?? value
        }
        set {
            userDefaults.set(newValue, forKey: key)
            value = newValue
        }
    }
    
    public func delete() {
        userDefaults.removeObject(forKey: key)
    }
}
