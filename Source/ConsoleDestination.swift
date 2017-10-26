//
//  ConsoleDestination.swift
//  Houston
//
//  Copyright (c) 2017 Rudy Bermudez
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

public class ConsoleDestination: BaseDestination {
	
	/// Use NSLog instead of print
	public var useNSLog = false
	
	override public var defaultHashValue: Int { return 1 }
	
	public override init() {
		super.init()
	}
	
	/// Accepts the log and Outputs the details to the Console
	override public func acceptLog(_ level: LogLevel, function: String, file: String, line: Int, message: String) -> String? {
		let formattedString = super.acceptLog(level, function: function, file: file, line: line, message: message)
		if let str = formattedString {
			if useNSLog {
				#if os(Linux)
					print(str)
				#else
					NSLog("%@", str)
				#endif
			} else {
				print(str)
			}
		}
		return formattedString
	}
}