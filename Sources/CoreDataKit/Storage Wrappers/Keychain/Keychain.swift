//
//  Keychain.swift
//  CoreDataKit
//
//  Created by Raghav Ahuja on 18/10/19.
//  Copyright © 2019 Raghav Ahuja. All rights reserved.
//

import Foundation

open class Keychain {
    
    private static let `default` = Keychain()
    open class var standard: Keychain {
        .default
    }
    
    private var serviceName: String
    private var accessGroup: String?
    
    public init(accessGroup: String? = nil) {
        self.serviceName = Bundle.main.bundleIdentifier!
        self.accessGroup = accessGroup
    }
    
    // MARK:- Public Methods
    
    /// Checks if keychain data exists for a specified key.
    ///
    /// - parameter for: The key to check for.
    /// - parameter accessibility: Optional accessibility to use when retrieving the keychain item.
    /// - returns: True if a value exists for the key. False otherwise.
    open func hasValue(for key: String, withAccessibility accessibility: Accessibility = .whenUnlocked) -> Bool {
        if let _ = data(for: key, accessibility: accessibility) {
            return true
        } else {
            return false
        }
    }
    
    // MARK: Public Getters
    
    open func integer(for key: String, withAccessibility accessibility: Accessibility = .whenUnlocked) -> Int? {
        guard let numberValue = object(for: key, accessibility: accessibility) as? NSNumber else {
            return nil
        }
        
        return numberValue.intValue
    }
    
    open func float(for key: String, withAccessibility accessibility: Accessibility = .whenUnlocked) -> Float? {
        guard let numberValue = object(for: key, accessibility: accessibility) as? NSNumber else {
            return nil
        }
        
        return numberValue.floatValue
    }
    
    open func double(for key: String, withAccessibility accessibility: Accessibility = .whenUnlocked) -> Double? {
        guard let numberValue = object(for: key, accessibility: accessibility) as? NSNumber else {
            return nil
        }
        
        return numberValue.doubleValue
    }
    
    open func bool(for key: String, accessibility: Accessibility = .whenUnlocked) -> Bool? {
        guard let numberValue = object(for: key, accessibility: accessibility) as? NSNumber else {
            return nil
        }
        
        return numberValue.boolValue
    }
    
    /// Returns a string value for a specified key.
    ///
    /// - parameter for: The key to lookup data for.
    /// - parameter accessibility: Optional accessibility to use when retrieving the keychain item.
    /// - returns: The String associated with the key if it exists. If no data exists, or the data found cannot be encoded as a string, returns nil.
    open func string(for key: String, accessibility: Accessibility = .whenUnlocked) -> String? {
        guard let keychainData = data(for: key, accessibility: accessibility) else {
            return nil
        }
        
        return String(data: keychainData, encoding: .utf8)
    }
    
    /// Returns an object that conforms to NSCoding for a specified key.
    ///
    /// - parameter for: The key to lookup data for.
    /// - parameter accessibility: Optional accessibility to use when retrieving the keychain item.
    /// - returns: The decoded object associated with the key if it exists. If no data exists, or the data found cannot be decoded, returns nil.
    open func object(for key: String, accessibility: Accessibility = .whenUnlocked) -> NSCoding? {
        guard let keychainData = data(for: key, accessibility: accessibility) else {
            return nil
        }
        
        return NSKeyedUnarchiver.unarchiveObject(with: keychainData) as? NSCoding
    }
    
    
    /// Returns a Data object for a specified key.
    ///
    /// - parameter for: The key to lookup data for.
    /// - parameter accessibility: Optional accessibility to use when retrieving the keychain item.
    /// - returns: The Data object associated with the key if it exists. If no data exists, returns nil.
    open func data(for key: String, accessibility: Accessibility = .whenUnlocked) -> Data? {
        var keychainQueryDictionary = setupKeychainQueryDictionary(for: key, accessibility: accessibility)
        
        // Limit search results to one
        keychainQueryDictionary[kSecMatchLimit] = kSecMatchLimitOne
        
        // Specify we want Data/CFData returned
        keychainQueryDictionary[kSecReturnData] = kCFBooleanTrue
        
        // Search
        var result: AnyObject?
        let status = SecItemCopyMatching(keychainQueryDictionary as CFDictionary, &result)
        
        return status == noErr ? result as? Data : nil
    }
    
