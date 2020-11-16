//
//  CKPredicate.swift
//  CoreDataKit
//
//  Created by Raghav Ahuja on 18/10/19.
//  Copyright © 2019 Raghav Ahuja. All rights reserved.
//

import Foundation

public struct CKPredicate<T: CKObject> {
    
    public let predicate: NSPredicate
    
    /// <#Description#>
    /// - Parameter predicate: <#predicate description#>
    public init(_ predicate: NSPredicate) {
        self.predicate = predicate
    }
    
    /// <#Description#>
    /// - Parameters:
    ///   - format: <#format description#>
    ///   - args: <#args description#>
    public init(_ format: String, args: CVarArg...) {
        let p = NSPredicate(format: format, args)
        predicate = p
    }
    
    /// <#Description#>
    /// - Parameter value: <#value description#>
    public init(_ value: Bool) {
        let p = NSPredicate(value: value)
        predicate = p
    }
}

extension CKPredicate {
    
    /// Initializes a `CKPredicate` clause that compares equality
    /// - parameter keyPath: the keyPath to compare with
    /// - parameter value: the arguments for the `==` operator
    public init<Value: CKEquatableQuery>(_ keyPath: KeyPath<T, Value>, isEqualTo value: Value?) {
        switch value {
        case nil, is NSNull:
            self.init(NSPredicate(format: "\(keyPath.objcStringValue) == nil"))
            
        case let value?:
            self.init(NSPredicate(format: "\(keyPath.objcStringValue) == %@", argumentArray: [value.ckQueryableValue]))
        }
    }
    
    
    /// Initializes a `CKPredicate` clause that compares equality
    /// - parameter keyPath: the keyPath to compare with
    /// - parameter value: the arguments for the `==` operator
    public init<Value: CKComparableQuery>(_ keyPath: KeyPath<T, Value>, isLessThan value: Value?) {
        if let value = value {
            self.init("%K < %@", keyPath.objcStringValue, value.ckQueryableValue)
        } else {
            self.init("%K < nil", keyPath.objcStringValue)
        }
    }
    
    
    /// Initializes a `CKPredicate` clause that compares equality
    /// - parameter keyPath: the keyPath to compare with
    /// - parameter value: the arguments for the `==` operator
    public init<Value: CKComparableQuery>(_ keyPath: KeyPath<T, Value>, isLessThanEqualTo value: Value?) {
        if let value = value {
            self.init("%K <= %@", keyPath.objcStringValue, value.ckQueryableValue)
        } else {
            self.init("%K <= nil", keyPath.objcStringValue)
        }
    }
    
    
    /// Initializes a `CKPredicate` clause that compares equality     
    /// - parameter keyPath: the keyPath to compare with
    /// - parameter value: the arguments for the `==` operator
    public init<Value: CKComparableQuery>(_ keyPath: KeyPath<T, Value>, isGreaterThan value: Value?) {
        if let value = value {
            self.init("%K > %@", keyPath.objcStringValue, value.ckQueryableValue)
        } else {
            self.init("%K > nil", keyPath.objcStringValue)
        }
    }
    
    
    /// Initializes a `CKPredicate` clause that compares equality
    /// - parameter keyPath: the keyPath to compare with
    /// - parameter value: the arguments for the `==` operator
    public init<Value: CKComparableQuery>(_ keyPath: KeyPath<T, Value>, isGreaterThanEqualTo value: Value?) {
        if let value = value {
            self.init("%K >= %@", keyPath.objcStringValue, value.ckQueryableValue)
        } else {
            self.init("%K >= nil", keyPath.objcStringValue)
        }
    }
}

extension CKPredicate {
    
