//
//  RunTrackerInterfaceController.swift
//  Løper
//
//  Created by Caleb Rudnicki on 7/27/16.
//  Copyright © 2016 Caleb Rudnicki. All rights reserved.
//

import WatchKit
import Foundation
import WatchConnectivity

class RunTrackerInterfaceController: WKInterfaceController, WCSessionDelegate {

//MARK: Outlets
    
    @IBOutlet var distanceLabel: WKInterfaceLabel!

    
//MARK: Boilerplate Functions
    
    override func awakeWithContext(context: AnyObject?) {
        super.awakeWithContext(context)
        if let val: String = context as? String {
            self.distanceLabel.setText(val)
        } else {
            self.distanceLabel.setText("nothing")
        }
    }

    override func willActivate() {
        super.willActivate()
    }

    override func didDeactivate() {
        super.didDeactivate()
    }
    
    /////////////
//    func session(session: WCSession, didReceiveMessage gameStats: [String : AnyObject]) {
//        dispatch_async(dispatch_get_main_queue()) {
//            self.distanceLabel.setText("Hi")
//        }
//    }
    /////////////

}