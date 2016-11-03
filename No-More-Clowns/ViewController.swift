//
//  ViewController.swift
//  No-More-Clowns
//
//  Created by Dhruv Upadhyay on 10/31/16.
//  Copyright © 2016 Dhruv Upadhyay. All rights reserved.
//

import UIKit
import MapKit
class ViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {

    @IBOutlet weak var mapView: MKMapView!
    
    let locationManager = CLLocationManager()
    
    var mapHasCenteredOnce = false
    
    
    @IBAction func reportSighting(_ sender: AnyObject) {
    }
    
    
    
    
    override func viewDidLoad() {
       
        super.viewDidLoad()
       
        mapView.delegate = self
        mapView.userTrackingMode = MKUserTrackingMode.follow
        locationAuthStatus()

    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        
        locationAuthStatus()
    }
    
    func locationAuthStatus() {
        
        if CLLocationManager.authorizationStatus() == .authorizedWhenInUse {
            mapView.showsUserLocation = true
        } else {
            
            locationManager.requestWhenInUseAuthorization()
        }
    }

    
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        
        if status == .authorizedWhenInUse {
            
            mapView.showsUserLocation = true
            
        }
        
    }
    
    func centerMap(location: CLLocation) {
        
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate, 2000, 2000)
        
        mapView.setRegion(coordinateRegion, animated: true)
        
    }
    
    func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {
        
        if let location = userLocation.location {
            if mapHasCenteredOnce == false {
                centerMap(location: location)
                print(location)
                mapHasCenteredOnce = true
            }
        }
    }

    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        var annotationView: MKAnnotationView?
        if annotation.isKind(of: MKUserLocation.self) {
            
             annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: "User")
            annotationView?.image = UIImage(named: "person")
        }
        
        return annotationView
    }
    
    
    @IBAction func centerPressed(_ sender: AnyObject) {
        
        if let location = mapView.userLocation.location {
            
            centerMap(location: location)
            print(location)
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

