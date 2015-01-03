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

    override func viewDidLoad() {
        super.viewDidLoad()
        //self.automaticallyAdjustsScrollViewInsets = false
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
            let location = locations[0] as CLLocation
            currLocation = location.coordinate
        } else {
            NSLog("Couldn't find the location")
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
            testObject["location"] = PFGeoPoint(latitude: currLocation!.latitude , longitude: currLocation!.longitude)
            testObject.saveInBackground()
            self.dismissViewControllerAnimated(true , completion: nil)
        } else {
            NSLog("Location not found")
        }


        
    }
    func textViewDidChange(textView: UITextView) {
        if(reset == false){
            self.postView.text = String(Array(self.postView.text)[0])
            reset = true
        }   
    }

}
