//
//  DetailViewController.swift
//  No-More-Clowns
//
//  Created by Dhruv Upadhyay on 11/25/16.
//  Copyright © 2016 Dhruv Upadhyay. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    
    @IBOutlet weak var infoLabel: UILabel!

    var info = ""
    var img: UIImage?
    
    @IBOutlet weak var sightingImage: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        infoLabel.text = info
        sightingImage.image = img
    }

    @IBAction func close(_ sender: AnyObject) {
        
        self.dismiss(animated: true, completion: nil)
        
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
