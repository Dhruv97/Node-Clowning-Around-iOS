//
//  ClownAnnotation.swift
//  No-More-Clowns
//
//  Created by Dhruv Upadhyay on 11/6/16.
//  Copyright © 2016 Dhruv Upadhyay. All rights reserved.
//

import Foundation
import MapKit
class ClownAnnotation: NSObject, MKAnnotation {
    
    
    
    var coordinate = CLLocationCoordinate2D()
      var message: String
    var title:  String?
    init(coordinate: CLLocationCoordinate2D) {
        
        self.coordinate = coordinate
        self.message = "Clown Sighted!"
        self.title = self.message
    }
    
}
