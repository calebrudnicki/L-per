//
//  ListRunsTableViewController.swift
//  Løper
//
//  Created by Caleb Rudnicki on 7/13/16.
//  Copyright © 2016 Caleb Rudnicki. All rights reserved.
//

import UIKit
import MapKit

class ListRunsTableViewController: UITableViewController, CLLocationManagerDelegate {

//MARK: Variables

    var distance: Double!
    var time: Double!
    var pace: Double!
    var locations: [CLLocation]!
    var runs : [(Double,Double,Double,[CLLocation])] {
        get {
            return [
                (distance, time, pace, locations)
            ]
            
        }
    }
  
    
//MARK: Boilerplate Functions
    
    //This functions prints out the value for the variables distance, time, pace, and locations as long as they are not nil
    override func viewDidLoad() {
        super.viewDidLoad()
        if distance != nil {
            print("\(distance) miles")
        }
        if time != nil {
            print("\(time) minutes")
        }
        if pace != nil {
            print("\(pace) pace")
        }
        if locations != nil {
            print("\(locations) pins")
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
//MARK: Actions
    
    //This function that runs when the go back button is tapped unwinds the segue back to the home screen
    @IBAction func goBackButtonTapped(sender: AnyObject) {
        self.performSegueWithIdentifier("exitSegue", sender: self)
    }
    
    
//MARK: Table View Functions
    
    //This function sets the number of sections in each cell
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    //This function sets the number of cells in the table view
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return runs.count
    }

    //This function sets each cell to a object from each respective place in the array
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cellIdentifier", forIndexPath: indexPath)
        cell.textLabel?.text = String(runs[indexPath.row])
        return cell
    }
    
}