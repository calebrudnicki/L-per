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

    var runArray: [Run] = Run.runArray

    
//MARK: Boilerplate Functions
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    

//MARK: Table View Functions
    
    //This function sets the number of sections in each cell
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    //This function sets the number of cells in the table view
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.runArray.count
    }

    //This function sets each cell to a object from each respective place in the array
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cellIdentifier", forIndexPath: indexPath) as! RunDataCell
        cell.distanceLabel.text = String(self.runArray[indexPath.row].getDistance()) + "mi"
        cell.timeLabel.text = String(self.runArray[indexPath.row].getTime())
        cell.paceLabel.text = String(self.runArray[indexPath.row].getPace()) + "min / mi"
        return cell
    }
    
}