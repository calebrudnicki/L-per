//
//  ListRunsTableViewController.swift
//  Løper
//
//  Created by Caleb Rudnicki on 7/13/16.
//  Copyright © 2016 Caleb Rudnicki. All rights reserved.
//

import UIKit
import CoreData
import MapKit

class ListRunsTableViewController: UITableViewController, CLLocationManagerDelegate {
    
//MARK: Variables
        var runs: [Run] = []
    
    
//MARK: Boilerplate Functions
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //This functions loads the info from Core Data after the view appears
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        loadInfo()
    }
    
    
//MARK: Core Data Functions
    
    //This function loads the info from Core Data and appends it to the array of Run objects called runs
    func loadInfo() {
        let managedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
        let runFetch = NSFetchRequest(entityName: "Run")
        do {
            let fetchedRuns = try managedObjectContext.executeFetchRequest(runFetch) as! [Run]
            for run in fetchedRuns {
                self.runs.append(run)
            }
        } catch {
            fatalError("Failed to fetch person: \(error)")
        }
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

    //This function sets the labels of the RunDataCell to the correct data from the run array
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cellIdentifier", forIndexPath: indexPath) as! RunDataCell
        cell.distanceLabel.text = String(runs[indexPath.row].distance!) + " mi"
        cell.timeLabel.text = String(runs[indexPath.row].time!)
        cell.paceLabel.text = String(runs[indexPath.row].pace!) + " min / mi"
        return cell
    }
    
}