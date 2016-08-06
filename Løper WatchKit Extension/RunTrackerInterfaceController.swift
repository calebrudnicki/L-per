//
//  RunTrackerInterfaceController.swift
//  Løper
//
//  Created by Caleb Rudnicki on 7/29/16.
//  Copyright © 2016 Caleb Rudnicki. All rights reserved.
//

import WatchKit
import Foundation

class RunTrackerInterfaceController: WKInterfaceController {

//MARK: Outlets
    
    @IBOutlet var distanceLabel: WKInterfaceLabel!
    @IBOutlet var runTimeLabel: WKInterfaceLabel!
    @IBOutlet var paceLabel: WKInterfaceLabel!
    @IBOutlet var stallTimeLabel: WKInterfaceLabel!
    @IBOutlet var stopRunButton: WKInterfaceButton!
    
    
//MARK: Boilerplate Functions
    
    override func awakeWithContext(context: AnyObject?) {
        super.awakeWithContext(context)
    }

    //This function creates a shared instance of WatchSession, sends data to the phone through a shared instance of WatchSession, and establishes the class as an observer of the NSNotificationSender
    override func willActivate() {
        super.willActivate()
        WatchSession.sharedInstance.startSession()
        WatchSession.sharedInstance.makePhoneStartRun()
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(RunTrackerInterfaceController.receivedGiveRunDataNotification(_:)), name:"giveRunDataToWatch", object: nil)
    }

    //This function removes the observer from the NSNotication sender when the view disappears
    override func didDeactivate() {
        super.didDeactivate()
        WatchSession.sharedInstance.makePhoneStopRun()
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    //This functions sets the title of the interface
    override init () {
        super.init ()
        self.setTitle("Stop")
    }
    
    
//MARK: Info Collectors
    
    //This functions is called when a giveWatchRunData notification is posted and calls displayLabels()
    func receivedGiveRunDataNotification(notification: NSNotification) {
        let runDataDict = notification.object as? [String : AnyObject]
        self.displayLabels(runDataDict!)
    }
    
    //This functions sets the labels of the interface controller
    func displayLabels(dataDict: [String : AnyObject]) {
        distanceLabel.setText(String(dataDict["Distance"]!) + " mi")
        runTimeLabel.setText(String(dataDict["RunTime"]!))
        paceLabel.setText(String(dataDict["Pace"]!) + " min/mi")
        stallTimeLabel.setText(String(dataDict["StallTime"]!))
    }

}