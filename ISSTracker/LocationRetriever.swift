//
//  LocationRetriever.swift
//  ISSTracker
//
//  Created by David Zheng on 7/20/16.
//  Copyright © 2016 David Zheng. All rights reserved.
//

import Foundation
import CoreLocation

class LocationRetriever: NSObject {
    static let sharedInstance = LocationRetriever()
    let geocoder = CLGeocoder()
    let locationManager = CLLocationManager()
    
    func getCoordinatesFromAddressString(address: String, completion: (lat: Double, long: Double)? -> Void) {
        geocoder.geocodeAddressString(address) { (placemark, error) in
            if (error != nil) {
                print(error)
                completion(nil)
            } else {
                if let placemark = placemark {
                    let firstPlacemark = placemark.first //take first location; could possibly have mulitple results
                    let coordinate = firstPlacemark?.location?.coordinate
                    if let coordinate = coordinate {
                        let loc = (coordinate.latitude, coordinate.longitude)
                        completion(loc)
                    } else {
                        completion(nil)
                    }
                } else {
                    completion(nil)
                }
            }
        }
    }
    
//    func getCurrentLocation() {
//        locationManager.requestAlwaysAuthorization()
//        locationManager.requestWhenInUseAuthorization()
//        
//        if CLLocationManager
//    }
}
