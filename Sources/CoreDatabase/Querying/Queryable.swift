//
//  Queryable.swift
//  CoreDatabase
//
//  Copyright © 2018 John Rommel Estropia
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all
//  copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//  SOFTWARE.
//

import Foundation
import CoreData
import CoreGraphics.CGGeometry

// MARK: - Queryable

/**
 Types supported by CoreDatabase for querying, especially as generic type for `Fetch` clauses.
 Supported default types:
 - `Bool`
 - `CGFloat`
 - `Data`
 - `Date`
 - `Double`
 - `Float`
 - `Int`
 - `Int8`
 - `Int16`
 - `Int32`
 - `Int64`
 - `NSData`
 - `NSDate`
 - `NSDecimalNumber`
 - `NSManagedObjectID`
 - `NSNull`
 - `NSNumber`
 - `NSString`
 - `NSURL`
 - `NSUUID`
 - `String`
 - `URL`
 - `UUID`
 
 In addition, `RawRepresentable` types whose `RawValue` already implements `Queryable` only need to declare conformance to `Queryable`.
 */
public protocol Queryable: Hashable {
    
    /// The CoreData `NativeType` for this type when used in `Fetch` clauses.
    associatedtype QueryableNativeType
    
    /// The `NSAttributeType` for this type when used in `Fetch` clauses.
    static var attributeType: NSAttributeType { get }
    
    /// Creates an instance of this type from its `QueryableNativeType` value.
    @inline(__always)
    static func nativeValue(from value: QueryableNativeType) -> Self?
    
    
    /// Creates `QueryableNativeType` value from this instance.
    @inline(__always)
    var queryableValue: QueryableNativeType { get }
    
    @inline(__always)
    var data: Data? { get }
}

// MARK: - Bool

extension Bool: Queryable {
    
    public typealias QueryableNativeType = NSNumber
    
    public static let attributeType: NSAttributeType = .booleanAttributeType
    
    @inline(__always)
    public static func nativeValue(from value: QueryableNativeType) -> Bool? {
        
        switch value {
            
        case let decimal as NSDecimalNumber:
            // iOS: NSDecimalNumber(string: "0.5").boolValue // true
            // macOS: NSDecimalNumber(string: "0.5").boolValue // false
            return decimal != NSDecimalNumber.zero
            
        default:
            return value.boolValue
        }
    }
    
    @inline(__always)
    public var queryableValue: QueryableNativeType {
        self as QueryableNativeType
    }
    
    @inline(__always)
    public var data: Data? {
        NSKeyedArchiver.archivedData(withRootObject: queryableValue)
    }
}


// MARK: - CGFloat

extension CGFloat: Queryable {
    
    public typealias QueryableNativeType = NSNumber
    
    public static let attributeType: NSAttributeType = .doubleAttributeType
    
    @inline(__always)
    public static func nativeValue(from value: QueryableNativeType) -> CGFloat? {
        CGFloat(value.doubleValue)
    }
    
    @inline(__always)
    public var queryableValue: QueryableNativeType {
        self as QueryableNativeType
    }
    
    @inline(__always)
    public var data: Data? {
        NSKeyedArchiver.archivedData(withRootObject: queryableValue)
    }
}


// MARK: - Data

extension Data: Queryable {
    
    public typealias QueryableNativeType = NSData
    
    public static let attributeType: NSAttributeType = .binaryDataAttributeType
    
    @inline(__always)
    public static func nativeValue(from value: QueryableNativeType) -> Data? {
        value as Data
    }
    
    @inline(__always)
    public var queryableValue: QueryableNativeType {
        self as QueryableNativeType
    }
    
    @inline(__always)
    public var data: Data? {
        self
    }
}


// MARK: - Date

extension Date: Queryable {
    
    public typealias QueryableNativeType = NSDate
    
    public static let attributeType: NSAttributeType = .dateAttributeType
    
    @inline(__always)
    public static func nativeValue(from value: QueryableNativeType) -> Date? {
        value as Date
    }
    
