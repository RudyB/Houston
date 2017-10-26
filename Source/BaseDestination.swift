//
//  BaseDestination.swift
//  Houston
//
//	Copyright (c) 2017 Rudy Bermudez
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.
//


import Foundation

open class BaseDestination: Hashable {
	
	// MARK: - Output Format Configuration
	
	/// Show the date and time in the log output
	public var showDateTime = true
	
	/// Configure the DateFormat
	public var dateFormat = "HH:mm:ss.SSS"
	
	/// Configure the timezone for the DateFormat
	public var timeZone: TimeZone? = TimeZone(abbreviation: "UTC")

	/// Displays the textual representation of the log level in the log output
	///
	/// Ex. `Warning`
	public var showLogLevel = true
	
	/// Displays the Log Level Emoji Indicator in the log output
	///
	/// Ex. ⚠️
	public var showLogLevelEmoji = true
	
	/// Display the file name in the log output
	public var showFileName = true
	
	/// Display the line number in the log output
	public var showLineNumber = true
	
	/// Display the function name in the log output
	public var showFunctionName = true
	
	/// Denotes the minimum logging level
	public var minLevel = LogLevel.defaultLevel
	
	/// Executes logger on `Juliet` serial background thread for better performance
	open var asynchronously = true
	
	/// The queue of the Output Destination
	var queue: DispatchQueue?
	
	
	// MARK: - Base Methods
	public init() {
		let uuid = NSUUID().uuidString
		let queueLabel = "Juliet-queue-" + uuid
		queue = DispatchQueue(label: queueLabel, target: queue)
	}
	
	/// Accepts a log and formats the log data points
	open func acceptLog(_ level: LogLevel, function: String, file: String, line: Int, message: String) -> String? {
		return formatLogOutput(level, function: function, file: file, line: line, message: message)
	}
	
	
	
	// MARK: - Formatting
	
	/// Formatter for date and text formatting
	let formatter = DateFormatter()
	
	/// Formats the log output with the user configurable settings in `Output Format Configuration` section
	private func formatLogOutput(_ level: LogLevel, function: String, file: String, line: Int, message: String) -> String {
		var dateComponent = ""
		var fileName = ""
		var functionName = ""
		var lineNumber = ""
		var levelDescription = ""
		var emoji = ""
		
		if showDateTime {
			dateComponent = "[\(formatDate(dateFormat))]"
		}
		if showFileName {
			fileName = fileNameOfFileWithoutFileType(file)
			if showFunctionName {
				fileName += "."
			} else {
				fileName += " "
			}
		}
		if showFunctionName {
			functionName = function
		}
		if showLineNumber {
			lineNumber = ":\(line)"
		}
		if showLogLevelEmoji {
			emoji = level.emoji
		}
		if showLogLevel {
			levelDescription = level.description
		}
		return "\(dateComponent) \(fileName)\(functionName)\(lineNumber) \(emoji) \(levelDescription): \(message)"
	}
	
	/// Format Date with user defined `dateFormat`
	func formatDate(_ dateFormat: String) -> String {
		formatter.timeZone = timeZone
		formatter.dateFormat = dateFormat
		let dateStr = formatter.string(from: Date())
		return dateStr
	}
	
	
	/// Return the filename of a path
	private func fileNameOfFile(_ file: String) -> String {
		let fileParts = file.components(separatedBy: "/")
		if let lastPart = fileParts.last {
			return lastPart
		}
		return ""
	}
	
	/// Returns the filename of a path without the file type ending
	private func fileNameOfFileWithoutFileType(_ file: String) -> String {
		let fileParts = fileNameOfFile(file).components(separatedBy: ".")
		if let firstPart = fileParts.first {
			return firstPart
		}
		return ""
	}
	
	// MARK: - Helpers
	
	/// Returns whether the outputter should accept a log statement
	func shouldLevelBeLogged(_ level: LogLevel) -> Bool {
		if level.rawValue >= minLevel.rawValue {
			return true
		} else {
			return false
		}
	}
	
	// MARK: - Hashable and Equitable
	lazy public var hashValue: Int = self.defaultHashValue
	open var defaultHashValue: Int {return 0}
	
	public static func ==(lhs: BaseDestination, rhs: BaseDestination) -> Bool {
		return ObjectIdentifier(lhs) == ObjectIdentifier(rhs)
	}
	
	
}