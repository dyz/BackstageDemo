//
//  LocationTests.swift
//  ISSTracker
//
//  Created by David Zheng on 7/20/16.
//  Copyright © 2016 David Zheng. All rights reserved.
//

import XCTest
@testable import ISSTracker

class LocationTests: XCTestCase {
    let locationRetriever = LocationRetriever.sharedInstance
    
    func testBadLocationRetrieval() {
        weak var expectation = expectationWithDescription("Testing a bad address")
        locationRetriever.getCoordinatesFromAddressString("This should fail") { (loc) in
            XCTAssertNil(loc)
            expectation?.fulfill()
            expectation = nil
        }
        
        waitForExpectationsWithTimeout(10) { (error) in
            if let error = error {
                XCTFail("waitForExpecations failed: \(error)")
            }
        }
    }
    
    func testCityNameLocationRetrieval() {
        weak var expectation = expectationWithDescription("Testing city name")
        locationRetriever.getCoordinatesFromAddressString("Princeton, NJ") { (loc) in
            XCTAssertNotNil(loc)
            if let loc = loc {
                XCTAssert(self.locationIsPrinceton(loc))
            }
            expectation?.fulfill()
            expectation = nil
        }
        
        waitForExpectationsWithTimeout(10) { (error) in
            if let error = error {
                XCTFail("waitForExpecations failed: \(error)")
            }
        }
    }
    
    func testZipLocationRetrieval() {
        weak var expectation = expectationWithDescription("Testing zip code")
        locationRetriever.getCoordinatesFromAddressString("08540") { (loc) in
            XCTAssertNotNil(loc)
            if let loc = loc {
                XCTAssert(self.locationIsPrinceton(loc))
            }
            expectation?.fulfill()
            expectation = nil
        }
        
        waitForExpectationsWithTimeout(10) { (error) in
            if let error = error {
                XCTFail("waitForExpecations failed: \(error)")
            }
        }
    }
    
    func locationIsPrinceton(loc: (long: Double, lat: Double)) -> Bool{
        let marginOfError = 0.1
        return (abs(loc.long - (-74.66)) < marginOfError) && (abs(loc.lat - 40.35) < marginOfError)
    }
}
