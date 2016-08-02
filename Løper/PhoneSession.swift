//
//  PhoneSession.swift
//  Løper
//
//  Created by Caleb Rudnicki on 7/27/16.
//  Copyright © 2016 Caleb Rudnicki. All rights reserved.
//

import UIKit
import WatchConnectivity

class PhoneSession: NSObject, WCSessionDelegate {
    
//MARK: Variables
    
    static let sharedInstance = PhoneSession()
    var session: WCSession!
    
    
//MARK: Session Creation
    
    //This function creates a session
    func startSession() {
        if WCSession.isSupported() {
            session = WCSession.defaultSession()
            session.delegate = self
            session.activateSession()
        }
    }
  
    
//MARK: Data Senders

    //This function sends a message to the WatchSession with a dictionary containing a giveRunDataToWatch and payloadDictFromPhone value
    func giveWatchRunData(distance: String, runTime: String, pace: String, stallTime: String) {
        let payloadDictFromPhone = ["Distance": distance, "RunTime": runTime, "Pace": pace, "StallTime": stallTime]
        let actionDictFromPhone = ["Action": "giveRunDataToWatch", "Payload": payloadDictFromPhone]
        session.sendMessage(actionDictFromPhone as! [String : AnyObject], replyHandler: nil) { (error: NSError) in
            print(error)
        }
    }
    
    //This function sends a message to the WatchSession with a dictionary containing a stopRunToWatch value
    func makeWatchStopRun() {
        let actionDictFromPhone = ["Action": "stopRunToWatch"]
        session.sendMessage(actionDictFromPhone, replyHandler: nil) { (error: NSError) in
            print(error)
        }
    }
    
    
//MARK: Data Getters
    
    //This function receives a message from the watch and then posts a notifiction with the value of the Action key
    func session(session: WCSession, didReceiveMessage actionDictFromWatch: [String : AnyObject]) {
        dispatch_async(dispatch_get_main_queue()) {
            NSNotificationCenter.defaultCenter().postNotificationName(actionDictFromWatch["Action"]! as! String, object: nil)
        }
    }
    
}