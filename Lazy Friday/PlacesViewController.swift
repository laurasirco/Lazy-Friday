//
//  PlacesViewController.swift
//  Lazy Friday
//
//  Created by bakerydev004 on 19/2/16.
//  Copyright © 2016 Laura Sirvent Collado. All rights reserved.
//

import UIKit
import STLocationRequest
import MapKit

class PlacesViewController: UIViewController,CLLocationManagerDelegate {
    
    var location : CLLocation = CLLocation()
    var locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if location.coordinate.latitude == 0 && location.coordinate.longitude == 0 {
            
            self.locationManager.delegate = self
            self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
            self.locationManager.distanceFilter=kCLDistanceFilterNone
            
            showLocationRequest()
            
            NSNotificationCenter.defaultCenter().addObserver(self, selector: "locationRequestNotNow", name: "locationRequestNotNow", object: nil)
            NSNotificationCenter.defaultCenter().addObserver(self, selector: "locationRequestAuthorized", name: "locationRequestAuthorized", object: nil)
            NSNotificationCenter.defaultCenter().addObserver(self, selector: "locationRequestDenied", name: "locationRequestDenied", object: nil)
        }
        
    }
    
    func showLocationRequest(){
        self.showLocationRequestController(setTitle: "We need your location for some awesome features", setAllowButtonTitle: "Alright", setNotNowButtonTitle: "Not now", setMapViewAlphaValue: 0.7, setBackgroundViewColor: UIColor.lightGrayColor())
    }
    
    func locationRequestNotNow(){
        print("The user cancled the locationRequestScreen")
    }
    
    func locationRequestAuthorized(){
        print("Location service is allowed by the user. You have now access to the user location")
        if #available(iOS 9.0, *) {
            self.locationManager.requestLocation()
        } else {
            self.locationManager.startUpdatingLocation()
        }
    }
    
    func locationRequestDenied(){
        print("Location service are denied by the user")
    }
    
    
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        print("The Location couldn't be found")
    }
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        self.locationManager.stopUpdatingLocation()
        let geoCoder = CLGeocoder()
        guard let userLocation = locations.last else{
            return
        }
        geoCoder.reverseGeocodeLocation(userLocation) { (placemarks, error) -> Void in
            guard let placemark = placemarks?.last else{
                return
            }
            self.location = placemark.location!
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}
