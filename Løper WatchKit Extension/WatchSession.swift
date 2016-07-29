//
//  SessionHelper.swift
//  Løper
//
//  Created by Caleb Rudnicki on 7/26/16.
//  Copyright © 2016 Caleb Rudnicki. All rights reserved.
//

import WatchKit
import WatchConnectivity

class WatchSession: NSObject, WCSessionDelegate {
    
//MARK: Variables
    
    static let sharedInstance = WatchSession()
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
    
    //This functions sends a message to the PhoneSession with a dictionary containing a startRun value
    func makePhoneStartRun() {
        let actionDictFromWatch = ["Action": "startRunToPhone"]
        session.sendMessage(actionDictFromWatch, replyHandler: nil) { (error: NSError) in
            print(error)
        }
    }
    
    
//MARK: Data Getters
    
    //This function
    func session(session: WCSession, didReceiveMessage actionDictFromPhone: [String : AnyObject]) {
        dispatch_async(dispatch_get_main_queue()) {
            NSNotificationCenter.defaultCenter().postNotificationName(actionDictFromPhone["Action"]! as! String, object: actionDictFromPhone["Payload"])
        }
    }

}