//
//  HomeInterfaceController.swift
//  Løper WatchKit Extension
//
//  Created by Caleb Rudnicki on 7/25/16.
//  Copyright © 2016 Caleb Rudnicki. All rights reserved.
//

import WatchKit
import Foundation

class HomeInterfaceController: WKInterfaceController {
    
//MARK: Boilerplate Functions
    
    override func awakeWithContext(context: AnyObject?) {
        super.awakeWithContext(context)
    }

    //This function activates a session
    override func willActivate() {
        super.willActivate()
    }

    override func didDeactivate() {
        super.didDeactivate()
    }
    
    
//MARK: Actions
    
    @IBAction func startRunButtonTapped() {
        print("run button tapped")
    }
    
    
    
//MARK: Segues
    
//    override func contextForSegueWithIdentifier(segueIdentifier: String) -> AnyObject? {
//        if let identifier = segue.identifier {
//            if identifier == "startRunSegue" {
//                let runTrackerInterfaceController = segue.destinationViewController as! RunTrackerInterfaceController
//            }
//        }
//    }
    
    //This function can be connected to by another view controller to unwind a segue
//    @IBAction func unwindToHomeInterfaceController(segue: UIStoryboardSegue) {
//    }

}