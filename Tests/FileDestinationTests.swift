//
//  FileDestinationTests.swift
//  Houston
//
//  Created by Rudy Bermudez on 11/3/17.
//  Copyright © 2017 Houston. All rights reserved.
//

import XCTest
@testable import Houston

class FileDestinationTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
		Logger.removeAllDestinations()
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
	func testAccceptLog() {
		let dest = FileDestination()
		dest.showDateTime = false
		let formattedOutput = dest.acceptLog(.warning, function: "Function", file: "File", line: 19, message: "Message")
		
		let baseDest = BaseDestination()
		baseDest.showDateTime = false
		let baseOutput = baseDest.acceptLog(.warning, function: "Function", file: "File", line: 19, message: "Message")
		
		XCTAssertEqual(formattedOutput, baseOutput)
		
	}
	
	func testDeleteLog() {
		let dest = FileDestination()
		Logger.add(destination: dest)
		Logger.error("Some Error Message")
		let result = dest.deleteLogFile()
		
		// Fake URL
		let customURL: URL = (FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("asdasd.log", isDirectory: false))!
		
		dest.logFileURL = customURL
		let output = dest.deleteLogFile()
		XCTAssertTrue(output)
	}
	
	func testCustomPath() {
		let dest = FileDestination()
		
		let customURL: URL = (FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Test.log", isDirectory: false))!
		
		dest.logFileURL = customURL
		Logger.add(destination: dest)
		Logger.error("Some Error Message")
		Logger.warning("Some Warning Message")
		
		let fileManager = FileManager.default

		// wait a bit until the logs are written to file
		for i in 1...100000 {
			let x = sqrt(Double(i))
			XCTAssertEqual(x, sqrt(Double(i)))
		}
		XCTAssertTrue(fileManager.fileExists(atPath: customURL.path))
		
		let fileDeletionOutput = dest.deleteLogFile()
		XCTAssertNotEqual(fileDeletionOutput, fileManager.fileExists(atPath: customURL.path))
		
		dest.logFileURL = nil
		let output = dest.saveToFile("Should be false")
		XCTAssertFalse(output)
		
		
		
	}
}
