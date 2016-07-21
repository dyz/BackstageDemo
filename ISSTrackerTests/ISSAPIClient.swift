//
//  ISSAPIClient.swift
//  ISSTracker
//
//  Created by David Zheng on 7/20/16.
//  Copyright © 2016 David Zheng. All rights reserved.
//

import Foundation

class ISSAPIClient : NSObject {
    static let sharedClient = ISSAPIClient()
    let session = NSURLSession.init(configuration: NSURLSessionConfiguration.defaultSessionConfiguration())
    
    func getNextPassForLocationCoordinates(lat: Double, long: Double) {
        if let url = NSURL.init(string: constructURLStringForCoordinates(lat, long: long)) {
            let dataTask = session.dataTaskWithURL(url) { (data, response, error) in
                if let response = response {
                    //do something
                }
            }
            
            dataTask.resume()
        }
    }
    
    func constructURLStringForCoordinates(lat: Double, long: Double) -> String {
        let latString = String(format: "%.3f", lat)
        let longString = String(format: "%.3f", long)
        return "http://api.open-notify.org/iss-pass.json?lat=\(latString)&lon=\(longString)"
    }
}