    // MARK: Public Setters
    
    @discardableResult open func set(_ value: Int, for key: String, accessibility: Accessibility = .whenUnlocked) -> Bool {
        return set(NSNumber(value: value), for: key, accessibility: accessibility)
    }
    
    @discardableResult open func set(_ value: Float, for key: String, accessibility: Accessibility = .whenUnlocked) -> Bool {
        return set(NSNumber(value: value), for: key, accessibility: accessibility)
    }
    
    @discardableResult open func set(_ value: Double, for key: String, accessibility: Accessibility = .whenUnlocked) -> Bool {
        return set(NSNumber(value: value), for: key, accessibility: accessibility)
    }
    
    @discardableResult open func set(_ value: Bool, for key: String, accessibility: Accessibility = .whenUnlocked) -> Bool {
        return set(NSNumber(value: value), for: key, accessibility: accessibility)
    }
    
    /// Save a String value to the keychain associated with a specified key. If a String value already exists for the given key, the string will be overwritten with the new value.
    ///
    /// - parameter value: The String value to save.
    /// - parameter for: The key to save the String under.
    /// - parameter accessibility: Optional accessibility to use when setting the keychain item.
    /// - returns: True if the save was successful, false otherwise.
    @discardableResult open func set(_ value: String, for key: String, accessibility: Accessibility = .whenUnlocked) -> Bool {
        if let data = value.data(using: .utf8) {
            return set(data, for: key, accessibility: accessibility)
        } else {
            return false
        }
    }
    
    /// Save an NSCoding compliant object to the keychain associated with a specified key. If an object already exists for the given key, the object will be overwritten with the new value.
    ///
    /// - parameter value: The NSCoding compliant object to save.
    /// - parameter for: The key to save the object under.
    /// - parameter accessibility: Optional accessibility to use when setting the keychain item.
    /// - returns: True if the save was successful, false otherwise.
    @discardableResult open func set(_ value: NSCoding, for key: String, accessibility: Accessibility = .whenUnlocked) -> Bool {
        let data = NSKeyedArchiver.archivedData(withRootObject: value)
        
        return set(data, for: key, accessibility: accessibility)
    }
    
    /// Save a Data object to the keychain associated with a specified key. If data already exists for the given key, the data will be overwritten with the new value.
    ///
    /// - parameter value: The Data object to save.
    /// - parameter for: The key to save the object under.
    /// - parameter accessibility: Optional accessibility to use when setting the keychain item.
    /// - returns: True if the save was successful, false otherwise.
    @discardableResult open func set(_ value: Data, for key: String, accessibility: Accessibility = .whenUnlocked) -> Bool {
        var keychainQueryDictionary = setupKeychainQueryDictionary(for: key, accessibility: accessibility)
        
        keychainQueryDictionary[kSecValueData] = value
        
        keychainQueryDictionary[kSecAttrAccessible] = accessibility.attributeValue
        
        let status: OSStatus = SecItemAdd(keychainQueryDictionary as CFDictionary, nil)
        
        if status == errSecSuccess {
            return true
        } else if status == errSecDuplicateItem {
            return update(value, for: key, accessibility: accessibility)
        } else {
            return false
        }
    }
    
    /// Remove an object associated with a specified key. If re-using a key but with a different accessibility, first remove the previous key value using removeObjectForKey(:withAccessibility) using the same accessibilty it was saved with.
    ///
    /// - parameter for: The key value to remove data for.
    /// - parameter accessibility: Optional accessibility level to use when looking up the keychain item.
    /// - returns: True if successful, false otherwise.
    @discardableResult open func removeObject(for key: String, accessibility: Accessibility = .whenUnlocked) -> Bool {
        let keychainQueryDictionary = setupKeychainQueryDictionary(for: key, accessibility: accessibility)
        
        // Delete
        let status: OSStatus = SecItemDelete(keychainQueryDictionary as CFDictionary)
        
        if status == errSecSuccess {
            return true
        } else {
            return false
        }
    }
    
