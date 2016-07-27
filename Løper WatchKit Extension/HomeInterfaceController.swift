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

//MARK: Outlets
    
    @IBOutlet var startRunButton: WKInterfaceButton!
    
    
//MARK: Variables
    
    //////////
    var session = WatchSession()
    //////////
    
    
//MARK: Boilerplate Functions
    
    override func awakeWithContext(context: AnyObject?) {
        super.awakeWithContext(context)
    }

    //This function activates a session
    override func willActivate() {
        super.willActivate()
        session.startSession()
    }

    override func didDeactivate() {
        super.didDeactivate()
    }
    
    override func contextForSegueWithIdentifier(segueIdentifier: String) -> AnyObject? {
        return 10
    }
    

//MARK: Actions

    //This functions calls sendMessageToPhone()
    ////////////
    @IBAction func startRunButtonTapped() {
        session.sendMessageToPhone()
        self.contextForSegueWithIdentifier("runTrackerSegue")
    }
    ////////////
    
}