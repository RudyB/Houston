//
//  LoggerTests.swift
//  HoustonTests
//
//  Created by Rudy Bermudez on 10/26/17.
//  Copyright © 2017 Houston. All rights reserved.
//

import XCTest
@testable import Houston

class LoggerTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
		Logger.removeAllDestinations()
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
	
	func testAddDestination() {
		XCTAssertEqual(Logger.countDestinations(), 0)
		
		let consoleDestination = ConsoleDestination()
		Logger.add(destination: consoleDestination)
		XCTAssertEqual(Logger.countDestinations(), 1)
		
		// Add Duplicate
		Logger.add(destination: consoleDestination)
		XCTAssertEqual(Logger.countDestinations(), 1)
		
		let consoleDestination2 = ConsoleDestination()
		Logger.add(destination: consoleDestination2)
		XCTAssertEqual(Logger.countDestinations(), 2)
	}
	
	func testRemoveDesination() {
		assert(Logger.countDestinations() == 0)
		
		let consoleDestination = ConsoleDestination()
		Logger.add(destination: consoleDestination)
		XCTAssertEqual(Logger.countDestinations(), 1)
		
		let consoleDestination2 = ConsoleDestination()
		Logger.add(destination: consoleDestination2)
		XCTAssertEqual(Logger.countDestinations(), 2)
		
		// Remove an object that does not exist
		let consoleDestination3 = ConsoleDestination()
		Logger.remove(destination: consoleDestination3)
		XCTAssertEqual(Logger.countDestinations(), 2)
		
		Logger.remove(destination: consoleDestination2)
		XCTAssertEqual(Logger.countDestinations(), 1)
		Logger.remove(destination: consoleDestination)
		XCTAssertEqual(Logger.countDestinations(), 0)
		
	}
	
	func testRemoveAllDestinations() {
		assert(Logger.countDestinations() == 0)
		
		let consoleDestination = ConsoleDestination()
		Logger.add(destination: consoleDestination)
		XCTAssertEqual(Logger.countDestinations(), 1)

		
		let consoleDestination2 = ConsoleDestination()
		Logger.add(destination: consoleDestination2)
		XCTAssertEqual(Logger.countDestinations(), 2)
	
		Logger.removeAllDestinations()
		XCTAssertEqual(Logger.countDestinations(), 0)
	}
	
	func testVerboseLog() {
		let testDestination = TestDestination()
		testDestination.asynchronously = false
		Logger.add(destination: testDestination)
		
		Logger.verbose("Test",file: "Some File", function: "Some Function", line: 1)
	
		XCTAssertEqual(testDestination.didSendMessage, "Test")
		XCTAssertEqual(testDestination.didSendFileName, "Some File")
		XCTAssertEqual(testDestination.didSendFunctionName, "Some Function")
		XCTAssertEqual(testDestination.didSendLineNumber, 1)
		XCTAssertEqual(testDestination.didSendLevel, LogLevel.verbose)
	}
	
	func testDebugLog() {
		let testDestination = TestDestination()
		testDestination.asynchronously = false
		Logger.add(destination: testDestination)
		
		Logger.debug("Test",file: "Some File", function: "Some Function", line: 1)
		XCTAssertEqual(testDestination.didSendMessage, "Test")
		XCTAssertEqual(testDestination.didSendFileName, "Some File")
		XCTAssertEqual(testDestination.didSendFunctionName, "Some Function")
		XCTAssertEqual(testDestination.didSendLineNumber, 1)
		XCTAssertEqual(testDestination.didSendLevel, LogLevel.debug)
	}
	
	func testInfoLog() {
		let testDestination = TestDestination()
		testDestination.asynchronously = false
		Logger.add(destination: testDestination)
		
		Logger.info("Test",file: "Some File", function: "Some Function", line: 1)
		
		XCTAssertEqual(testDestination.didSendMessage, "Test")
		XCTAssertEqual(testDestination.didSendFileName, "Some File")
		XCTAssertEqual(testDestination.didSendFunctionName, "Some Function")
		XCTAssertEqual(testDestination.didSendLineNumber, 1)
		XCTAssertEqual(testDestination.didSendLevel, LogLevel.info)
	}
	
	func testWarningLog() {
		let testDestination = TestDestination()
		testDestination.asynchronously = false
		Logger.add(destination: testDestination)
		
		
		Logger.warning("Test",file: "Some File", function: "Some Function", line: 1)
		
		XCTAssertEqual(testDestination.didSendMessage, "Test")
		XCTAssertEqual(testDestination.didSendFileName, "Some File")
		XCTAssertEqual(testDestination.didSendFunctionName, "Some Function")
		XCTAssertEqual(testDestination.didSendLineNumber, 1)
		XCTAssertEqual(testDestination.didSendLevel, LogLevel.warning)
	}
	
	func testErrorLog() {
		let testDestination = TestDestination()
		testDestination.asynchronously = false
		Logger.add(destination: testDestination)
		
		Logger.error("Test",file: "Some File", function: "Some Function", line: 1)
		
		XCTAssertEqual(testDestination.didSendMessage, "Test")
		XCTAssertEqual(testDestination.didSendFileName, "Some File")
		XCTAssertEqual(testDestination.didSendFunctionName, "Some Function")
		XCTAssertEqual(testDestination.didSendLineNumber, 1)
		XCTAssertEqual(testDestination.didSendLevel, LogLevel.error)
	}
	
	func testMinimumLogLevel() {
		let testDestination = TestDestination()
		testDestination.asynchronously = false
		Logger.add(destination: testDestination)
		
		testDestination.minLevel = .warning
		
		Logger.verbose("This shouldn't fire")
		XCTAssertEqual(testDestination.shouldLogLevel, LogLevel.verbose)
		XCTAssertNil(testDestination.didSendMessage)
		
		Logger.warning("This should fire")
		XCTAssertEqual(testDestination.shouldLogLevel, LogLevel.warning)
		XCTAssertEqual(testDestination.didSendMessage, "This should fire")
	}
	
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
	
	private class TestDestination: BaseDestination {
		var didSendLevel: LogLevel?
		var didSendFileName: String?
		var didSendFunctionName: String?
		var didSendLineNumber: Int?
		var didSendMessage: String?
		
		override func acceptLog(_ level: LogLevel, function: String, file: String, line: Int, message: String) -> String? {
			didSendLevel = level
			didSendFileName = file
			didSendFunctionName = function
			didSendLineNumber = line
			didSendMessage = message
			return super.acceptLog(level, function: function, file: file, line: line, message: message)
		}

		var shouldLogLevel: LogLevel?

		override func shouldLevelBeLogged(_ level: LogLevel) -> Bool {
			shouldLogLevel = level
			return super.shouldLevelBeLogged(level)
		}

		
	}
    
}
