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
    
    var dataSource = [LocationCellData]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "All Locations"
        
        self.tableView.dataSource = self
        self.tableView.tableFooterView = UIView()
        
        refreshDataSource()
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(LocationsViewController.locationsChanged(_:)), name: "kSavedLocationsUpdated", object: nil)
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("locationsCell") as! LocationsTableViewCell
        cell.updateWithData(dataSource[indexPath.row])
        return cell
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func refreshDataSource() {
        let savedLocations = SavedLocationStore.sharedInstance.getSavedLocationsFromDisk()
        
        var newDataSource = [LocationCellData]()
        
        for loc in savedLocations {
            let cellData = LocationCellData(name: loc.name, latitude: loc.latitude, longitude: loc.longitude, nextPass: nil)
            newDataSource.append(cellData)
            
            let apiClient = APIClient.sharedClient
            apiClient.getNextPassForLocationCoordinates(loc.latitude, long: loc.longitude, completion: { (error, data) in
                if (error == nil && data != nil) {
                    if let passes = data!["response"] as? [Dictionary<String, Int>] {
                        if let timestamp = passes.first?["risetime"] {
                            cellData.nextPass = NSDate(timeIntervalSince1970: Double(timestamp))
                            dispatch_async(dispatch_get_main_queue(), {
                                self.tableView.reloadData()
                            })
                        }
                    }                }
            })
            
        }
        
        self.dataSource = newDataSource
        self.tableView.reloadData()
    }
    
    func locationsChanged(sender: NSNotification) {
        refreshDataSource()
    }


}

