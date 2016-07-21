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
    var currentlyOverhead: Bool
    
    init(name: String, latitude: Double, longitude: Double, nextPass: NSDate?) {
        self.name = name
        self.latitude = latitude
        self.longitude = longitude
        self.nextPass = nextPass
        self.currentlyOverhead = false
        super.init()
    }
}

class LocationsTableViewCell: UITableViewCell {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var coordinatesLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var nextPassLabel: UILabel!
    @IBOutlet weak var currentlyAboveLabel: UILabel!
    
    func updateWithData(data: LocationCellData) {
        nameLabel.text = data.name
        coordinatesLabel.text = stringFromCoordinates(data.latitude, long: data.longitude)
        if data.currentlyOverhead {
            currentlyAboveLabel.hidden = false
            dateLabel.text = ""
            nextPassLabel.hidden = true
        } else {
            currentlyAboveLabel.hidden = true
            if let nextPassDate = data.nextPass {
                dateLabel.text = DateFormatter.sharedInstance.stringForDate(nextPassDate)
                nextPassLabel.hidden = false
            } else {
                dateLabel.text = "..."
                nextPassLabel.hidden = true
            }
        }
    }
    
    func stringFromCoordinates(lat: Double, long: Double) -> String {
        let northSouthString = (lat > 0.0) ? "N" : "S"
        let eastWestString = (long > 0.0) ? "E" : "W"
        
        return String(format: "%.2f°%@\n%.2f°%@", abs(lat), northSouthString, abs(long), eastWestString)
    }
}