    /// Remove all keychain data added through KeychainWrapper. This will only delete items matching the currnt ServiceName and AccessGroup if one is set.
    open func removeAllKeys() -> Bool {
        var keychainQueryDictionary = [kSecClass: kSecClassGenericPassword]
        
        keychainQueryDictionary[kSecAttrService] = serviceName as CFString
        
        if let accessGroup = self.accessGroup {
            keychainQueryDictionary[kSecAttrAccessGroup] = accessGroup as CFString
        }
        let status: OSStatus = SecItemDelete(keychainQueryDictionary as CFDictionary)
        
        if status == errSecSuccess {
            return true
        } else {
            return false
        }
    }
    
    /// Remove all keychain data, including data not added through keychain.
    open class func wipeKeychain() {
        deleteKeychainSecClass(kSecClassGenericPassword) // Generic password items
        deleteKeychainSecClass(kSecClassInternetPassword) // Internet password items
        deleteKeychainSecClass(kSecClassCertificate) // Certificate items
        deleteKeychainSecClass(kSecClassKey) // Cryptographic key items
        deleteKeychainSecClass(kSecClassIdentity) // Identity items
    }
    
    // MARK:- Private Methods
    
    /// Remove all items for a given Keychain Item Class
    @discardableResult private class func deleteKeychainSecClass(_ secClass: AnyObject) -> Bool {
        let query = [kSecClass: secClass]
        let status: OSStatus = SecItemDelete(query as CFDictionary)
        
        if status == errSecSuccess {
            return true
        } else {
            return false
        }
    }
    
    /// Update existing data associated with a specified key name. The existing data will be overwritten by the new data.
    open func update(_ value: Data, for key: String, accessibility: Accessibility = .whenUnlocked) -> Bool {
        var keychainQueryDictionary = setupKeychainQueryDictionary(for: key, accessibility: accessibility)
        let updateDictionary = [kSecValueData: value]
        
        keychainQueryDictionary[kSecAttrAccessible] = accessibility.attributeValue
        
        // Update
        let status: OSStatus = SecItemUpdate(keychainQueryDictionary as CFDictionary, updateDictionary as CFDictionary)
        
        if status == errSecSuccess {
            return true
        } else {
            return false
        }
    }
    
    /// Setup the keychain query dictionary used to access the keychain on iOS for a specified key name. Takes into account the Service Name and Access Group if one is set.
    ///
    /// - parameter for: The key this query is for
    /// - parameter accessibility: Optional accessibility to use when setting the keychain item. If none is provided, will default to .WhenUnlocked
    /// - returns: A dictionary with all the needed properties setup to access the keychain on iOS
    private func setupKeychainQueryDictionary(for key: String, accessibility: Accessibility) -> [CFString: Any] {
        // Setup default access as generic password (rather than a certificate, internet password, etc)
        var keychainQueryDictionary: [CFString: Any] = [kSecClass: kSecClassGenericPassword]
        
        keychainQueryDictionary[kSecAttrService] = serviceName
        
        keychainQueryDictionary[kSecAttrAccessible] = accessibility.attributeValue
        
        if let accessGroup = self.accessGroup {
            keychainQueryDictionary[kSecAttrAccessGroup] = accessGroup
        }
        
        let encodedIdentifier = key.data(using: .utf8)
        keychainQueryDictionary[kSecAttrGeneric] = encodedIdentifier
        keychainQueryDictionary[kSecAttrAccount] = encodedIdentifier
        
        return keychainQueryDictionary
    }
}

// MARK: ACCESSIBILITY
extension Keychain {
    
    /// Keychain Accessibility options.
    public struct Accessibility {
        
        var attributeValue: CFString

        private init(rawValue: CFString) {
            self.attributeValue = rawValue
        }

        /// The data in the keychain item cannot be accessed after a restart until the device has been unlocked once by the user.
        ///
        /// After the first unlock, the data remains accessible until the next restart. This is recommended for items that need to be accessed by background applications. Items with this attribute migrate to a new device when using encrypted backups.
        public static let afterFirstUnlock = Accessibility(rawValue: kSecAttrAccessibleAfterFirstUnlock)
        

