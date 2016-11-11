//
//  Sighting.swift
//  No-More-Clowns
//
//  Created by Dhruv Upadhyay on 11/8/16.
//  Copyright © 2016 Dhruv Upadhyay. All rights reserved.
//

import Foundation
import UIKit
import MapKit

class Sighting {
    
    private var _lat: CLLocationDegrees!
    private var _long: CLLocationDegrees!
    private var _imageURL: String!
    private var _likes: Int!
    private var _postedBy: String!
    private var _sightingKey: String!
    
    var lat: CLLocationDegrees {
        
        return _lat
    }
    
    var long: CLLocationDegrees {
        
        return _long
    }
    
    var imageURL: String {
        
        return _imageURL
    }
    
    var likes: Int {
        
        return _likes
    }
    
    var postedBy: String {
        
        return _postedBy
    }
    
    var sightingKey: String {
        
        return _sightingKey
    }
    
    init(lat: CLLocationDegrees, long: CLLocationDegrees, imageURL: String, likes: Int, postedBy: String) {
        
        self._lat = lat
        self._long = long
        self._imageURL = imageURL
        self._likes = likes
        self._postedBy = postedBy
        
    }
    
    init(sightingKey: String, sightingData: Dictionary<String, AnyObject>) {
        
        self._sightingKey = sightingKey
        
        if let lat = sightingData["lat"] as? CLLocationDegrees {
            
            self._lat = lat
        }
        
        if let long = sightingData["long"] as? CLLocationDegrees {
            
            self._long = long
        }
        
        if let imageURL = sightingData["imageURL"] as? String {
            
            self._imageURL = imageURL
        }
        
        if let likes = sightingData["likes"] as? Int {
            
            self._likes = likes
        }
        
        if let postedBy = sightingData["postedBy"] as? String {
            
            self._postedBy = postedBy
        }
        
    }
    
}
