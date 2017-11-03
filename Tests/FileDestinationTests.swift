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
	
	func testIsFileWritten() {
		
		
		let path = "/tmp/testHouston.log"
		deleteFile(path: path)
		
		// add file
		let dest = FileDestination()
		dest.logFileURL = URL(string: "file://" + path)!
		dest.minLevel = .all
		dest.showDateTime = false
		dest.showFileName = false
		dest.showFunctionName = false
		dest.showLineNumber = false
		dest.showLogLevelEmoji = false
		Logger.add(destination: dest)
		
		Logger.verbose("line 1")
		Logger.debug("line 2")
		Logger.info("line 3")
		
		// wait a bit until the logs are written to file
		for i in 1...200000 {
			let x = sqrt(Double(i))
			XCTAssertEqual(x, sqrt(Double(i)))
		}
		
		// was the file written and does it contain the lines?
		let fileLines = self.linesOfFile(path: path)
		XCTAssertNotNil(fileLines)
		guard let lines = fileLines else { return }
		XCTAssertEqual(lines.count, 4)
		XCTAssertEqual(lines[0], "VERBOSE: line 1")
		XCTAssertEqual(lines[1], "DEBUG: line 2")
		XCTAssertEqual(lines[2], "INFO: line 3")
		XCTAssertEqual(lines[3], "")
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
	
	func testDeleteFile() {
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
	
	// MARK: Helper Functions
	// deletes a file if it is existing
	func deleteFile(path: String) {
		do {
			try FileManager.default.removeItem(atPath: path)
		} catch {}
	}
	
	// returns the lines of a file as optional array which is nil on error
	func linesOfFile(path: String) -> [String]? {
		do {
			// try to read file
			let fileContent = try NSString(contentsOfFile: path, encoding: String.Encoding.utf8.rawValue)
			return fileContent.components(separatedBy: "\n")
		} catch let error {
			print(error)
			return nil
		}
	}
}
