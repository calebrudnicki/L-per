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
    let formatter = NSDateFormatter()
    var isDeleted = false
    
    
//MARK: Boilerplate Functions
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //This functions calls loadFromCoreData()
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        self.loadFromCoreData()
    }
    
    
//MARK: Core Data Functions
    
    //This function loads the runs from Core Data and appends it to the array of Run objects called runs
    func loadFromCoreData() {
        let managedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
        let runFetch = NSFetchRequest(entityName: "Run")
        do {
            let sortDescriptor = NSSortDescriptor(key: "date", ascending: false)
            let sortDescriptors = [sortDescriptor]
            runFetch.sortDescriptors = sortDescriptors
            let fetchedRuns = try managedObjectContext.executeFetchRequest(runFetch) as! [Run]
            for run in fetchedRuns {
                self.runs.append(run)
            }
        } catch let error as NSError {
            fatalError("Failed to fetch run: \(error)")
        }
    }
    
    //This function deletes a specific run from Core Data
    func deleteFromCoreData(indexPath: NSIndexPath) {
        let managedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
        let previousRun = runs[indexPath.row]
        managedObjectContext.deleteObject(previousRun)
        do {
            try managedObjectContext.save()
        } catch let error as NSError {
            fatalError("Failed to delete run: \(error)")
        }
    }

    
//MARK: Segues
    
    //This function allows the run object selected in the table view to pass its data through to the RunDataViewController
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let identifier = segue.identifier {
            if identifier == "displayRunSegue" {
                let runDataViewController = segue.destinationViewController as! RunDataViewController
                let selectedRun = runs[(tableView.indexPathForSelectedRow?.row)!]
                runDataViewController.run = selectedRun
            }
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
        formatter.dateStyle = NSDateFormatterStyle.LongStyle
        let date = formatter.stringFromDate(runs[indexPath.row].date!)
        cell.dateLabel.text = String(date)
        isDeleted = false
        return cell
    }
    
    //This function allows the user to delete a run from the table view and also from Core Data
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            self.deleteFromCoreData(indexPath)
            runs.removeAtIndex(indexPath.row)
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
        }
    }
    
}