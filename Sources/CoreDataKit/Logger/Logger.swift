//
//  Logger.swift
//  CoreDataKit
//
//  Created by Raghav Ahuja on 18/10/19.
//  Copyright © 2019 Raghav Ahuja. All rights reserved.
//

import Foundation

public final class CKLogger {
    
    var isEnabled: Bool
    
    func typeName<T>(_ value: T) -> String {
        String(reflecting: type(of: value))
    }
    
    func typeName<T>(_ value: T.Type) -> String {
        String(reflecting: value)
    }
    /**
     Creates a `CKLogger`.
     */
    init(isEnabled e: Bool) { isEnabled = e }
    
    /**
     Handles errors sent by the `CoreDataKit`.
     
     - parameter error: Error occurred.
     - parameter file: Source file name.
     - parameter line: Source line number.
     - parameter function: Source function name.
     */
    func log(error: NSError, file: StaticString = #file, line: UInt = #line, function: StaticString = #function) {
        
        #if DEBUG
        guard isEnabled else { return }
        
        Swift.print("⚠️ [CoreDataKit: Error] \((String(describing: file) as NSString).lastPathComponent):\(line) \(function)\n  ↪︎ \(error)\n")
        #endif
    }
    
    /**
     Handles assertions made throughout the `CoreDataKit`.
     
     - parameter condition: Assertion condition.
     - parameter message: Assertion failure message.
     - parameter file: Source file name.
     - parameter line: Source line number.
     - parameter function: Source function name.
     */
    func assert(_ condition: @autoclosure () -> Bool, _ message: @autoclosure () -> String, file: StaticString = #file, line: UInt = #line, function: StaticString = #function) {
        
        #if DEBUG
        guard isEnabled else { return }
        
        let condition = condition()
        
        if condition { return }
        
        let message = message()
        
        Swift.print("❗ [CoreDataKit: Assertion Failure] \((String(describing: file) as NSString).lastPathComponent):\(line) \(function)\n  ↪︎ \(message)\n")
        Swift.assert(condition, message, file: file, line: line)
        #endif
    }
    
    /**
     Handles preconditions made throughout the `CoreDataKit`.
     
     - parameter condition: Precondition to be satisfied.
     - parameter message: Precondition failure message.
     - parameter file: Source file name.
     - parameter line: Source line number.
     - parameter function: Source function name.
     */
    func precondition(_ condition: @autoclosure () -> Bool, _ message: @autoclosure () -> String, file: StaticString = #file, line: UInt = #line, function: StaticString = #function) {
        
        let condition = condition()
        
        if condition { return }
        
        let message = message()
        
        Swift.print("❗ [CoreDataKit: Precondition Failure] \((String(describing: file) as NSString).lastPathComponent):\(line) \(function)\n  ↪︎ \(message)\n")
        Swift.preconditionFailure(message, file: file, line: line)
    }
    
    /**
     Handles fatal errors made throughout the `CoreDataKit`.
     - Important: Implementers should guarantee that this function doesn't return, either by calling another `Never` function such as `fatalError()` or `abort()`, or by raising an exception.
     
     - parameter message: Fatal error message.
     - parameter file: Source file name.
     - parameter line: Source line number.
     - parameter function: Source function name.
     */
    func fatalError(_ message: @autoclosure () -> String, file: StaticString = #file, line: UInt = #line, function: StaticString = #function) -> Never {
        
        let message = message()
        Swift.print("❗ [CoreDataKit: Fatal Error] \((String(describing: file) as NSString).lastPathComponent):\(line) \(function)\n  ↪︎ \(message)\n")
        Swift.fatalError(message, file: file, line: line)
    }
}

