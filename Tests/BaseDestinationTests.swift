//
//  BaseDestinationTests.swift
//  HoustonTests
//
//  Created by Rudy Bermudez on 10/26/17.
//  Copyright © 2017 Houston. All rights reserved.
//

import XCTest

@testable import Houston

class BaseDestinationTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
	
	func testInit() {
		let dest = BaseDestination()
		XCTAssertNotNil(dest.queue)
	}
	
	func testFileFormatting() {
		let dest = BaseDestination()
		var output = ""

		output = dest.fileNameOfFileWithoutFileType("/Path/to/ViewController.swift")
		XCTAssertEqual(output, "ViewController")
	}
	
	func testJSONFormatting() {
		let dest = BaseDestination()
		var output = ""
		dest.outputFormat = .json
		Logger.add(destination: dest)
		output = dest.acceptLog(.error, function: "Function", file: "File", line: 12, message: "Error Message")!
	}
	
    func testFormatting() {
        let dest = BaseDestination()
		var output = ""
		let input = ""
		
		// Test empty
		dest.showDateTime = false
		output = dest.formatLogOutput(.debug, function: "Function()", file: "/Path/to/file/this.swift", line: 34, message: input)

		XCTAssertEqual(output, "this.Function():34 🔧 DEBUG: ")
		
		dest.showFunctionName = false
		output = dest.formatLogOutput(.debug, function: "Function()", file: "/Path/to/file/this.swift", line: 34, message: input)
		
		XCTAssertEqual(output, "this:34 🔧 DEBUG: ")
		
		dest.showLineNumber = false
		output = dest.formatLogOutput(.debug, function: "Function()", file: "/Path/to/file/this.swift", line: 34, message: input)
		
		XCTAssertEqual(output, "this 🔧 DEBUG: ")
		
		// Test date format
		let date = Date()
		
		let dateFormat = "hh:mm:ss"
		let dateFormatter = DateFormatter()
		dateFormatter.timeZone = TimeZone(abbreviation: "PST")
		dateFormatter.dateFormat = dateFormat
		let referenceDate = dateFormatter.string(from: date)
		
		dest.showDateTime = true
		dest.timeZone = TimeZone(abbreviation: "PST")
		output = dest.formatDate(dateFormat)
		XCTAssertEqual(referenceDate, output)
		
	}
    
}