    /// Initializes a `CKPredicate` clause that compares equality
    /// - parameter keyPath: the keyPath to compare with
    /// - parameter value: the arguments for the `==` operator
    public init<Value: CKEquatableQuery>(_ keyPath: KeyPath<T, Value?>, isEqualTo value: Value?) {
        switch value {
        case nil, is NSNull:
            self.init(NSPredicate(format: "\(keyPath.objcStringValue) == nil"))
            
        case let value?:
            self.init(NSPredicate(format: "\(keyPath.objcStringValue) == %@", argumentArray: [value.ckQueryableValue]))
        }
    }
    
    
    /// Initializes a `CKPredicate` clause that compares equality
    /// - parameter keyPath: the keyPath to compare with
    /// - parameter value: the arguments for the `==` operator
    public init<Value: CKComparableQuery>(_ keyPath: KeyPath<T, Value?>, isLessThan value: Value?) {
        if let value = value {
            self.init("%K < %@", keyPath.objcStringValue, value.ckQueryableValue)
        } else {
            self.init("%K < nil", keyPath.objcStringValue)
        }
    }
    
    
    /// Initializes a `CKPredicate` clause that compares equality
    /// - parameter keyPath: the keyPath to compare with
    /// - parameter value: the arguments for the `==` operator
    public init<Value: CKComparableQuery>(_ keyPath: KeyPath<T, Value?>, isLessThanEqualTo value: Value?) {
        if let value = value {
            self.init("%K <= %@", keyPath.objcStringValue, value.ckQueryableValue)
        } else {
            self.init("%K <= nil", keyPath.objcStringValue)
        }
    }
    
    
    /// Initializes a `CKPredicate` clause that compares equality
    /// - parameter keyPath: the keyPath to compare with
    /// - parameter value: the arguments for the `==` operator
    public init<Value: CKComparableQuery>(_ keyPath: KeyPath<T, Value?>, isGreaterThan value: Value?) {
        if let value = value {
            self.init("%K > %@", keyPath.objcStringValue, value.ckQueryableValue)
        } else {
            self.init("%K > nil", keyPath.objcStringValue)
        }
    }
    
    
    /// Initializes a `CKPredicate` clause that compares equality
    /// - parameter keyPath: the keyPath to compare with
    /// - parameter value: the arguments for the `==` operator
    public init<Value: CKComparableQuery>(_ keyPath: KeyPath<T, Value?>, isGreaterThanEqualTo value: Value?) {
        if let value = value {
            self.init("%K >= %@", keyPath.objcStringValue, value.ckQueryableValue)
        } else {
            self.init("%K >= nil", keyPath.objcStringValue)
        }
    }
}

extension CKPredicate {
    
    
    /// Initializes a `CKPredicate` clause with a predicate using the specified string format and arguments
    /// - parameter format: the format string for the predicate
    /// - parameter args: the arguments for `format`
    public init(_ format: String, _ args: Any...) {
        self.init(NSPredicate(format: format, argumentArray: args))
    }
    
    
    /// Initializes a `CKPredicate` clause with a predicate using the specified string format and arguments
    /// - parameter format: the format string for the predicate
    /// - parameter argumentArray: the arguments for `format`
    public init(_ format: String, argumentArray: [Any]?) {
        self.init(NSPredicate(format: format, argumentArray: argumentArray))
    }
    
}

extension CKPredicate {
    
    
    /// Combines two `CKPredicate` predicates together using `AND` operator
    public static func && (left: CKPredicate<T>, right: CKPredicate<T>) -> CKPredicate<T> {
        CKPredicate<T>(NSCompoundPredicate(type: .and, subpredicates: [left.predicate, right.predicate]))
    }
    
    
    /// Combines two `CKPredicate` predicates together using `OR` operator
    public static func || (left: CKPredicate<T>, right: CKPredicate<T>) -> CKPredicate<T> {
        CKPredicate<T>(NSCompoundPredicate(type: .or, subpredicates: [left.predicate, right.predicate]))
    }
    
    
    /// Inverts the predicate of a `CKPredicate` clause using `NOT` operator
    public static prefix func ! (clause: CKPredicate<T>) -> CKPredicate<T> {
        CKPredicate<T>(NSCompoundPredicate(type: .not, subpredicates: [clause.predicate]))
    }
    
    
    /// Combines two `CKPredicate` predicates together using `AND` operator.
    /// - returns: `left` if `right` is `nil`, otherwise equivalent to `(left && right)`
    public static func && (left: CKPredicate<T>, right: CKPredicate<T>?) -> CKPredicate<T> {
        if let right = right {
            return left && right
        }
        return left
    }
    
    
    /// Combines two `CKPredicate` predicates together using `AND` operator.
    /// - returns: `right` if `left` is `nil`, otherwise equivalent to `(left && right)`
    public static func && (left: CKPredicate<T>?, right: CKPredicate<T>) -> CKPredicate<T> {
        if let left = left {
            return left && right
        }
        return right
    }
    
    
    /// Combines two `CKPredicate` predicates together using `OR` operator.
    /// - returns: `left` if `right` is `nil`, otherwise equivalent to `(left || right)`
    public static func || (left: CKPredicate<T>, right: CKPredicate<T>?) -> CKPredicate<T> {
        if let right = right {
            return left || right
        }
        return left
    }
    
    
    /// Combines two `CKPredicate` predicates together using `OR` operator.
    /// - returns: `right` if `left` is `nil`, otherwise equivalent to `(left || right)`
    public static func || (left: CKPredicate<T>?, right: CKPredicate<T>) -> CKPredicate<T> {
        if let left = left {
            return left || right
        }
        return right
    }
}
