//
//  LocationStoreTests.swift
//  ISSTracker
//
//  Created by David Zheng on 7/20/16.
//  Copyright © 2016 David Zheng. All rights reserved.
//

import XCTest
@testable import ISSTracker

class LocationStoreTests: XCTestCase {
    let testPath = "/testLocations.archive"
    let savedLocationStore = SavedLocationStore.sharedInstance
    let fileManager = NSFileManager.defaultManager()

    override func setUp() {
        super.setUp()
        savedLocationStore.useCache = false
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func deleteTestFile() {
        do {
            try fileManager.removeItemAtPath(getTestFilePath())
        } catch let error as NSError {
            print("error deleting test file path: \(error)")
        }
    }
    
    func getTestFilePath() -> String {
        let directory = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true).first
        return directory?.stringByAppendingString(testPath) ?? ""
    }
    
    func testSavingLocations() {
        let loc1 = SavedLocation(name: "David", latitude: 12.0, longitude: 13.0)
        let loc2 = SavedLocation(name: "Zavid", latitude: 11.0, longitude: 14.0)
        
        let locations = [loc1, loc2]
        
        let path = getTestFilePath()
        
        XCTAssert(!fileManager.fileExistsAtPath(path))
        savedLocationStore.saveLocationsToDisk(locations, path: path)
        XCTAssert(fileManager.fileExistsAtPath(path))
        
        let storedLocs = savedLocationStore.getSavedLocationsFromDisk(path)
        XCTAssertNotNil(storedLocs)
        XCTAssertEqual(storedLocs.count, 2)
        XCTAssert(areEqual(storedLocs[0], loc2: loc1))
        XCTAssert(areEqual(storedLocs[1], loc2: loc2))
        
        deleteTestFile()
        
    }
    
    func testAddLocations() {
        let loc1 = SavedLocation(name: "David", latitude: 12.0, longitude: 13.0)
        let path = getTestFilePath()
        
        SavedLocationStore.sharedInstance.saveLocationToDisk(loc1, path: path)
        var storedLocs = savedLocationStore.getSavedLocationsFromDisk(path)
        
        XCTAssertNotNil(storedLocs)
        XCTAssertEqual(storedLocs.count, 1)
        
        
        let loc2 = SavedLocation(name: "Zavid", latitude: 11.0, longitude: 14.0)
        SavedLocationStore.sharedInstance.saveLocationToDisk(loc2, path: path)
        storedLocs = savedLocationStore.getSavedLocationsFromDisk(path)
        
        XCTAssertNotNil(storedLocs)
        XCTAssertEqual(storedLocs.count, 2)
        
        deleteTestFile()
    }
    
    func areEqual(loc1: SavedLocation, loc2: SavedLocation) -> Bool {
        return (loc1.name == loc2.name) && (loc1.latitude == loc2.latitude) && (loc1.longitude == loc2.longitude)
    }
    
    

}
