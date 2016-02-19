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
import Alamofire

let FOURSQUARE_SEARCH_BASE_URL = "https://api.foursquare.com/v2/venues/search?v=20130815"
let FOURSQUARE_CLIENT_ID = "RAN4RVQSZXWCLW5SYITMMT0PHNAXL3TF2ILU0RPOIZKS4LAD"
let FOURSQUARE_CLIENT_PRIVATE = "BUHCAKLROXRBB5NBPC0KV3B4UNR5RIQPQ2UKNRE4LGFGFSB0"

class PlacesViewController: UIViewController,CLLocationManagerDelegate {
    
    var location : CLLocation = CLLocation()
    var locationManager = CLLocationManager()
    var places = NSMutableArray()
    
    @IBOutlet weak var placeTitleLabel: UILabel!
    @IBOutlet weak var placeLocationLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.locationManager.delegate = self
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        self.locationManager.distanceFilter=kCLDistanceFilterNone
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "locationRequestNotNow", name: "locationRequestNotNow", object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "locationRequestAuthorized", name: "locationRequestAuthorized", object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "locationRequestDenied", name: "locationRequestDenied", object: nil)
        
        getLocation()
    }
    
    func getLocation() {
        
        if CLLocationManager.locationServicesEnabled() {
            if CLLocationManager.authorizationStatus() == .Denied{
                // Location Services are Denied
            }else{
                if CLLocationManager.authorizationStatus() == .NotDetermined{
                    showLocationRequest()
                }else{
                    self.locationManager.requestLocation()
                }
            }
        }else{
            // Location Services are disabled
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
        self.locationManager.requestLocation()
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
            self.getARandomPlaceNearMyLocation()
            
        }
    }
    
    func getARandomPlaceNearMyLocation() {
        
        //let url = [FOURSQUARE_SEARCH_BASE_URL stringByAppendingString:[NSString stringWithFormat:@"&client_id=%@&client_secret=%@&ll=%f,%f&limit=50", FOURSQUARE_CLIENT_ID, FOURSQUARE_CLIENT_PRIVATE, location.latitude, location.longitude]];
        let url = NSString(format:"%@&client_id=%@&client_secret=%@&ll=%f,%f&limit=50", FOURSQUARE_SEARCH_BASE_URL, FOURSQUARE_CLIENT_ID, FOURSQUARE_CLIENT_PRIVATE, location.coordinate.latitude, location.coordinate.longitude) as String
        
        
        Alamofire.request(.GET, url, parameters: nil)
            .responseJSON { response in
                print(response.request)  // original URL request
                print(response.response) // URL response
                print(response.data)     // server data
                print(response.result)   // result of response serialization
                
                if let JSON = response.result.value {
                    self.parsePlaces(JSON as! NSDictionary)
                }
        }
    }
    
    func parsePlaces(jsonObject: NSDictionary) {
        let response = jsonObject["response"] as! NSDictionary
        let venues = response["venues"] as! NSArray
        fillUIWithRandomPlaceFromArray(venues)
    }
    
    func fillUIWithRandomPlaceFromArray(places : NSArray) {
        
        let lower : UInt32 = 0
        let upper : UInt32 = UInt32(places.count - 1)
        let randomNumber = arc4random_uniform(upper - lower) + lower
        
        let place = places[Int(randomNumber)] as! NSDictionary
        
        self.placeLocationLabel.text = (place["location"] as! NSDictionary)["address"] as! String
        self.placeTitleLabel.text = place["name"] as! String
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}
