//
//  SignInViewController.swift
//  No-More-Clowns
//
//  Created by Dhruv Upadhyay on 11/6/16.
//  Copyright © 2016 Dhruv Upadhyay. All rights reserved.
//

import UIKit
import FBSDKCoreKit
import FBSDKLoginKit
import Firebase
import FirebaseAuth

class SignInViewController: UIViewController {

    @IBOutlet weak var fbBtn: UIButton!
    
    // Log in user using Facebook account
    @IBAction func fbBtnPressed(_ sender: AnyObject) {
        
        // create Facebook login manager object
        let facebookLogin = FBSDKLoginManager()
        
        // get permission to read user's email from Facebook account
        facebookLogin.logIn(withReadPermissions: ["email"], from: self) { (result, error) in
            
            if error != nil {
                
                print("Facebook Login Error: Unable to authenticate with Facebook: \(error)")
                
            } else if result?.isCancelled == true {
                
                print("Facebook Login Cancelled")
                
            } else {
                
                print("Facebook Login Success")
                
                // get credential
                let credential = FIRFacebookAuthProvider.credential(withAccessToken: FBSDKAccessToken.current().tokenString)
                self.fireBaseAuth(credential)
            }
            
        }
        
    }
    
    // Authenticate user using Facebook credential
    func fireBaseAuth(_ credential: FIRAuthCredential) {
        
        // Sign in user to application
        FIRAuth.auth()?.signIn(with: credential, completion: { (user, error) in
            
            if error != nil {
                
                print("Firebase Auth Error: Unable to authenticate with Firebase: \(error)")
                
            } else {
                
                print("Firebase Auth Success")
                
            }
            
        })
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        fbBtn.setImage(UIImage(named:"fb2.png"), for: .highlighted)
        
        self.navigationController?.isNavigationBarHidden = true
    }

    
    
}
