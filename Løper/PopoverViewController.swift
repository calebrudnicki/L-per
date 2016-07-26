//
//  PopoverViewController.swift
//  Løper
//
//  Created by Caleb Rudnicki on 7/25/16.
//  Copyright © 2016 Caleb Rudnicki. All rights reserved.
//

import UIKit

class PopoverViewController: UIViewController {

//MARK: Outlets
    
    @IBOutlet weak var runStatusString: UILabel!
    
    
//MARK: Variables
    
    var runStatus: String!
    
    
//MARK: Boilerplate Functions
    
    //This functions sets the label to the string of the label1 variable
    override func viewDidLoad() {
        super.viewDidLoad()
        runStatusString.text = runStatus
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
//MARK: Actions
    
    //This fucntions performs a segue when the OK button is tapped
    @IBAction func okButtonTapped(sender: AnyObject) {
        self.performSegueWithIdentifier("exitSegue", sender: self)
    }
    
    
//MARK: Segues
    
    //This functions allows the user to unwind the segue back to the HomeViewController
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let identifier = segue.identifier {
            if identifier == "exitSegue" {
                let homeViewController = segue.destinationViewController as! HomeViewController
            }
        }
    }
    
}