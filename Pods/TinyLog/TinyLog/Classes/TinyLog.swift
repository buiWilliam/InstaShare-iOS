//
//  TinyLog.swift
//  TinyLog
//
//  Created by DragonCherry on 1/11/17.
//  Copyright © 2017 DragonCherry. All rights reserved.
//

import Foundation

public class TinyLog {
    public static var stripParameters: Bool = true
    public static var isShowInfoLog = true
    public static var isShowErrorLog = true
}

fileprivate class TinyLogDateFormatter {
    // MARK: Singleton
    fileprivate static let `default`: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss.SSS"
        return formatter
    }()
}

fileprivate func fileName(_ filePath: String) -> String {
    let lastPathComponent = NSString(string: filePath).lastPathComponent
    if let name = lastPathComponent.components(separatedBy: ".").first {
        return name
    } else {
        return lastPathComponent
    }
}

fileprivate func functionNameByStrippingParameters(_ function: String) -> String {
    if let startIndex = function.index(of: "(") {
        return String(function[..<startIndex])
    } else {
        return function
    }
}

public func log(_ msg: Any? = nil, _ prefix: String = "⚫", _ file: String = #file, _ function: String = #function, _ line: Int = #line) {
    #if DEBUG
        if let msg = msg {
            print("\(TinyLogDateFormatter.default.string(from: Date())) \(prefix)\(fileName(file)).\(TinyLog.stripParameters ? functionNameByStrippingParameters(function) : function):\(line) - \(msg)")
        } else {
            print("\(TinyLogDateFormatter.default.string(from: Date())) \(prefix)\(fileName(file)).\(TinyLog.stripParameters ? functionNameByStrippingParameters(function) : function):\(line)")
        }
    #endif
}

public func logi(_ msg: Any?, _ file: String = #file, _ function: String = #function, _ line: Int = #line) {
    if TinyLog.isShowInfoLog { log(msg, "💙", file, function, line) }
}

public func logv(_ msg: Any?, _ file: String = #file, _ function: String = #function, _ line: Int = #line) {
    if TinyLog.isShowInfoLog { log(msg, "⚫", file, function, line) } // I put a black circle instead of black heart since it's available from iOS 10.2.
}

public func logd(_ msg: Any?, _ file: String = #file, _ function: String = #function, _ line: Int = #line) {
    if TinyLog.isShowInfoLog { log(msg, "💚", file, function, line) }
}

public func logw(_ msg: Any?, _ file: String = #file, _ function: String = #function, _ line: Int = #line) {
    if TinyLog.isShowErrorLog { log(msg, "💛", file, function, line) }
}

public func loge(_ msg: Any?, _ file: String = #file, _ function: String = #function, _ line: Int = #line) {
    if TinyLog.isShowErrorLog { log(msg, "❤️", file, function, line) }
}
    
public func logc(_ msg: Any?, _ file: String = #file, _ function: String = #function, _ line: Int = #line) {
    if TinyLog.isShowErrorLog { log(msg, "💔", file, function, line) }
}
