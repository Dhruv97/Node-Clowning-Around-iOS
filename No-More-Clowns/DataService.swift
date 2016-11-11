//
//  DataService.swift
//  No-More-Clowns
//
//  Created by Dhruv Upadhyay on 11/7/16.
//  Copyright © 2016 Dhruv Upadhyay. All rights reserved.
//

import Foundation
import Firebase

let DB_BASE = FIRDatabase.database().reference()
let STORAGE_BASE = FIRStorage.storage().reference()

class DataService {
    
    static let ds = DataService()
    
    private var _REF_BASE = DB_BASE
    private var _REF_SIGHTINGS = DB_BASE.child("Sightings")
    private var _REF_USERS = DB_BASE.child("Users")
    
    // Storage references
    private var _REF_SIGHTINGS_IMAGES = STORAGE_BASE.child("sightings-pics")
    
    var REF_BASE: FIRDatabaseReference {
        
        return _REF_BASE
        
    }
    
    var REF_SIGHTINGS: FIRDatabaseReference {
        
        return _REF_SIGHTINGS
    }
    
    var REF_USERS: FIRDatabaseReference {
        
        
        return _REF_USERS
    }
    
    var REF_SIGHTINGS_IMAGES: FIRStorageReference {
        
        return _REF_SIGHTINGS_IMAGES
    }
    
    func createFirebaseDBUser(uid: String, userData: Dictionary<String, String>) {
        
        REF_USERS.child(uid).updateChildValues(userData)
        
    }
    
}
