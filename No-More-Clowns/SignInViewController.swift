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
import SwiftKeychainWrapper

class SignInViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var fbBtn: UIButton!
    
    @IBOutlet weak var emailField: UITextField!
    
    
    @IBOutlet weak var passwordField: UITextField!
    
    
    @IBOutlet weak var emailWarning: UILabel!
    
    @IBOutlet weak var passwordWarning: UILabel!
    
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
                
                print("Firebase Auth with Facebook Error: Unable to authenticate with Firebase: \(error)")
                
            } else {
                
                print("Firebase Auth with Facebook Success")
                
                if let user = user {
                    
                     let userData = ["email": user.email, "username" : user.displayName, "provider": credential.provider]
                    self.completeSignIn(id: user.uid, userData: userData as! Dictionary<String, String>)
                }
                
                
            }
            
        })
        
    }
    
    // Sign in/up without Facebook
    
    @IBAction func signInBtnPressed(_ sender: AnyObject) {
        
       // Check that user has entered email and password (of 6+ chars)
        
        if((emailField.text?.characters.count)! < 1) {
            print("Please enter email")
            emailWarning.isHidden = false
      
        }
        
        if((passwordField.text?.characters.count)! < 1) {
            print("Please enter password")
            
            passwordWarning.isHidden = false
            passwordWarning.text = "Please enter your password!"

        
            
        }
        
        if((passwordField.text?.characters.count)! < 6 && (passwordField.text?.characters.count)! >= 1) {
            
            print("Password must be 6+ chars")
            passwordWarning.isHidden = false
            passwordWarning.text = "Must be 6+ chars!"
            
            
            if((emailField.text?.characters.count)! < 1) {
                print("Please enter email")
                emailWarning.isHidden = false
            } else {
                emailWarning.isHidden = true
                
            }
  
        }
        
        if((passwordField.text?.characters.count)! >= 6) {
             passwordWarning.isHidden = true
            
        }
        
        if((emailField.text?.characters.count)! >= 1) {
            emailWarning.isHidden = true

            
        }
        
        if((passwordField.text?.characters.count)! >= 6 && (emailField.text?.characters.count)! >= 1 ) {
            
            passwordWarning.isHidden = true
            emailWarning.isHidden = true
            
            // Sign user in using email and password
            
            if let email = emailField.text, let password = passwordField.text {
                
                // If user exists, sign user in
                FIRAuth.auth()?.signIn(withEmail: email, password: password, completion: { (user, error) in
                    
                    if error == nil {
                        
                        print("Firebase Auth with Email Success")
                        
                        if let user = user {
                            
                            let userData = ["email": user.email, "username" : "", "provider": user.providerID]
                            self.completeSignIn(id: user.uid, userData: userData as! Dictionary<String, String>)
                            
                        }
                        
                        
                    } else {
                        
                        
                        // If user does not exist, sign up user
                        
                        FIRAuth.auth()?.createUser(withEmail: email, password: password, completion: { (user, error) in
                            
                            if error != nil {
                                
                                print("Firebase Auth with Email Error: \(error)")
                                
                            } else {
                                
                                print("Firebase Auth with Email Success")
                                
                                if let user = user {
                       
                                    let userData = ["email": user.email, "username" : "Anon", "provider": user.providerID]
                                    self.completeSignIn(id: user.uid, userData: userData as! Dictionary<String, String>)
                                }
                                
                                
                            }
                            
                        })
                        
                    }
                    
                    
                })
                
            }
        }
        
        
    }
    
    func completeSignIn(id: String, userData: Dictionary<String, String>) {
        
        DataService.ds.createFirebaseDBUser(uid: id, userData: userData)
        
        let keyChainResult = KeychainWrapper.standard.set(id, forKey: KEY_UID)
        
        print("Data saved to keychain: \(keyChainResult)")
        
        performSegue(withIdentifier: "Map", sender: nil)


    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // set image for when button is pressed
        fbBtn.setImage(UIImage(named:"fb2.png"), for: .highlighted)
        
       // set textField delegates
        emailField.delegate = self
        passwordField.delegate = self
        
        // add gesture recognizer to call dismissKeyboard function
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard)))
        
        
       
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        if let _ = KeychainWrapper.standard.string(forKey: KEY_UID) {
            
            performSegue(withIdentifier: "Map", sender: nil)
            
        }
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    

    // dismiss keyboard on touch outside of keyboard
    func dismissKeyboard() {
        
        emailField.resignFirstResponder()
        passwordField.resignFirstResponder()
        
    }
    
    // dismiss keyboard on done/return pressed
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        textField.resignFirstResponder()
        return true
    }
    
    
}
