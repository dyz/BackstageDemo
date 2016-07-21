//
//  DateFormatter.swift
//  ISSTracker
//
//  Created by David Zheng on 7/20/16.
//  Copyright © 2016 David Zheng. All rights reserved.
//

import Foundation

class DateFormatter: NSObject {
    static let sharedInstance = DateFormatter()
    var dateFormatter : NSDateFormatter
    
    override init() {
        self.dateFormatter = NSDateFormatter()
        self.dateFormatter.dateFormat = "MMM dd, yyyy\nhh:mma"
        super.init()
    }
    
    func stringForDate(date: NSDate) -> String {
        return dateFormatter.stringFromDate(date)
    }
    
}