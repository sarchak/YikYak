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
    var currLocation : CLLocationCoordinate2D?
    
    override init!(style: UITableViewStyle, className: String!) {
        super.init(style: style, className: className)
    }
    
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        self.parseClassName = "Yak"
        self.textKey = "text"
        self.pullToRefreshEnabled = true
        self.objectsPerPage = 200

    }
    
    private func alert(message : String) {
        let alert = UIAlertController(title: "Oops something went wrong.", message: message, preferredStyle: UIAlertControllerStyle.Alert)
        let action = UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil)
        let cancel = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel, handler: nil)
        let settings = UIAlertAction(title: "Settings", style: UIAlertActionStyle.Default) { (action) -> Void in
            UIApplication.sharedApplication().openURL(NSURL(string: UIApplicationOpenSettingsURLString)!)
            return
        }
        alert.addAction(settings)
        alert.addAction(action)
        self.presentViewController(alert, animated: true, completion: nil)
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
        alert("Cannot fetch your location")
    }
    
    override func queryForTable() -> PFQuery! {
        let query = PFQuery(className: "Yak")
        if let queryLoc = currLocation {
            query.whereKey("location", nearGeoPoint: PFGeoPoint(latitude: queryLoc.latitude, longitude: queryLoc.longitude), withinMiles: 10)
            query.limit = 200;
            query.orderByDescending("createdAt")
        } else {
            /* Decide on how the application should react if there is no location available */
            query.whereKey("location", nearGeoPoint: PFGeoPoint(latitude: 37.411822, longitude: -121.941125), withinMiles: 10)
            query.limit = 200;
            query.orderByDescending("createdAt")
        }

        return query
    }
    
    func locationManager(manager: CLLocationManager!, didUpdateLocations locations: [AnyObject]!) {
        locationManager.stopUpdatingLocation()
        if(locations.count > 0){
            let location = locations[0] as! CLLocation
            println(location.coordinate)
            currLocation = location.coordinate
        } else {
            alert("Cannot fetch your location")
        }
    }
    

    override func objectAtIndexPath(indexPath: NSIndexPath!) -> PFObject! {
        var obj : PFObject? = nil
        if(indexPath.row < self.objects.count){
            obj = self.objects[indexPath.row] as! PFObject
        }

        return obj
    }

    
    override func tableView(tableView: UITableView!, cellForRowAtIndexPath indexPath: NSIndexPath!, object: PFObject!) -> PFTableViewCell! {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as! TableViewCell
        cell.yakText.text = object.valueForKey("text") as! String
        cell.yakText.numberOfLines = 0
        let score = object.valueForKey("count") as! Int
        cell.count.text = "\(score)"
        cell.time.text = "\((indexPath.row + 1) * 3)m ago"
        let replycnt = object.objectForKey("replies") as! Int
        cell.replies.text = "\(replycnt) replies"
        return cell
    }

    @IBAction func topButton(sender: AnyObject) {
        let hitPoint = sender.convertPoint(CGPointZero, toView: self.tableView)
        let hitIndex = self.tableView.indexPathForRowAtPoint(hitPoint)
        let object = objectAtIndexPath(hitIndex)
        object.incrementKey("count")
        object.saveInBackground()
        self.tableView.reloadData()
        NSLog("Top Index Path \(hitIndex?.row)")
    }

    @IBAction func bottomButton(sender: AnyObject) {
        let hitPoint = sender.convertPoint(CGPointZero, toView: self.tableView)
        let hitIndex = self.tableView.indexPathForRowAtPoint(hitPoint)
        let object = objectAtIndexPath(hitIndex)
        object.incrementKey("count", byAmount: -1)
        object.saveInBackground()
        self.tableView.reloadData()
        NSLog("Bottom Index Path \(hitIndex?.row)")
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if(segue.identifier == "yakDetail"){
            let indexPath = self.tableView.indexPathForSelectedRow()
            let obj = self.objects[indexPath!.row] as! PFObject
            let navVC = segue.destinationViewController as! UINavigationController
            let detailVC = navVC.topViewController as! DetailViewController
            detailVC.yak = obj
        }
    }
   
}
