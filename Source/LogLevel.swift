//
//  LogLevel.swift
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

/// Log Level used in Juliet Logger
public enum LogLevel: Int, CustomStringConvertible {
	// Int defines Log Level Precedence
	case all = 0
	case verbose = 1
	case debug = 2
	case info = 3
	case warning = 4
	case error = 5
	case none = 6
	
	/// Description of Log Level
	public var description: String {
		switch self {
		case .verbose:
			return "VERBOSE"
		case .debug:
			return "DEBUG"
		case .info:
			return "INFO"
		case .warning:
			return "WARNING"
		case .error:
			return "ERROR"
		default:
			assertionFailure("Invalid Log Level")
			return "NULL"
		}
	}
	
	/// Emoji Log Level Indicator
	public var emoji : String {
		switch self {
		case .verbose:
			return "🗣"
		case .debug:
			return "🔧"
		case .info:
			return "📝"
		case .warning:
			return "⚠️"
		case .error:
			return "🚨"
		default:
			assertionFailure("Invalid Log Level")
			return "NULL"
		}
	}
	
	/// Default log level
	/// `LogLevel.all` if in Debug
	/// `LogLevel.warning` if in Production
	#if DEBUG
	static public let defaultLevel = LogLevel.all
	#else
	static public let defaultLevel = LogLevel.warning
	#endif
}
