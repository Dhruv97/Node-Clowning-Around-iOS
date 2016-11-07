//
//  MapViewController.swift
//  No-More-Clowns
//
//  Created by Dhruv Upadhyay on 10/31/16.
//  Copyright © 2016 Dhruv Upadhyay. All rights reserved.
//


import UIKit
import MapKit
import Firebase
import FirebaseDatabase

// include mapview delegate and location manager delegate
class MapViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {

    @IBOutlet weak var mapView: MKMapView!
    
    // location managager init
    let locationManager = CLLocationManager()
    
    // variable to see if map was centered on user location on app start
    var mapHasCenteredOnce = false
    
    var tracking = true
    
    // FireBase reference created
    var fireBaseRef: FIRDatabaseReference!
    
    @IBOutlet weak var centerBtn: UIButton!
    
    // report sighting on button pressed
    @IBAction func reportSighting(_ sender: AnyObject) {
        
        // calls create sighting and adds reported sighting to database
        createSightings()
        
    }
    
    // function to create a new Sightings object in Firebase database
    func createSightings() {
        
        // get location that user is currently on
        let location = CLLocation(latitude: mapView.centerCoordinate.latitude, longitude: mapView.centerCoordinate.longitude)
        let lat = location.coordinate.latitude
        let long = location.coordinate.longitude
        
        // define sighting object
        let sighting: [String: Double] = ["lat" : lat, "long": long]
        
        // add sighting to database
        fireBaseRef.child("Sightings").childByAutoId().setValue(sighting)
        
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
        
        // set fireBaseRef to the Firebase database reference
        fireBaseRef = FIRDatabase.database().reference()
        
        // gets all Sightings from Firebase database
        fireBaseRef.child("Sightings").queryOrderedByKey().observe(.childAdded, with: {
        
            (snapshot) in
            
            // dictionary of all values of a sighting object (lat and long)
            let value = snapshot.value as? NSDictionary
            
            
            let lat = value!["lat"] as! CLLocationDegrees
            let long = value!["long"] as! CLLocationDegrees
            
            // form location for each sighting with their lat and long values
            let loc = CLLocation(latitude: lat, longitude: long)
            let anno = ClownAnnotation(coordinate: loc.coordinate)
            
            // add annotation to map using coordinates of the reported sighting
            self.mapView.addAnnotation(anno)
            
        
        })
        
        
        
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
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate, 1000, 1000)
        
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
        
        let annoIdentifier = "Clown"
        var annotationView: MKAnnotationView?
        
        if annotation.isKind(of: MKUserLocation.self) {
            annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: "User")
            annotationView?.image = UIImage(named: "person")
        } else if let deqAnno = mapView.dequeueReusableAnnotationView(withIdentifier: annoIdentifier) {
            annotationView = deqAnno
            annotationView?.annotation = annotation
        } else {
            let av = MKAnnotationView(annotation: annotation, reuseIdentifier: annoIdentifier)
            av.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
            annotationView = av
        }
        
        if let annotationView = annotationView, let anno = annotation as? ClownAnnotation {
            
            annotationView.canShowCallout = true
            annotationView.image = UIImage(named: "icon.png")
            /*
            let btn = UIButton()
            btn.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
            btn.setImage(UIImage(named: "map"), for: .normal)
            annotationView.rightCalloutAccessoryView = btn*/
            
        }
        
        return annotationView
    }
    

    
   /* func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        
        if let anno = view.annotation as? ClownAnnotation {
            
            var place: MKPlacemark!
            
            if #available(iOS 10.0, *) {
                 place = MKPlacemark(coordinate: anno.coordinate)
            } else {
                place = MKPlacemark(coordinate: anno.coordinate, addressDictionary: nil)
            }
            let dest = MKMapItem(placemark: place)
            dest.name = "Clown Sighting"
            let regionDist: CLLocationDistance = 1000
            let regionSpan = MKCoordinateRegionMakeWithDistance(anno.coordinate, regionDist, regionDist)
            
            let options = [MKLaunchOptionsMapCenterKey: NSValue (mkCoordinate: regionSpan.center), MKLaunchOptionsMapSpanKey: NSValue(mkCoordinateSpan: regionSpan.span), MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving] as [String : Any]
            
            MKMapItem.openMaps(with: [dest], launchOptions: options)
        }
        
    }*/
    
    // center map view back to user location on center button press
    @IBAction func centerPressed(_ sender: AnyObject) {
        
        if let location = mapView.userLocation.location {
            
            centerMap(location: location)
            print(location)
        }
        
    }
    
    
}

