//
//  User Default.swift
//  CoreDataKit
//
//  Created by Raghav Ahuja on 18/10/19.
//  Copyright © 2019 Raghav Ahuja. All rights reserved.
//

import Foundation

open class CKUserDefaults: Foundation.UserDefaults {
    
    private static let `default` = CKUserDefaults()
    
    open override class var standard: CKUserDefaults {
        .default
    }
    
    private static let defaultAppGroup = CKUserDefaults(suiteName: "CK-App")!
    
    open class var standardAppGroup: CKUserDefaults {
        .defaultAppGroup
    }
    
    open func set<Key: StorageKeys>(_ value: Any?, for key: Key) {
        set(value, forKey: key.key)
    }
    
    open func set<Key: StorageKeys>(_ value: Int, for key: Key) {
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
    
    open func set<Key: StorageKeys>(_ uuid: UUID, for key: Key) {
        set(uuid.uuidString, for: key)
    }
    
    open func set<Keys: StorageKeys>(_ keyedValues: [Keys : Any]) {
        let values = Dictionary(uniqueKeysWithValues: keyedValues.map { ($0.key, $1) })
        setValuesForKeys(values)
    }
    
    open func delete<Key: StorageKeys>(for key: Key) {
        removeObject(forKey: key.key)
    }
    
    open func value<Key: StorageKeys>(for key: Key) -> Any? {
        value(forKey: key.key)
    }
    
    open func stringValue<Key: StorageKeys>(for key: Key) -> String? {
        string(forKey: key.key)
    }
    
    open func intValue<Key: StorageKeys>(for key: Key) -> Int {
        integer(forKey: key.key)
    }
    
    open func floatValue<Key: StorageKeys>(for key: Key) -> Float {
        float(forKey: key.key)
    }
    
    open func doubleValue<Key: StorageKeys>(for key: Key) -> Double {
        double(forKey: key.key)
    }
    
    open func boolValue<Key: StorageKeys>(for key: Key) -> Bool {
        bool(forKey: key.key)
    }
    
    open func data<Key: StorageKeys>(for key: Key) -> Data? {
        data(forKey: key.key)
    }
    
    open func uuid<Key: StorageKeys>(for key: Key) -> UUID? {
        guard let uuidString = stringValue(for: key) else {
            return nil
        }
        
        return UUID(uuidString: uuidString)
    }
}
