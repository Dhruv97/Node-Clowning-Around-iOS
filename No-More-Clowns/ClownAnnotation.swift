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
    
    
    // custom annotation
    var coordinate = CLLocationCoordinate2D()
    var message: String
    var title:  String?
    var info: String
    
    init(coordinate: CLLocationCoordinate2D, message: String, info: String) {
        
        self.coordinate = coordinate
        self.message = message
        self.title = self.message
        self.info = info
    }
    
}
