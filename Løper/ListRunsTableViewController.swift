//
//  ListRunsTableViewController.swift
//  Løper
//
//  Created by Caleb Rudnicki on 7/13/16.
//  Copyright © 2016 Caleb Rudnicki. All rights reserved.
//

import UIKit

class ListRunsTableViewController: UITableViewController {

//MARK: Variables

    var data = ["a", "b", "c"]
    
    
//MARK: viewDidLoad()
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
   
    
//MARK: Table View Functions
    
    //This function sets the number of sections in each cell
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    //This function sets the number of cells in the table view
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.data.count
    }

    //This function sets each cell to a object from each respective place in the array
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cellIdentifier", forIndexPath: indexPath)
        cell.textLabel?.text = data[indexPath.row]
        return cell
    }
    
}