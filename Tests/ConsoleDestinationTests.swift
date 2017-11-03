//
//  ConsoleDestinationTests.swift
//  HoustonTests
//
//  Created by Rudy Bermudez on 10/26/17.
//  Copyright © 2017 Houston. All rights reserved.
//

import XCTest
@testable import Houston
class ConsoleDestinationTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
		Logger.removeAllDestinations()
		
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testAcceptLog() {
        let baseDest = BaseDestination()
        let consoleDest = ConsoleDestination()
		baseDest.showDateTime = false
        consoleDest.showDateTime = false
        let baseOutput = baseDest.acceptLog(.verbose, function: "Function", file: "File", line: 10, message: "Should Be Equal")
        let consoleOutput = consoleDest.acceptLog(.verbose, function: "Function", file: "File", line: 10, message: "Should Be Equal")

        XCTAssertEqual(baseOutput, consoleOutput)

    }
	
}
