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
    var duration: Double!
    var pace: Double!
    var locations: [CLLocation]!
    var runs = ["a", "b", "c", "d", "e", "f"]
    
    
//MARK: viewDidLoad()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if distance != nil {
            print("\(distance) miles")
        }
        if duration != nil {
            print("\(duration) seconds")
        }
        if duration != nil {
            print("\(pace) pace")
        }
        if duration != nil {
            print("\(locations) pins")
        }
        
    }

    
//MARK: didReceiveMemoryWarning

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    
//MARK: Style Settings
    
    //This function sets the status bar to white
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent
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
        cell.textLabel?.text = runs[indexPath.row]
        return cell
    }
    
}