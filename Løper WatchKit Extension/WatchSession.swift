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
    
    //This function sends a message to the PhoneSession with a dictionary containing a startRunToPhone value
    func makePhoneStartRun() {
        let actionDictFromWatch = ["Action": "startRunToPhone"]
        session.sendMessage(actionDictFromWatch, replyHandler: nil) { (error: NSError) in
            print(error)
        }
    }
    
    //This functions sends a message to the PhoneSession with a dictionary containing a stopRunToPhone value
    func makePhoneStopRun() {
        let actionDictFromWatch = ["Action": "stopRunToPhone"]
        session.sendMessage(actionDictFromWatch, replyHandler: nil) { (error: NSError) in
            print(error)
        }
    }
    
    
//MARK: Data Getters
    
    //This function receives a message from the phone and then posts a notifiction with the value of the Action key and an object with value of the Payload key
    func session(session: WCSession, didReceiveMessage actionDictFromPhone: [String : AnyObject]) {
        dispatch_async(dispatch_get_main_queue()) {
            NSNotificationCenter.defaultCenter().postNotificationName(actionDictFromPhone["Action"]! as! String, object: actionDictFromPhone["Payload"])
        }
    }

}