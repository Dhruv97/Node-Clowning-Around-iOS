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

class DataService {
    
    static let ds = DataService()
    
    private var _REF_BASE = DB_BASE
    private var _REF_SIGHTINGS = DB_BASE.child("Sightings")
    private var _REF_USERS = DB_BASE.child("Users")
    
    var REF_BASE: FIRDatabaseReference {
        
        return _REF_BASE
        
    }
    
    var REF_SIGHTINGS: FIRDatabaseReference {
        
        return _REF_SIGHTINGS
    }
    
    var REF_USERS: FIRDatabaseReference {
        
        
        return _REF_USERS
    }
    
    func createFirebaseDBUser(uid: String, userData: Dictionary<String, String>) {
        
        REF_USERS.child(uid).updateChildValues(userData)
        
    }
    
}
