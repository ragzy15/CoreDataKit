//
//  User Default.swift
//  CoreDataKit
//
//  Created by Raghav Ahuja on 18/10/19.
//  Copyright © 2019 Raghav Ahuja. All rights reserved.
//

import Foundation
import os.log

open class CKUserDefaults: Foundation.UserDefaults {
    
    private static let `default` = CKUserDefaults()
    
    open override class var standard: CKUserDefaults {
        .default
    }
    
    open func set<Key: StorageKeys>(_ value: Any?, for key: Key) {
        set(value, forKey: key.key)
    }
    
    open func set<Keys: StorageKeys>(_ keyedValues: [Keys : Any]) {
        let values = Dictionary(uniqueKeysWithValues: keyedValues.map { ($0.key, $1) })
        setValuesForKeys(values)
    }
    
    open func set<Key: StorageKeys>(_ value: Int, for key: Key) {
        set(value, forKey: key.key)
    }
    
    open func set<Key: StorageKeys>(_ value: String, for key: Key) {
        set(value, forKey: key.key)
    }
    
    open func set<Key: StorageKeys>(_ value: Float, for key: Key) {
        set(value, forKey: key.key)
    }
    
    open func set<Key: StorageKeys>(_ value: Double, for key: Key) {
        set(value, forKey: key.key)
    }
    
    open func set<Key: StorageKeys>(_ value: Bool, for key: Key) {
        set(value, forKey: key.key)
    }
    
    open func set<Key: StorageKeys>(_ url: URL?, for key: Key) {
        set(url, forKey: key.key)
    }
    
    @discardableResult
    open func set<Key: StorageKeys, Object: Codable>(for key: Key, object: Object) -> Bool {
        guard let dataValue = try? JSONEncoder().encode(object) else {
            return false
        }
        
        set(dataValue, forKey: key.key)
        return true
    }
    
    open func object<Key: StorageKeys>(for key: Key) -> Any? {
        object(forKey: key.key)
    }
    
    open func value<Key: StorageKeys>(for key: Key) -> Any? {
        return value(forKey: key.key)
    }
    
    open func stringValue<Key: StorageKeys>(for key: Key) -> String? {
        return string(forKey: key.key)
    }
    
    open func intValue<Key: StorageKeys>(for key: Key) -> Int {
        return integer(forKey: key.key)
    }
    
    open func floatValue<Key: StorageKeys>(for key: Key) -> Float {
        return float(forKey: key.key)
    }
    
    open func doubleValue<Key: StorageKeys>(for key: Key) -> Double {
        return double(forKey: key.key)
    }
    
    open func boolValue<Key: StorageKeys>(for key: Key) -> Bool {
        return bool(forKey: key.key)
    }
    
    open func dataValue<Key: StorageKeys>(for key: Key) -> Data? {
        return data(forKey: key.key)
    }
    
    open func arrayValue<Key: StorageKeys, Type>(for key: Key) -> [Type]? {
        array(forKey: key.key) as? [Type]
    }
    
    open func dictionary<Key: StorageKeys, DictKey: Hashable, Value>(for key: Key) -> [DictKey: Value]? {
        dictionary(forKey: key.key) as? [DictKey: Value]
    }
    
    open func url<Key: StorageKeys>(for key: Key) -> URL? {
        url(forKey: key.key)
    }
    
    open func item<Key: StorageKeys, Object: Codable>(for key: Key) -> Object? {
        guard let data = dataValue(for: key) else {
            return nil
        }
        
        return try? JSONDecoder().decode(Object.self, from: data)
    }
    
    open func delete<Key: StorageKeys>(for key: Key) {
        removeObject(forKey: key.key)
    }
}
