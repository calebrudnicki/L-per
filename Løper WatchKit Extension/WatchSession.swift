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
    
    func startSession() {
        if WCSession.isSupported() {
            session = WCSession.defaultSession()
            session.delegate = self
            session.activateSession()
        }
    }
    
    
//MARK: Data Senders
    
    func makePhoneStartRun() {
        let actionDictionary = ["Action": "startRun"]
        session.sendMessage(actionDictionary, replyHandler: nil) { (error: NSError) in
            print(error)
        }
    }
    
    func makePhoneStopRun() {
        let actionDictionary = ["Action": "stopRun"]
        session.sendMessage(actionDictionary, replyHandler: nil) { (error: NSError) in
            print(error)
        }
    }
    
    
//MARK: Data Getters
    
    func session(session: WCSession, didReceiveMessage actionDictionary: [String : AnyObject]) {
        dispatch_async(dispatch_get_main_queue()) {
            NSNotificationCenter.defaultCenter().postNotificationName("startRunSegue", object: nil)
        }
    }

}