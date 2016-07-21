//
//  LocationsTableViewCell.swift
//  ISSTracker
//
//  Created by David Zheng on 7/20/16.
//  Copyright © 2016 David Zheng. All rights reserved.
//

import UIKit

class LocationCellData: NSObject {
    
    var name: String
    var latitude: Double
    var longitude: Double
    var nextPass: NSDate?
    
    init(name: String, latitude: Double, longitude: Double, nextPass: NSDate?) {
        self.name = name
        self.latitude = latitude
        self.longitude = longitude
        self.nextPass = nextPass
        super.init()
    }
}

class LocationsTableViewCell: UITableViewCell {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var coordinatesLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var nextPassLabel: UILabel!
    
    func updateWithData(data: LocationCellData) {
        nameLabel.text = data.name
        coordinatesLabel.text = stringFromCoordinates(data.latitude, long: data.longitude)
        if let nextPassDate = data.nextPass {
            dateLabel.text = DateFormatter.sharedInstance.stringForDate(nextPassDate)
            nextPassLabel.hidden = false
        } else {
            dateLabel.text = ""
            nextPassLabel.hidden = true
        }
    }
    
    func updateWithDate(date: NSDate) {
        dateLabel.text = DateFormatter.sharedInstance.stringForDate(date)
        nextPassLabel.hidden = false
    }
    
    func stringFromCoordinates(lat: Double, long: Double) -> String {
        let northSouthString = (lat > 0.0) ? "N" : "S"
        let eastWestString = (long > 0.0) ? "E" : "W"
        
        return String(format: "%.2f°%@\n%.2f°%@", abs(lat), northSouthString, abs(long), eastWestString)
    }
}