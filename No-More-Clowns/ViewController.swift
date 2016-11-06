//
//  ViewController.swift
//  No-More-Clowns
//
//  Created by Dhruv Upadhyay on 10/31/16.
//  Copyright © 2016 Dhruv Upadhyay. All rights reserved.
//


import UIKit
import MapKit

// include mapview delegate and location manager delegate
class ViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {

    @IBOutlet weak var mapView: MKMapView!
    
    // location managager init
    let locationManager = CLLocationManager()
    
    // variable to see if map was centered on user location on app start
    var mapHasCenteredOnce = false
    
    var tracking = false
    
    var geoFire: GeoFire!
    
    @IBOutlet weak var centerBtn: UIButton!
    
    @IBAction func reportSighting(_ sender: AnyObject) {
    }
    
    
    
    
    override func viewDidLoad() {
       
        super.viewDidLoad()
       
        // set map View delegate
        mapView.delegate = self
        
        // turn on user tracking mode to follow user
        
        if tracking == true {
        mapView.userTrackingMode = MKUserTrackingMode.follow
        
        } else {
             mapView.userTrackingMode = MKUserTrackingMode.none
        }
      
        
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        
          // call function to get authorization for user location when the view appears
        locationAuthStatus()
    }
    
    // function for getting authorization from user to use location
    func locationAuthStatus() {
        
        
        // if already authorized, show user's location
        if CLLocationManager.authorizationStatus() == .authorizedWhenInUse  && tracking == true{
            mapView.showsUserLocation = true
        } else {
            
            // request authorization from user to use location
            locationManager.requestWhenInUseAuthorization()
        }
    }

    
  /*  // show users location if user authorized
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        
        if status == .authorizedWhenInUse {
            
            mapView.showsUserLocation = true
            
        }
        
    }*/
 
    
    // function used to center map to user's positon
    func centerMap(location: CLLocation) {
        
        // set coodrinate to input location and zoom at 2000
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate, 2000, 2000)
        
        // set region of map view to specified location
        mapView.setRegion(coordinateRegion, animated: true)
        
    }
    
    // function centering map to user location on launch
    func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {
        
        if let location = userLocation.location {
            
            // checks if map has been centered on launch
            if mapHasCenteredOnce == false {
                
                // center it if it hasn't
                centerMap(location: location)
                print(location)
                mapHasCenteredOnce = true
            }
        }
    }

    // function for setting custom annotation
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        // declare var for custom annotation
        var annotationView: MKAnnotationView?
        if annotation.isKind(of: MKUserLocation.self) {
            
            // set custom annotation
             annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: "User")
            annotationView?.image = UIImage(named: "person")
        }
        
        return annotationView
    }
    
    // center map view back to user location on center button press
    @IBAction func centerPressed(_ sender: AnyObject) {
        
        if let location = mapView.userLocation.location {
            
            centerMap(location: location)
            print(location)
        }
        
    }
    /*
    @IBAction func tracking(_ sender: AnyObject) {
        
        if tracking == false {
            print("tracking")
            centerBtn.isEnabled = true

            tracking = true
            locationAuthStatus()
        } else {
            print("not tracking")
            tracking = false
            centerBtn.isEnabled = false
            locationManager.stopUpdatingLocation()
            mapView.userTrackingMode = MKUserTrackingMode.none
        }
    }*/    
    
}

