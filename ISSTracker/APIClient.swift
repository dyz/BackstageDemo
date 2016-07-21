//
//  APIClient.swift
//  ISSTracker
//
//  Created by David Zheng on 7/20/16.
//  Copyright © 2016 David Zheng. All rights reserved.
//

import Foundation

class APIClient : NSObject {
    
    static let sharedClient = APIClient()
    let session = NSURLSession.init(configuration: NSURLSessionConfiguration.defaultSessionConfiguration())
    
    func getNextPassForLocationCoordinates(lat: Double, long: Double, completion: (error: NSError?, data: Dictionary<String, AnyObject>?) -> Void) {
        if let url = NSURL.init(string: constructURLStringForCoordinates(lat, long: long)) {
            let dataTask = session.dataTaskWithURL(url) { (data, response, error) in
                if let response = response as? NSHTTPURLResponse {
                    if (response.statusCode == 200) {
                        do {
                            if let jsonDict = try NSJSONSerialization.JSONObjectWithData(data!, options: .AllowFragments) as? Dictionary<String, AnyObject> {
                                completion(error: nil, data: jsonDict)
                            } else {
                                completion(error: nil, data: nil)
                            }
                        } catch let jsonError as NSError {
                            completion(error: jsonError, data: nil)
                        }
                    } else {
                        completion(error: nil, data: nil)
                    }
                }
            }
            dataTask.resume()
        }
    }
    
    func constructURLStringForCoordinates(lat: Double, long: Double) -> String {
        let latString = String(format: "%.3f", lat)
        let longString = String(format: "%.3f", long)
        return "http://api.open-notify.org/iss-pass.json?lat=\(latString)&lon=\(longString)&n=1"
    }
}