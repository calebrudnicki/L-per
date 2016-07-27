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
    
    var session: WCSession!
    
    func startSession() {
        if WCSession.isSupported() {
            session = WCSession.defaultSession()
            session.delegate = self
            session.activateSession()
        }
    }
    
//    func session(session: WCSession, didReceiveMessage gameStats: [String : AnyObject]) {
//        dispatch_async(dispatch_get_main_queue()) {
//            self.performSegueWithIdentifier("startRunSegue", sender: self)
//        }
//    }
    
    func sendMessageToWatch() {
        let gameStats = ["Scores": [1]]
        session.sendMessage(gameStats, replyHandler: nil) { (error: NSError) in
            print(error)
        }
    }
    
}