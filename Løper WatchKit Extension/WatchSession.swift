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
    
    var session: WCSession!
    
    func startSession() {
        if WCSession.isSupported() {
            session = WCSession.defaultSession()
            session.delegate = self
            session.activateSession()
        }
    }
    
    func sendMessageToPhone() {
        let gameStats = ["Scores": [1,2,3]]
        session.sendMessage(gameStats, replyHandler: nil) { (error: NSError) in
            print(error)
        }
    }

}