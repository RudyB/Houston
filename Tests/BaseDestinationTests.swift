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
	
    func testFormatting() {
        let dest = BaseDestination()
		var output = ""
		var input = ""
		
		// Test empty
		dest.showDateTime = false
		output = dest.formatLogOutput(.debug, function: "Function()", file: "/Path/to/file/this.swift", line: 34, message: input)

		XCTAssertEqual(output, "this.Function():34 🔧 Debug: ")
		
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
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}
