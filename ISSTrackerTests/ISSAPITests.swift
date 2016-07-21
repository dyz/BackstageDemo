//
//  ISSAPITests.swift
//  ISSTracker
//
//  Created by David Zheng on 7/20/16.
//  Copyright © 2016 David Zheng. All rights reserved.
//

import XCTest
@testable import ISSTracker

class ISSAPITests: XCTestCase {
    
    func testURLConstruction() {
        let apiClient = ISSAPIClient.sharedClient
        let string1 = apiClient.constructURLStringForCoordinates(45.0, long: 35.0)
        let string2 = apiClient.constructURLStringForCoordinates(-53.23, long: -58.93)
        let string3 = apiClient.constructURLStringForCoordinates(83.338822, long: -49.4838282)
        
        XCTAssertEqual(string1, "http://api.open-notify.org/iss-pass.json?lat=45.000&lon=35.000")
        XCTAssertEqual(string2, "http://api.open-notify.org/iss-pass.json?lat=-53.230&lon=-58.930")
        XCTAssertEqual(string3, "http://api.open-notify.org/iss-pass.json?lat=83.339&lon=-49.484")
    }
    
}