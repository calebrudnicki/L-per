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
    
    
//MARK: Boilerplate Functions
    
    override func awakeWithContext(context: AnyObject?) {
        super.awakeWithContext(context)
    }

    override func willActivate() {
        super.willActivate()
        WatchSession.sharedInstance.startSession()
        WatchSession.sharedInstance.makePhoneStartRun()
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(RunTrackerInterfaceController.recievedGiveRunDataNotifaction(_:)), name:"giveRunDataToWatch", object: nil)
    }

    override func didDeactivate() {
        super.didDeactivate()
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    
//MARK:
    
    func recievedGiveRunDataNotifaction(notification: NSNotification) {
        let runDataDict = notification.object as? [String : AnyObject]
        self.displayLabels(runDataDict!)
    }
    
    
    func displayLabels(dataDict: [String : AnyObject]) {
        distanceLabel.setText(String(dataDict["Distance"]!))
        runTimeLabel.setText(String(dataDict["RunTime"]!))
        paceLabel.setText(String(dataDict["Pace"]!))
    }

}