        /// The data in the keychain item cannot be accessed after a restart until the device has been unlocked once by the user.
        ///
        /// After the first unlock, the data remains accessible until the next restart. This is recommended for items that need to be accessed by background applications. Items with this attribute do not migrate to a new device. Thus, after restoring from a backup of a different device, these items will not be present.
        public static let afterFirstUnlockThisDeviceOnly = Accessibility(rawValue: kSecAttrAccessibleAfterFirstUnlockThisDeviceOnly)

        
        /// The data in the keychain item can always be accessed regardless of whether the device is locked.
        ///
        /// This is not recommended for application use. Items with this attribute migrate to a new device when using encrypted backups.
        @available(macOS, introduced: 10.9, deprecated: 10.14, message: "Use an accessibility level that provides some user protection, such as afterFirstUnlock")
        @available(iOS, introduced: 4.0, deprecated: 12.0, message: "Use an accessibility level that provides some user protection, such as afterFirstUnlock")
        @available(tvOS, introduced: 4.0, deprecated: 12.0, message: "Use an accessibility level that provides some user protection, such as afterFirstUnlock")
        @available(watchOS, introduced: 2.0, deprecated: 5.0, message: "Use an accessibility level that provides some user protection, such as afterFirstUnlock")
        public static let always = Accessibility(rawValue: kSecAttrAccessibleAlways)
        

        /// The data in the keychain can only be accessed when the device is unlocked. Only available if a passcode is set on the device.
        ///
        /// This is recommended for items that only need to be accessible while the application is in the foreground. Items with this attribute never migrate to a new device. After a backup is restored to a new device, these items are missing. No items can be stored in this class on devices without a passcode. Disabling the device passcode causes all items in this class to be deleted.
        public static let whenPasscodeSetThisDeviceOnly = Accessibility(rawValue: kSecAttrAccessibleWhenPasscodeSetThisDeviceOnly)
        

        /// The data in the keychain item can always be accessed regardless of whether the device is locked.
        ///
        /// This is not recommended for application use. Items with this attribute do not migrate to a new device. Thus, after restoring from a backup of a different device, these items will not be present.
        @available(iOS, introduced: 4.0, deprecated: 12.0, message: "Use an accessibility level that provides some user protection, such as afterFirstUnlockThisDeviceOnly")
        @available(macCatalyst, introduced: 13.0, deprecated: 13.0, message: "Use an accessibility level that provides some user protection, such as afterFirstUnlockThisDeviceOnly")
        public static let alwaysThisDeviceOnly = Accessibility(rawValue: kSecAttrAccessibleAlwaysThisDeviceOnly)


        /// The data in the keychain item can be accessed only while the device is unlocked by the user.
        ///
        /// This is recommended for items that need to be accessible only while the application is in the foreground. Items with this attribute migrate to a new device when using encrypted backups.
        ///
        /// This is the default value for keychain items added without explicitly setting an accessibility constant.
        public static let whenUnlocked = Accessibility(rawValue: kSecAttrAccessibleWhenUnlocked)
        
        
        /// The data in the keychain item can be accessed only while the device is unlocked by the user.
        ///
        /// This is recommended for items that need to be accessible only while the application is in the foreground. Items with this attribute do not migrate to a new device. Thus, after restoring from a backup of a different device, these items will not be present.
        @available(macOS, introduced: 10.9, deprecated: 10.14, message: "Use an accessibility level that provides some user protection, such as afterFirstUnlockThisDeviceOnly")
        @available(iOS, introduced: 4.0, deprecated: 12.0, message: "Use an accessibility level that provides some user protection, such as afterFirstUnlockThisDeviceOnly")
        @available(tvOS, introduced: 4.0, deprecated: 12.0, message: "Use an accessibility level that provides some user protection, such as afterFirstUnlockThisDeviceOnly")
        @available(watchOS, introduced: 2.0, deprecated: 5.0, message: "Use an accessibility level that provides some user protection, such as afterFirstUnlockThisDeviceOnly")
        public static let whenUnlockedThisDeviceOnly = Accessibility(rawValue: kSecAttrAccessibleWhenUnlockedThisDeviceOnly)
    }
}
