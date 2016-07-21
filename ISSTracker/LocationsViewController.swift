//
//  ViewController.swift
//  ISSTracker
//
//  Created by David Zheng on 7/20/16.
//  Copyright © 2016 David Zheng. All rights reserved.
//

import UIKit

class LocationsViewController: UIViewController, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var currentlyAtLabel: UILabel!
    @IBOutlet weak var backgroundView: UIView!
    
    var dataSource = [LocationCellData]()
    let apiClient = APIClient.sharedClient
    
    var currentlyOverheadNames = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "All Locations"
        
        self.tableView.dataSource = self
        self.tableView.tableFooterView = UIView()
        
        refreshDataSource()
        refreshCurrentLocation()
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(LocationsViewController.locationsChanged(_:)), name: "kSavedLocationsUpdated", object: nil)
    }
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("locationsCell") as! LocationsTableViewCell
        cell.updateWithData(dataSource[indexPath.row])
        return cell
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.backgroundView.hidden = (dataSource.count > 0)
        return dataSource.count
    }
    
    func refreshDataSource() {
        let savedLocations = SavedLocationStore.sharedInstance.getSavedLocationsFromDisk()
        
        var newDataSource = [LocationCellData]()
        
        let locationsGroup = dispatch_group_create()
        for loc in savedLocations {
            let cellData = LocationCellData(name: loc.name, latitude: loc.latitude, longitude: loc.longitude, nextPass: nil)
            newDataSource.append(cellData)
            
            dispatch_group_enter(locationsGroup)
            apiClient.getNextPassForLocationCoordinates(loc.latitude, long: loc.longitude, completion: { [weak self] (error, data) in
                if (error == nil && data != nil) {
                    if let passes = data!["response"] as? [Dictionary<String, Int>] {
                        if passes.count == 0 {
                            //based on observation, it seems like this indicates the ISS is currently overhead
                            cellData.currentlyOverhead = true
                            cellData.nextPass = nil
                            self?.currentlyOverheadNames.append(cellData.name)
                        }
                        if let timestamp = passes.first?["risetime"] {
                            cellData.nextPass = NSDate(timeIntervalSince1970: Double(timestamp))
                        }
                        dispatch_async(dispatch_get_main_queue(), {
                            self?.tableView.reloadData()
                        })
                    }
                }
                dispatch_group_leave(locationsGroup)
            })
        }
        self.dataSource = newDataSource
        self.tableView.reloadData()
        
        dispatch_group_notify(locationsGroup, dispatch_get_main_queue()) { 
            self.showOverheadAlertIfNecessary()
        }
    }
    
    func refreshCurrentLocation() {
        apiClient.getCurrentLocation { [weak self] (error, data) in
            if (error == nil && data != nil) {
                if let location = data!["iss_position"] as? Dictionary<String, Double> {
                    if let lat = location["latitude"], long = location["longitude"] {
                        dispatch_async(dispatch_get_main_queue(), {
                            self?.updateCurrentLocationLabelWithCoordinates(lat, long: long)
                        })
                    }
                    
                }
            }
        }
    }
    
    func locationsChanged(sender: NSNotification) {
        refreshDataSource()
    }
    
    func updateCurrentLocationLabelWithCoordinates(lat: Double, long: Double) {
        let northSouthString = (lat > 0.0) ? "N" : "S"
        let eastWestString = (long > 0.0) ? "E" : "W"
        
        currentlyAtLabel.text = String(format: "Current Position: %.2f°%@, %.2f°%@", abs(lat), northSouthString, abs(long), eastWestString)
    }
    
    func showOverheadAlertIfNecessary() {
        if (self.currentlyOverheadNames.count > 0) {
            var overheadStationsString = "\(self.currentlyOverheadNames.first!)"
            if self.currentlyOverheadNames.count > 1 {
                if self.currentlyOverheadNames.count == 2 {
                    overheadStationsString.appendContentsOf("and \(self.currentlyOverheadNames.last!).")
                } else {
                    overheadStationsString.appendContentsOf("and \(self.currentlyOverheadNames.count - 1) other locations.")
                }
            }
            let alert = UIAlertController(title: "ISS Overhead!", message: "The ISS is now overhead at \(overheadStationsString)", preferredStyle: .Alert)
            alert.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
            
            self.presentViewController(alert, animated: true, completion: nil)
            self.currentlyOverheadNames.removeAll()
        }
    }


}

