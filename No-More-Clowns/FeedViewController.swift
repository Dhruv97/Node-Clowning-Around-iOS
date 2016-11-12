//
//  FeedViewController.swift
//  No-More-Clowns
//
//  Created by Dhruv Upadhyay on 11/6/16.
//  Copyright © 2016 Dhruv Upadhyay. All rights reserved.
//

import UIKit
import Firebase

class FeedViewController: UIViewController , UITableViewDelegate, UITableViewDataSource {
    
   

    // refresh control for pull to refresh
    var refreshControl = UIRefreshControl()
    
    // Cache for storing images downloaded from Firebase
    static var imageCache: NSCache<NSString, UIImage> = NSCache()
    
    @IBOutlet weak var tableView: UITableView!
    
    // Sightings array
    var sightings = [Sighting]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // init tableView delegate and data source
        tableView.delegate = self
        tableView.dataSource = self
        
        // Configure Refresh Control
        refreshControl.attributedTitle = NSAttributedString(string: "Loading Sightings...", attributes: nil)
        refreshControl.addTarget(self, action: #selector(self.refreshData(sender:)), for: .valueChanged)
        
        // Add to Table View
        if #available(iOS 10.0, *) {
            tableView.refreshControl = refreshControl
        } else {
            tableView.addSubview(refreshControl)
        }
        
        // calls function to load reported Sightings
        loadSightings()
        
    }
    
    // load sightings on refresh
    func refreshData(sender: AnyObject) {
        loadSightings()
    }
    
    // load all sightings from Firebase
    func loadSightings() {
    
        // Firebase event listener for sightings
        DataService.ds.REF_SIGHTINGS.observe(.value, with: { (snapshot) in
            var tempSightingsArr = [Sighting]()
            tempSightingsArr = []
            if let snapshot = snapshot.children.allObjects as? [FIRDataSnapshot] {
                
                for snap in snapshot {
                    
                    if let sightingDict = snap.value as? Dictionary<String, AnyObject> {
                        
                        let key = snap.key
                        let sighting = Sighting(sightingKey: key, sightingData: sightingDict)
                        tempSightingsArr.append(sighting)
                        
                    }
                    
                }
            }
            
            // update sightings array
            self.sightings = tempSightingsArr
            self.tableView.reloadData()
            
            // end refreshing animation
            if self.refreshControl.isRefreshing {
                self.refreshControl.endRefreshing()
            }
            
        })
        
    }
    
    // hide status bar
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    // function that creates number of sections in tableview
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }
    
    // function that creates number of rows in table view
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       
            return sightings.count
        
    }
    
    // function for defining the cells in the rows
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // get the sighting in sightings array at the index of the cell in the table view
        let sighting = sightings[indexPath.row]
        
        // declare cell
        if let cell = tableView.dequeueReusableCell(withIdentifier: "SightingCell") as? SightingCell {
            
            
            // sets img equal to image from Cache
            if let img = FeedViewController.imageCache.object(forKey: sighting.imageURL as NSString) {
                
                 // configure cell using data from the sighting
                cell.configureCell(sighting: sighting, img: img)
                
                return cell
                
            } else {
                
                cell.configureCell(sighting: sighting)
                return cell;
            }
     
            
        } else {
            
            return SightingCell()
            
        }
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
