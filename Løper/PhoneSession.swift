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

    func giveWatchRunData(distance: Double, runTime: String, pace: String) {
        let payloadDictFromPhone = ["Distance": String(distance), "RunTime": runTime, "Pace": pace]
        let actionDictFromPhone = ["Action": "giveRunDataToWatch", "Payload": payloadDictFromPhone]
        session.sendMessage(actionDictFromPhone as! [String : AnyObject], replyHandler: nil) { (error: NSError) in
            print(error)
        }
    }
    
    
//MARK: Data Getters
    
    //This function receives a message from the watch and then posts a notifaction with the value of the Action key
    func session(session: WCSession, didReceiveMessage actionDictFromWatch: [String : AnyObject]) {
        dispatch_async(dispatch_get_main_queue()) {
            NSNotificationCenter.defaultCenter().postNotificationName(actionDictFromWatch["Action"]! as! String, object: nil)
        }
    }
    
}