    @inline(__always)
    public var queryableValue: QueryableNativeType {
        self as NSDate
    }
    
    @inline(__always)
    public var data: Data? {
        timeIntervalSince1970.data
    }
}


// MARK: - Double

extension Double: Queryable {
    
    public typealias QueryableNativeType = NSNumber
    
    public static let attributeType: NSAttributeType = .doubleAttributeType
    
    @inline(__always)
    public static func nativeValue(from value: QueryableNativeType) -> Double? {
        value.doubleValue
    }
    
    @inline(__always)
    public var queryableValue: QueryableNativeType {
        self as NSNumber
    }
    
    @inline(__always)
    public var data: Data? {
        NSKeyedArchiver.archivedData(withRootObject: queryableValue)
    }
}


// MARK: - Float

extension Float: Queryable {
    
    public typealias QueryableNativeType = NSNumber
    
    public static let attributeType: NSAttributeType = .floatAttributeType
    
    @inline(__always)
    public static func nativeValue(from value: QueryableNativeType) -> Float? {
        value.floatValue
    }
    
    @inline(__always)
    public var queryableValue: QueryableNativeType {
        self as NSNumber
    }
    
    @inline(__always)
    public var data: Data? {
        NSKeyedArchiver.archivedData(withRootObject: queryableValue)
    }
}


// MARK: - Int

extension Int: Queryable {
    
    public typealias QueryableNativeType = NSNumber
    
    public static let attributeType: NSAttributeType = .integer64AttributeType
    
    @inline(__always)
    public static func nativeValue(from value: QueryableNativeType) -> Int? {
        value.intValue
    }
    
    @inline(__always)
    public var queryableValue: QueryableNativeType {
        self as NSNumber
    }
    
    @inline(__always)
    public var data: Data? {
        NSKeyedArchiver.archivedData(withRootObject: queryableValue)
    }
}


// MARK: - Int8

extension Int8: Queryable {
    
    public typealias QueryableNativeType = NSNumber
    
    public static let attributeType: NSAttributeType = .integer16AttributeType
    
    @inline(__always)
    public static func nativeValue(from value: QueryableNativeType) -> Int8? {
        value.int8Value
    }
    
    @inline(__always)
    public var queryableValue: QueryableNativeType {
        self as NSNumber
    }
    
    @inline(__always)
    public var data: Data? {
        NSKeyedArchiver.archivedData(withRootObject: queryableValue)
    }
}


// MARK: - Int16

extension Int16: Queryable {
    
    public typealias QueryableNativeType = NSNumber
    
    public static let attributeType: NSAttributeType = .integer16AttributeType
    
    @inline(__always)
    public static func nativeValue(from value: QueryableNativeType) -> Int16? {
        value.int16Value
    }
    
    @inline(__always)
    public var queryableValue: QueryableNativeType {
        self as NSNumber
    }
    
    @inline(__always)
    public var data: Data? {
        NSKeyedArchiver.archivedData(withRootObject: queryableValue)
    }
}


// MARK: - Int32

extension Int32: Queryable {
    
    public typealias QueryableNativeType = NSNumber
    
    public static let attributeType: NSAttributeType = .integer32AttributeType
    
    @inline(__always)
    public static func nativeValue(from value: QueryableNativeType) -> Int32? {
        value.int32Value
    }
    
    @inline(__always)
    public var queryableValue: QueryableNativeType {
        self as NSNumber
    }
    
    @inline(__always)
    public var data: Data? {
        NSKeyedArchiver.archivedData(withRootObject: queryableValue)
    }
}


// MARK: - Int64

extension Int64: Queryable {
    
    public typealias QueryableNativeType = NSNumber
    
    public static let attributeType: NSAttributeType = .integer64AttributeType
    
    @inline(__always)
    public static func nativeValue(from value: QueryableNativeType) -> Int64? {
        value.int64Value
    }
    
    @inline(__always)
    public var queryableValue: QueryableNativeType {
        self as NSNumber
    }
    
