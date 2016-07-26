//
//  PopoverViewController.swift
//  Løper
//
//  Created by Caleb Rudnicki on 7/25/16.
//  Copyright © 2016 Caleb Rudnicki. All rights reserved.
//

import UIKit

class PopupViewController: UIViewController {
    
//MARK: Outlets
    
    @IBOutlet weak var userChoiceLabel: UILabel!
    

//MARK: Variables
    
    var choice: String!
    
//MARK: Boilerplate Functions
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.blackColor().colorWithAlphaComponent(0.8)
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