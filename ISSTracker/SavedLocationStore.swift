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
    
    func saveLocationsToDisk(locations: [SavedLocation]) {
        saveLocationsToDisk(locations, path: defaultPath())
    }
    
    func saveLocationsToDisk(locations: [SavedLocation], path: String) {
        NSKeyedArchiver.archiveRootObject(locations, toFile: path)
    }
    
    func getSavedLocationsFromDisk() -> [SavedLocation] {
        return getSavedLocationsFromDisk(defaultPath())
    }
    
    func getSavedLocationsFromDisk(path: String) -> [SavedLocation] {
        if let savedLocations = NSKeyedUnarchiver.unarchiveObjectWithFile(path) as? [SavedLocation] {
            return savedLocations
        }
        return []
    }
    
    func defaultPath() -> String {
        let directory = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true).first
        return directory?.stringByAppendingString("locations") ?? "defaultPath"
    }
    
}