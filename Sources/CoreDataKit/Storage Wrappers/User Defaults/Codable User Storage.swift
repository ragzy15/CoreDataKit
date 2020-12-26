//
//  Codable User Storage.swift
//  CoreDataKit
//
//  Created by Raghav Ahuja on 18/10/19.
//  Copyright © 2019 Raghav Ahuja. All rights reserved.
//

import Foundation

@propertyWrapper
public struct CodableUserStorage<Value: Codable> {
    
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
            let data = CKUserDefaults.standard.value(forKey: key) as? Data
            return decode(data) ?? value
        }
        set {
            let data = encode(newValue)
            CKUserDefaults.standard.set(data, forKey: key)
            value = newValue
        }
    }
    
    private func encode(_ value: Value) -> Data? {
        do {
            let data = try JSONEncoder().encode(value)
            return data
        } catch {
            print(error)
            return nil
        }
    }
    
    private func decode(_ data: Data?) -> Value? {
        guard let data = data else {
            return nil
        }
        
        do {
            let value = try JSONDecoder().decode(Value.self, from: data)
            return value
        } catch {
            print(error)
            return nil
        }
    }
    
    public func delete() {
        CKUserDefaults.standard.removeObject(forKey: key)
    }
}
