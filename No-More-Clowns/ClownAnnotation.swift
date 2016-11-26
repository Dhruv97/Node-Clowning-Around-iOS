//
//  ClownAnnotation.swift
//  No-More-Clowns
//
//  Created by Dhruv Upadhyay on 11/6/16.
//  Copyright © 2016 Dhruv Upadhyay. All rights reserved.
//

import Foundation
import MapKit
import FirebaseStorage

class ClownAnnotation: NSObject, MKAnnotation {
    
    
    // custom annotation
    var coordinate = CLLocationCoordinate2D()
    var message: String
    var title:  String?
    var info: String
    var img: UIImage?
    
    
    init(coordinate: CLLocationCoordinate2D, message: String, info: String, img: UIImage?) {
        
        self.coordinate = coordinate
        self.message = message
        self.title = self.message
        self.info = info
        self.img = img
        
    
    }
    
}
