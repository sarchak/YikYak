//
//  TableViewController.swift
//  YikYak
//
//  Created by Shrikar Archak on 12/31/14.
//  Copyright (c) 2014 Shrikar Archak. All rights reserved.
//

import UIKit
import CoreLocation

class TableViewController: PFQueryTableViewController, CLLocationManagerDelegate {

    var yaks = ["Getting Started with building a Yik Yak Clone in Swift","Xcode 6 Tutorial using Autolayouts",
        "In this tutorial you will also learn how to talk to Parse Backend", "Learning Swift by building real world applications", "Test"]
    
    let locationManager = CLLocationManager()
    
    override init!(style: UITableViewStyle, className: String!) {
        super.init(style: style, className: className)
    }
    
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        self.parseClassName = "Yak"
        self.textKey = "text"
        self.pullToRefreshEnabled = true
//        self.paginationEnabled = true
        self.objectsPerPage = 200

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.estimatedRowHeight = 60
        self.tableView.rowHeight = UITableViewAutomaticDimension
        locationManager.desiredAccuracy = 1000
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    func locationManager(manager: CLLocationManager!, didFailWithError error: NSError!) {
        NSLog("\(error)")
    }
    
    override func queryForTable() -> PFQuery! {
        let query = PFQuery(className: "Yak")
        query.whereKey("location", nearGeoPoint: PFGeoPoint(latitude: 37.411822, longitude: -121.941125), withinMiles: 10)
        query.limit = 200;
        query.orderByDescending("createdAt")
        return query
    }
    
    func locationManager(manager: CLLocationManager!, didUpdateLocations locations: [AnyObject]!) {
        locationManager.stopUpdatingLocation()
        if(locations.count > 0){
            let location = locations[0] as CLLocation
            println(location.coordinate)
//            let query = PFQuery(className: "Yak")
//            query.whereKey("location", nearGeoPoint: PFGeoPoint(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude), withinMiles: 10)
//            query.limit = 10;
//            query.orderByDescending("createdAt")
//            query.findObjectsInBackgroundWithBlock({ (data, error) -> Void in
//                let results = data as [PFObject]
//
//                if(error == nil){
//                    var index = 0
//                    for obj: PFObject in results {
//                        NSLog(obj.valueForKey("text") as String)
//                        self.yaks[index++] = obj.valueForKey("text") as String
//                    }
//                    self.tableView.reloadInputViews()
//                } else {
//                    println(error)
//                }
//            })
        } else {
            NSLog("Couldn't find the location")
        }
    }
    

    override func objectAtIndexPath(indexPath: NSIndexPath!) -> PFObject! {
        var obj : PFObject? = nil
        if(indexPath.row < self.objects.count){
            obj = self.objects[indexPath.row] as PFObject
        }
        return obj
    }

//    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
//        return 1
//    }
//
//    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return 5
//    }

    
    override func tableView(tableView: UITableView!, cellForRowAtIndexPath indexPath: NSIndexPath!, object: PFObject!) -> PFTableViewCell! {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as TableViewCell
        cell.yakText.text = object.valueForKey("text") as String
        cell.yakText.numberOfLines = 0
        cell.count.text = "\((indexPath.row + 1) * 5)"
        cell.time.text = "\((indexPath.row + 1) * 3)m ago"
        cell.replies.text = "\((indexPath.row + 1) * 1) replies"
        return cell
    }

//    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as TableViewCell
//        cell.yakText.text = yaks[indexPath.row]
//        cell.yakText.numberOfLines = 0
//        cell.count.text = "\((indexPath.row + 1) * 5)"
//        cell.time.text = "\((indexPath.row + 1) * 3)m ago"
//        cell.replies.text = "\((indexPath.row + 1) * 1) replies"
//        return cell
//    }

    @IBAction func topButton(sender: AnyObject) {
        let hitPoint = sender.convertPoint(CGPointZero, toView: self.tableView)
        let hitIndex = self.tableView.indexPathForRowAtPoint(hitPoint)
        
        NSLog("Top Index Path \(hitIndex?.row)")
    }

    @IBAction func bottomButton(sender: AnyObject) {
        let hitPoint = sender.convertPoint(CGPointZero, toView: self.tableView)
        let hitIndex = self.tableView.indexPathForRowAtPoint(hitPoint)
        NSLog("Bottom Index Path \(hitIndex?.row)")
    }
   
}
