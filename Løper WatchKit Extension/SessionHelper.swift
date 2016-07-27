//
//  SessionHelper.swift
//  Løper
//
//  Created by Caleb Rudnicki on 7/26/16.
//  Copyright © 2016 Caleb Rudnicki. All rights reserved.
//

import WatchKit
import WatchConnectivity

class SessionHelper: NSObject, WCSessionDelegate {
    
    var session: WCSession!
    
    func startSession() {
        if WCSession.isSupported() {
            session = WCSession.defaultSession()
            session.delegate = self
            session.activateSession()
        }
    }

}