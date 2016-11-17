//
//  SightingCell.swift
//  No-More-Clowns
//
//  Created by Dhruv Upadhyay on 11/7/16.
//  Copyright © 2016 Dhruv Upadhyay. All rights reserved.
//

import UIKit
import MapKit
import Firebase
import FirebaseStorage

class SightingCell: UITableViewCell {
    
    @IBOutlet weak var sightingImg: UIImageView!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var likesLabel: UILabel!
    
    @IBOutlet weak var postedByLabel: UILabel!
    
    var sighting: Sighting!

    var likesRef: FIRDatabaseReference!
    
    @IBOutlet weak var likeImg: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
       
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(likeTapped))
        tap.numberOfTapsRequired = 1
        likeImg.addGestureRecognizer(tap)
        likeImg.isUserInteractionEnabled = true
        
    }

    func configureCell(sighting: Sighting, img: UIImage? = nil) {
        
        
        self.sighting = sighting
        
        self.likesRef = DataService.ds._REF_USER_CURRENT.child("liked").child(sighting.sightingKey)

        
        let location = CLLocation(latitude: sighting.lat, longitude: sighting.long)
        
        CLGeocoder().reverseGeocodeLocation(location) { (placemark, error) in
            
            if error != nil {
                
                print("ERROR in Geocoding: \(error)")
            } else {
                
                if let place = placemark?[0] {
                    
                     if place.isoCountryCode == nil || place.country == nil {
                        
                        self.locationLabel.text = "Unknown Location"
                        
                    } else if place.administrativeArea == nil {
                        
                        self.locationLabel.text = "\(place.country!)"
                        
                    }else if place.locality == nil {
                        
                        self.locationLabel.text = "\(place.administrativeArea!), \(place.isoCountryCode!)"
                        
                    } else if place.thoroughfare == nil {
                        
                        self.locationLabel.text = "\(place.locality!), \(place.administrativeArea!), \(place.isoCountryCode!)"
                        
                    } else if place.subThoroughfare == nil {
                        
                        self.locationLabel.text = "\(place.thoroughfare!), \(place.locality!), \(place.administrativeArea!), \(place.isoCountryCode!)"
                        
                    } else {
                        
                         self.locationLabel.text = "\(place.subThoroughfare!), \(place.thoroughfare!), \(place.locality!), \(place.administrativeArea!), \(place.isoCountryCode!)"
                        
                    }
                    
                    
                    
                    
                }
                
                
            }
            
        }
        
        self.likesLabel.text = "Likes: \(sighting.likes)"
        self.postedByLabel.text = "Posted by \(sighting.postedBy)"
        
        if img != nil {
            
            self.sightingImg.image = img
        } else {
           
            let ref = FIRStorage.storage().reference(forURL: sighting.imageURL)
            ref.data(withMaxSize: 2 * 1024 * 1024, completion: { (data, error) in
                
                if error != nil {
                    
                    print("IMAGE ERROR: Unable to download image")
                } else {
                    
                    print("IMAGE SUCCESS: Image downloaded from Firebase Storage")
                    
                    if let imgData = data {
                        
                        if let img = UIImage(data: imgData) {
                            
                            // set the image to image from cache
                            self.sightingImg.image = img
                            FeedViewController.imageCache.setObject(img, forKey: sighting.imageURL as NSString)
                            
                        }
                        
                    }
                }
            })
        }
        
        
        likesRef.observeSingleEvent(of: .value, with: { (snapshot) in
        
            if let _ = snapshot.value as? NSNull {
                
                self.likeImg.image = UIImage(named: "empty-heart.png")
         
            } else {
                
                self.likeImg.image = UIImage(named: "filled-heart.png")
            }
        })
    }
    
    func likeTapped(sender: UITapGestureRecognizer) {
        
        likesRef.observeSingleEvent(of: .value, with: { (snapshot) in
            
            if let _ = snapshot.value as? NSNull {
                
                self.likeImg.image = UIImage(named: "filled-heart.png")
                self.sighting.adjustLikes(addLike: true)
                self.likesRef.setValue(true)
                
            } else {
                
                self.likeImg.image = UIImage(named: "empty-heart.png")
                self.sighting.adjustLikes(addLike: false)
                self.likesRef.removeValue()
            }
        })
    }
}
