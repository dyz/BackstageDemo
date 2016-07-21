//
//  SavedLocationStore.swift
//  ISSTracker
//
//  Created by David Zheng on 7/20/16.
//  Copyright © 2016 David Zheng. All rights reserved.
//

import Foundation

class SavedLocationStore: NSObject {
    static let sharedInstance = SavedLocationStore()
    var cachedSavedLocations : [SavedLocation]? = nil
    var useCache = true
    
    func saveLocationsToDisk(locations: [SavedLocation]) {
        saveLocationsToDisk(locations, path: defaultPath())
    }
    
    func saveLocationsToDisk(locations: [SavedLocation], path: String) {
        NSKeyedArchiver.archiveRootObject(locations, toFile: path)
        cachedSavedLocations = locations
        NSNotificationCenter.defaultCenter().postNotificationName("kSavedLocationsUpdated", object: self)
    }
    
    func saveLocationToDisk(loc: SavedLocation) {
        saveLocationToDisk(loc, path: defaultPath())
    }
    
    func saveLocationToDisk(loc: SavedLocation, path: String) {
        var savedLocations = (useCache) ? (cachedSavedLocations ?? getSavedLocationsFromDisk(path)) : getSavedLocationsFromDisk(path)
        savedLocations.append(loc)
        saveLocationsToDisk(savedLocations, path: path)
    }
    
    func getSavedLocationsFromDisk() -> [SavedLocation] {
        return getSavedLocationsFromDisk(defaultPath())
    }
    
    func getSavedLocationsFromDisk(path: String) -> [SavedLocation] {
        if let savedLocations = NSKeyedUnarchiver.unarchiveObjectWithFile(path) as? [SavedLocation] {
            cachedSavedLocations = savedLocations
            return savedLocations
        }
        cachedSavedLocations = nil
        return []
    }
    
    func defaultPath() -> String {
        let directory = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true).first
        return directory?.stringByAppendingString("/locations.archive") ?? ""
    }
    
    func deleteSavedLocations() {
        do {
            try NSFileManager.defaultManager().removeItemAtPath(defaultPath())
            cachedSavedLocations = nil
            NSNotificationCenter.defaultCenter().postNotificationName("kSavedLocationsUpdated", object: self)
        } catch let error as NSError {
            print("error deleting file: \(error)")
        }
    }
    
}