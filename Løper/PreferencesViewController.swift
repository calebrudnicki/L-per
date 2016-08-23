//
//  PreferencesViewController.swift
//  Løper
//
//  Created by Caleb Rudnicki on 8/23/16.
//  Copyright © 2016 Caleb Rudnicki. All rights reserved.
//

import UIKit

class PreferencesViewController: UIViewController {

//MARK: Outlets
    
    @IBOutlet weak var unitsController: UISegmentedControl!
    
 
//MARK: Variables
    
    var units: String!
    
//MARK: Boilerplate Functions
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    @IBAction func changeUnits(sender: AnyObject) {
        if unitsController.selectedSegmentIndex == 0 {
            units = "miles"
        } else {
            units = "meters"
        }
    }
}