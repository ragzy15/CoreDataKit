//
//  Where.swift
//  CoreDatabase
//
//  Created by Raghav Ahuja on 18/10/19.
//  Copyright © 2019 Raghav Ahuja. All rights reserved.
//

import CoreData

infix operator &&? : LogicalConjunctionPrecedence
infix operator ||? : LogicalConjunctionPrecedence

public struct Where<T: NSManagedObject> {
    let predicate: NSPredicate
    
    init(_ predicate: NSPredicate) {
        self.predicate = predicate
    }
    
    init(_ format: String, args: CVarArg...) {
        let predicate = NSPredicate(format: format, args)
        self.predicate = predicate
    }
    
    init(_ value: Bool) {
        let predicate = NSPredicate(value: value)
        self.predicate = predicate
    }
    
    /**
     Initializes a `Where` clause that compares equality
     
     - parameter keyPath: the keyPath to compare with
     - parameter value: the arguments for the `==` operator
     */
    public init<U: Queryable>(_ keyPath: String, isEqualTo value: U?) {
        switch value {
            
        case nil, is NSNull:
            self.init(NSPredicate(format: "\(keyPath) == nil"))
            
        case let value?:
            self.init(NSPredicate(format: "\(keyPath) == %@", argumentArray: [value.queryableValue]))
        }
    }
    
    /**
     Initializes a `Where` clause with a predicate using the specified string format and arguments
     
     - parameter format: the format string for the predicate
     - parameter args: the arguments for `format`
     */
    public init(_ format: String, _ args: Any...) {
        
        self.init(NSPredicate(format: format, argumentArray: args))
    }
    
    /**
     Initializes a `Where` clause with a predicate using the specified string format and arguments
     
     - parameter format: the format string for the predicate
     - parameter argumentArray: the arguments for `format`
     */
    public init(_ format: String, argumentArray: [Any]?) {
        
        self.init(NSPredicate(format: format, argumentArray: argumentArray))
    }
    
    /**
     Combines two `Where` predicates together using `AND` operator
     */
    public static func && (left: Where<T>, right: Where<T>) -> Where<T> {
        
        return Where<T>(NSCompoundPredicate(type: .and, subpredicates: [left.predicate, right.predicate]))
    }

    /**
     Combines two `Where` predicates together using `OR` operator
     */
    public static func || (left: Where<T>, right: Where<T>) -> Where<T> {
        
        return Where<T>(NSCompoundPredicate(type: .or, subpredicates: [left.predicate, right.predicate]))
    }
    
    /**
     Inverts the predicate of a `Where` clause using `NOT` operator
     */
    public static prefix func ! (clause: Where<T>) -> Where<T> {
        
        return Where<T>(NSCompoundPredicate(type: .not, subpredicates: [clause.predicate]))
    }
        
    /**
     Combines two `Where` predicates together using `AND` operator.
     - returns: `left` if `right` is `nil`, otherwise equivalent to `(left && right)`
     */
    public static func &&? (left: Where<T>, right: Where<T>?) -> Where<T> {
        
        if let right = right {
            
            return left && right
        }
        return left
    }
    
    /**
     Combines two `Where` predicates together using `AND` operator.
     - returns: `right` if `left` is `nil`, otherwise equivalent to `(left && right)`
     */
    public static func &&? (left: Where<T>?, right: Where<T>) -> Where<T> {
        
        if let left = left {
            
            return left && right
        }
        return right
    }
    
    /**
     Combines two `Where` predicates together using `OR` operator.
     - returns: `left` if `right` is `nil`, otherwise equivalent to `(left || right)`
     */
    public static func ||? (left: Where<T>, right: Where<T>?) -> Where<T> {
        
        if let right = right {
            
            return left || right
        }
        return left
    }
    
    /**
     Combines two `Where` predicates together using `OR` operator.
     - returns: `right` if `left` is `nil`, otherwise equivalent to `(left || right)`
     */
    public static func ||? (left: Where<T>?, right: Where<T>) -> Where<T> {
        
        if let left = left {
            
            return left || right
        }
        return right
    }
}
