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


// include mapview delegate and location manager delegate
class MapViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var mapView: MKMapView!
    
    @IBOutlet weak var dangerSign: UIImageView!
    
    var image: UIImage? = nil
    
    var sightings = [Sighting]()
    
    // location managager init
    let locationManager = CLLocationManager()
    
    // variable to see if map was centered on user location on app start
    var mapHasCenteredOnce = false
    
    var tracking = true
    
    // FireBase reference created
    var fireBaseRef = DataService.ds.REF_SIGHTINGS
    
    @IBOutlet weak var centerBtn: UIButton!
    
    var imagePicker: UIImagePickerController!
    
    // report sighting on button pressed
    @IBAction func reportSighting(_ sender: AnyObject) {
        
        present(imagePicker, animated: true) {
        
            // calls create sighting and adds reported sighting to database
            self.createSightings()
        
        }        
    }
    
    // function to create a new Sightings object in Firebase database
    func createSightings() {
        
        // get location that user is currently on
        let location = CLLocation(latitude: mapView.centerCoordinate.latitude, longitude: mapView.centerCoordinate.longitude)
        let lat = location.coordinate.latitude
        let long = location.coordinate.longitude
        
        // define sighting object
         let sighting: [String: AnyObject] = ["lat" : lat as AnyObject, "long": long as AnyObject, "imageURL": "" as AnyObject, "likes": 0 as AnyObject]
        // add sighting to database
        DataService.ds.REF_SIGHTINGS.childByAutoId().setValue(sighting)
    }
    
    // hide status bar
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
 
    override func viewDidLoad() {
       
        super.viewDidLoad()
    
        // set map View delegate
        mapView.delegate = self
        
        // turn on user tracking mode to follow user
        mapView.userTrackingMode = MKUserTrackingMode.follow
        
        // init imagePicker
        imagePicker = UIImagePickerController()
    
        // lets user edit image frame
        imagePicker.allowsEditing = true
        
        // set imagePicker delegate
        imagePicker.delegate = self
        
        // gets all Sightings from Firebase database
        DataService.ds.REF_SIGHTINGS.observe(.value, with: { (snapshot) in
            
            let allAnnotations = self.mapView.annotations
            self.mapView.removeAnnotations(allAnnotations)
    
           
            
            if let snapshot = snapshot.children.allObjects as? [FIRDataSnapshot] {
                
                for snap in snapshot {
                    
                    if let sightingDict = snap.value as? Dictionary<String, AnyObject> {
                        
                        let lat = sightingDict["lat"]
                        let long = sightingDict["long"]
                        let clownLocation = CLLocation(latitude: lat as! CLLocationDegrees, longitude: long as! CLLocationDegrees)
                        
                         let userLoc = CLLocation(latitude: self.mapView.userLocation.coordinate.latitude, longitude: self.mapView.userLocation.coordinate.longitude)
                        let anno = ClownAnnotation(coordinate: clownLocation.coordinate)
                        
                        // add clown annotation to map for each sighting in Firebase
                        self.mapView.addAnnotation(anno)
                        
                        // show Danger sign if clown is within a mile
                        self.danger(userLoc: userLoc, clownLocation: clownLocation)
                        
                    }
                }
            }
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

    // show Danger sign if clown is within a mile
    func danger(userLoc: CLLocation, clownLocation: CLLocation) {
        
        self.dangerSign.isHidden = true
        if userLoc.distance(from: clownLocation) < 1609 {
            
            self.dangerSign.isHidden = false
            print("DANGER: A Clown was spotted nearby!")
        }
    }
    
    // show Danger sign if clown is within a mile on start of app
    func mapViewDidFinishRenderingMap(_ mapView: MKMapView, fullyRendered: Bool) {
        DataService.ds.REF_SIGHTINGS.observe(.value, with: { (snapshot) in
            
            if let snapshot = snapshot.children.allObjects as? [FIRDataSnapshot] {
                
                for snap in snapshot {
                    
                    if let sightingDict = snap.value as? Dictionary<String, AnyObject> {
                        
                        
                        let lat = sightingDict["lat"]
                        let long = sightingDict["long"]
                        
                        let clownLocation = CLLocation(latitude: lat as! CLLocationDegrees, longitude: long as! CLLocationDegrees)
                        
                        let userLoc = CLLocation(latitude: self.mapView.userLocation.coordinate.latitude, longitude: self.mapView.userLocation.coordinate.longitude)
                        
                        self.danger(userLoc: userLoc, clownLocation: clownLocation)
                    }
                    
                }
            }
            
        })
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
        
        if let annotationView = annotationView,  let _ = annotation as? ClownAnnotation {
            
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
    
    // function called once user has selected an image
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        if let selectedImg = info[UIImagePickerControllerEditedImage] as? UIImage {
            
            image = selectedImg
            
        } else {
            
            print("ERROR: A valid image was not selected")
        }
        imagePicker.dismiss(animated: true, completion: nil)
        
    }
}

