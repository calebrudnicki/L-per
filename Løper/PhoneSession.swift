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
    
    func startSession() {
        if WCSession.isSupported() {
            session = WCSession.defaultSession()
            session.delegate = self
            session.activateSession()
        }
    }
  
    
//MARK: Data Senders
    
    func sendMessageToWatch() {
        let gameStats = ["Scores": [1]]
        session.sendMessage(gameStats, replyHandler: nil) { (error: NSError) in
            print(error)
        }
    }
    
    
//MARK: Data Getters
    
    func session(session: WCSession, didReceiveMessage actionDictionary: [String : AnyObject]) {
        dispatch_async(dispatch_get_main_queue()) {
            NSNotificationCenter.defaultCenter().postNotificationName("startRunSegue", object: nil)
            //self.performSegueWithIdentifier("startRunSegue", sender: self)
        }
    }
    
}