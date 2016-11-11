//
//  SettingsViewController.swift
//  No-More-Clowns
//
//  Created by Dhruv Upadhyay on 11/7/16.
//  Copyright © 2016 Dhruv Upadhyay. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import SwiftKeychainWrapper

class SettingsViewController: UIViewController {
    @IBOutlet weak var emailLabel: UILabel!

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var editTextField: UITextField!
    @IBOutlet weak var editView: UIVisualEffectView!
    @IBOutlet weak var signOutBtn: UIButton!
    // Sign out user
    @IBAction func signOutPressed(_ sender: AnyObject) {
        
        // remove keyChain
        let keyChainResult = KeychainWrapper.standard.removeObject(forKey: KEY_UID)
        print("KeyChain ID removed: \(keyChainResult)")
        
        // sign out on Firebase
        try! FIRAuth.auth()?.signOut()
        print("User signed out")

        // segue to sign in screen
        self.performSegue(withIdentifier: "goToSignIn", sender: self)
        
    }
    
    // hide status bar
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        emailLabel.text = FIRAuth.auth()?.currentUser?.email
       
         signOutBtn.setImage(UIImage(named:"signout2.png"), for: .highlighted)
            let user = FIRAuth.auth()?.currentUser
        DataService.ds.REF_USERS.child((user?.uid)!).observeSingleEvent(of: .value, with: { (snapshot) in
            
            let value = snapshot.value as? NSDictionary
            let username = value!["username"]
            
            self.nameLabel.text = username as! String?
        
        })
    }

   
    @IBAction func editName(_ sender: AnyObject) {
        
        editView.isHidden = false
        
        
    }
    
    @IBAction func editSubmit(_ sender: AnyObject) {
        
        if (editTextField.text?.characters.count)! > 0 {
            
            nameLabel.text = editTextField.text
        }
        
        editView.isHidden = true
        let username = nameLabel.text
        let userData = ["username":username]
       DataService.ds.createFirebaseDBUser(uid: (FIRAuth.auth()?.currentUser?.uid)!, userData: userData as! Dictionary<String, String>)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