    @inline(__always)
    public var data: Data? {
        NSKeyedArchiver.archivedData(withRootObject: queryableValue)
    }
}


// MARK: - NSData

extension NSData: Queryable {
    
    public typealias QueryableNativeType = NSData
    
    @nonobjc
    public class var attributeType: NSAttributeType {
        .binaryDataAttributeType
    }
    
    @nonobjc @inline(__always)
    public class func nativeValue(from value: QueryableNativeType) -> Self? {
        
        func forceCast<T: NSData>(_ value: Any) -> T? {
             value as? T
        }
        
        return forceCast(value)
    }
    
    @nonobjc @inline(__always)
    public var queryableValue: QueryableNativeType {
        self
    }
    
    @inline(__always)
    public var data: Data? {
        NSKeyedArchiver.archivedData(withRootObject: self)
    }
}


// MARK: - NSDate

extension NSDate: Queryable {
    
    public typealias QueryableNativeType = NSDate
    
    @nonobjc
    public class var attributeType: NSAttributeType {
        .dateAttributeType
    }
    
    @nonobjc @inline(__always)
    public class func nativeValue(from value: QueryableNativeType) -> Self? {
        
        func forceCast<T: NSDate>(_ value: Any) -> T? {
             value as? T
        }
        
        return forceCast(value)
    }
    
    @nonobjc @inline(__always)
    public var queryableValue: QueryableNativeType {
        self
    }
    
    @inline(__always)
    public var data: Data? {
        timeIntervalSince1970.data
    }
}


// MARK: - NSDecimalNumber

extension NSDecimalNumber /*: Queryable */ {
    
    public override class var attributeType: NSAttributeType {
        .decimalAttributeType
    }
}


// MARK: - NSManagedObjectID

extension NSManagedObjectID: Queryable {
    
    public typealias QueryableNativeType = NSManagedObjectID
    
    @nonobjc
    public class var attributeType: NSAttributeType {
        .objectIDAttributeType
    }
    
    @nonobjc @inline(__always)
    public class func nativeValue(from value: QueryableNativeType) -> Self? {
        
        func forceCast<T: NSManagedObjectID>(_ value: Any) -> T? {
             value as? T
        }
        
        return forceCast(value)
    }
    
    @nonobjc @inline(__always)
    public var queryableValue: QueryableNativeType {
        self
    }
    
    @inline(__always)
    public var data: Data? {
        nil
    }
}


// MARK: - NSNull

extension NSNull: Queryable {
    
    public typealias QueryableNativeType = NSNull
    
    @nonobjc
    public class var attributeType: NSAttributeType {
        .undefinedAttributeType
    }
    
    @nonobjc @inline(__always)
    public class func nativeValue(from value: QueryableNativeType) -> Self? {
        
        func forceCast<T: NSNull>(_ value: Any) -> T? {
             value as? T
        }
        
        return forceCast(value)
    }
    
    @nonobjc @inline(__always)
    public var queryableValue: QueryableNativeType {
        self
    }
    
    @inline(__always)
    public var data: Data? {
        nil
    }
}


// MARK: - NSNumber

extension NSNumber: Queryable {
    
    public typealias QueryableNativeType = NSNumber
    
    @objc
    public class var attributeType: NSAttributeType {
        .integer64AttributeType
    }
    
    @nonobjc @inline(__always)
    public class func nativeValue(from value: QueryableNativeType) -> Self? {
        
        func forceCast<T: NSNumber>(_ value: Any) -> T? {
             value as? T
        }
        
        return forceCast(value)
    }
    
    @nonobjc @inline(__always)
    public var queryableValue: QueryableNativeType {
        self
    }
    
    @inline(__always)
    public var data: Data? {
        NSKeyedArchiver.archivedData(withRootObject: self)
    }
}


// MARK: - NSString

extension NSString: Queryable {
    
    public typealias QueryableNativeType = NSString
    
    @nonobjc
    public class var attributeType: NSAttributeType {
        .stringAttributeType
    }
    
