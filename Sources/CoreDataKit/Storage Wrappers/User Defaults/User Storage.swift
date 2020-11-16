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
    
    public init<Key: StorageKeys>(key k: Key, initialValue v: Value) {
        key = k.key
        value = v
    }
    
    public init(key k: String, initialValue v: Value) {
        key = k
        value = v
    }
    
    public var wrappedValue: Value {
        get {
            UserDefaults.standard.value(forKey: key) as? Value ?? value
        } set {
            UserDefaults.standard.set(newValue, forKey: key)
            value = newValue
        }
    }
    
    public func delete() {
        UserDefaults.standard.removeObject(forKey: key)
    }
}
