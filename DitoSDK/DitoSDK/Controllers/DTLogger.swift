//
//  DTLogger.swift
//  DitoSDK
//
//  Created by brennobemoura on 06/01/21.
//

import Foundation

/**
 DTLogger is a enum that contains the log level cases to print messages

 It is available the `callAsFunction(_:, separator:)` to print messages after choosing a log level.

 Example for fatal log:

     DTLogger.fatal("Can't init the db")
 */

enum DTLogger: String {
    case fatal = "FATAL"
    case error = "ERROR"
    case warning = "WARNING"
    case information = "INFORMATION"
    case debug = "DEBUG"
    case trace = "TRACE"
}

extension DTLogger {
    /**
     Private log method that will print message using other variables to indicate the timestamp, file name, line, column and the function that cause the message

     - Parameters:
        - object: The object message to be printed
        - filename: The path to the file that called the log event
        - line: Indicates which line of the file the event occurred
        - column: It is combined with the line of the file to exactly find the error
        - function: The name of the function that called the log event
     */
    private func log(
        _ object: Any,
        filename: String = #file,
        line: Int = #line,
        column: Int = #column,
        function: String = #function) {

        if DTLogger.isEnabled {
            let dateString = DTLogger.dateFormatter.string(from: Date())
            let logAtPath = "[\(DTLogger.sourceFileName(filePath: filename))]:\(line) \(column)"
            let functionError = "\(function) -> \"\(object)\""

            print("\(dateString) \(self) \(logAtPath) at \(functionError)")
        }
    }

    /**
     For each case of DTLogger, it is available to call as function method to print messages

     - Parameters:
        - items: The sequence of objects to be printed
        - separator: The separator String used to concatenate the *items* objects
     */
    func callAsFunction(_ items: Any..., separator: String = " ") {
        log(items.map { "\($0)" }.joined(separator: separator))
    }
}

private extension DTLogger {
    /// Can be used to check other flags to print on console
    static var isEnabled: Bool {
        true
    }
}

private extension DTLogger {
    private static var dateFormat = "yyyy-MM-dd hh:mm:ssSSS"

    static var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = dateFormat
        formatter.locale = Locale.current
        formatter.timeZone = TimeZone.current
        return formatter
    }
}

private extension DTLogger {
    /// Private method to get the name of the file only
    static func sourceFileName(filePath: String) -> String {
        filePath.components(separatedBy: "/").last ?? ""
    }
}

/// Overrides Swift.print(_:, separator:, terminator:) function to only print when app is in DEBUG environment
func print(_ items: Any..., separator: String = " ", terminator: String = "\n") {
    #if DEBUG
    Swift.print(items.map { "\($0)" }.joined(separator: separator), terminator: terminator)
    #endif
}