    @nonobjc @inline(__always)
    public class func nativeValue(from value: QueryableNativeType) -> Self? {
        
        func forceCast<T: NSString>(_ value: Any) -> T? {
            value as? T
        }
        
        return forceCast(value)
    }
    
    @nonobjc @inline(__always)
    public var queryableValue: QueryableNativeType {
        self
    }
    
    @inline(__always)
    public var data: Data? {
        data(using: String.Encoding.utf8.rawValue)
    }
}


// MARK: - NSURL

extension NSURL: Queryable {
    
    public typealias QueryableNativeType = NSString
    
    @nonobjc
    public class var attributeType: NSAttributeType {
        .stringAttributeType
    }
    
    @nonobjc @inline(__always)
    public class func nativeValue(from value: QueryableNativeType) -> Self? {
        self.init(string: value as String)
    }
    
    @nonobjc @inline(__always)
    public var queryableValue: QueryableNativeType {
        (self as URL).absoluteString as QueryableNativeType
    }
    
    @inline(__always)
    public var data: Data? {
        absoluteString?.data(using: .utf8)
    }
}


// MARK: - NSUUID

extension NSUUID: Queryable {
    
    public typealias QueryableNativeType = NSString
    
    @nonobjc
    public class var attributeType: NSAttributeType {
        .stringAttributeType
    }
    
    @nonobjc @inline(__always)
    public class func nativeValue(from value: QueryableNativeType) -> Self? {
        self.init(uuidString: value.lowercased)
    }
    
    @nonobjc @inline(__always)
    public var queryableValue: QueryableNativeType {
        uuidString.lowercased() as QueryableNativeType
    }
    
    @inline(__always)
    public var data: Data? {
        uuidString.data(using: .utf8)
    }
}


// MARK: - String

extension String: Queryable {
    
    public typealias QueryableNativeType = NSString
    
    public static let attributeType: NSAttributeType = .stringAttributeType
    
    @inline(__always)
    public static func nativeValue(from value: QueryableNativeType) -> String? {
        value as String
    }
    
    @inline(__always)
    public var queryableValue: QueryableNativeType {
        self as QueryableNativeType
    }
    
    @inline(__always)
    public var data: Data? {
        data(using: .utf8)
    }
}


// MARK: - URL

extension URL: Queryable {
    
    public typealias QueryableNativeType = NSString
    
    public static let attributeType: NSAttributeType = .stringAttributeType
    
    @inline(__always)
    public static func nativeValue(from value: QueryableNativeType) -> URL? {
        self.init(string: value as String)
    }
    
    @inline(__always)
    public var queryableValue: QueryableNativeType {
        absoluteString as QueryableNativeType
    }
    
    @inline(__always)
    public var data: Data? {
        absoluteString.data(using: .utf8)
    }
}


// MARK: - UUID

extension UUID: Queryable {
    
    public typealias QueryableNativeType = NSString
    
    public static let attributeType: NSAttributeType = .stringAttributeType
    
    @inline(__always)
    public static func nativeValue(from value: QueryableNativeType) -> UUID? {
        self.init(uuidString: value.lowercased)
    }
    
    @inline(__always)
    public var queryableValue: QueryableNativeType {
        uuidString.lowercased() as QueryableNativeType
    }
    
    @inline(__always)
    public var data: Data? {
        uuidString.data(using: .utf8)
    }
}


// MARK: - RawRepresentable

extension RawRepresentable where RawValue: Queryable {
    
    public typealias QueryableNativeType = RawValue.QueryableNativeType
    
    public static var attributeType: NSAttributeType {
        RawValue.attributeType
    }
    
    @inline(__always)
    public static func cs_fromQueryableNativeType(_ value: QueryableNativeType) -> Self? {
        RawValue.nativeValue(from: value).flatMap { self.init(rawValue: $0) }
    }
    
    @inline(__always)
    public func cs_toQueryableNativeType() -> QueryableNativeType {
        rawValue.queryableValue
    }
    
    @inline(__always)
    public var data: Data? {
        rawValue.data
    }
}
