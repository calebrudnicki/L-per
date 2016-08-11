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

    //This functions either transfers or sends a message to WatchSession with the key giveRunDataToWatch depending on whether the watch face is on or off
    func giveWatchRunData(distance: String, runTime: String, pace: String, stallTime: String) {
        let payloadDictFromPhone = ["Distance": distance, "RunTime": runTime, "Pace": pace, "StallTime": stallTime]
        let actionDictFromPhone = ["Action": "giveRunDataToWatch", "Payload": payloadDictFromPhone]
        if session.activationState == .Activated {
            session.sendMessage(actionDictFromPhone as! [String : AnyObject], replyHandler: nil) { (error: NSError) in
                print(error)
            }
        } else {
            session.transferUserInfo(actionDictFromPhone as! [String : AnyObject])
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