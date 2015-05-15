//
//  PostViewController.swift
//  YikYak
//
//  Created by Shrikar Archak on 12/31/14.
//  Copyright (c) 2014 Shrikar Archak. All rights reserved.
//

import UIKit

class PostViewController: UIViewController, UITextViewDelegate, CLLocationManagerDelegate {


    @IBOutlet weak var postView: UITextView!
    var currLocation: CLLocationCoordinate2D?
    var reset:Bool = false
    let locationManager = CLLocationManager()

    private func  alert() {
        let alert = UIAlertController(title: "Cannot fetch your location", message: "Please enable location in the settings menu", preferredStyle: UIAlertControllerStyle.Alert)
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
        self.postView.selectedRange = NSMakeRange(0, 0);
        self.postView.delegate = self
        self.postView.becomeFirstResponder()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }

    func locationManager(manager: CLLocationManager!, didUpdateLocations locations: [AnyObject]!) {
        locationManager.stopUpdatingLocation()
        if(locations.count > 0){
            let location = locations[0] as! CLLocation
            currLocation = location.coordinate
        } else {
            alert()
        }
    }
    
    func locationManager(manager: CLLocationManager!, didFailWithError error: NSError!) {
        println(error)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func cancelPressed(sender: AnyObject) {
        self.dismissViewControllerAnimated(true , completion: nil)
    }
    
    @IBAction func postPressed(sender: AnyObject) {
        
        if(currLocation != nil){
            let testObject = PFObject(className: "Yak")
            testObject["text"] = self.postView.text
            testObject["count"] = 0
            testObject["replies"] = 0            
            testObject["location"] = PFGeoPoint(latitude: currLocation!.latitude , longitude: currLocation!.longitude)
            testObject["comments"] = []
            testObject.saveInBackground()
            self.dismissViewControllerAnimated(true , completion: nil)
        } else {
            alert()
        }


        
    }
    func textViewDidChange(textView: UITextView) {
        if(reset == false){
            self.postView.text = String(Array(self.postView.text)[0])
            reset = true
        }   
    }

}
