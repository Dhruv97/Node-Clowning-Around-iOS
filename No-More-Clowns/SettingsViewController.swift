//
//  SettingsViewController.swift
//  No-More-Clowns
//
//  Created by Dhruv Upadhyay on 11/7/16.
//  Copyright © 2016 Dhruv Upadhyay. All rights reserved.
//

import UIKit
import Firebase
import SwiftKeychainWrapper

class SettingsViewController: UIViewController {

    // Sign out user
    @IBAction func signOutPressed(_ sender: AnyObject) {
        
        let keyChainResult = KeychainWrapper.standard.removeObject(forKey: KEY_UID)
        print("KeyChain ID removed: \(keyChainResult)")
        try! FIRAuth.auth()?.signOut()
        print("User signed out")
        self.performSegue(withIdentifier: "goToSignIn", sender: self)
        
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
