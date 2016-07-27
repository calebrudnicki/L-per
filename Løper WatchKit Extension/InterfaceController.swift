//
//  InterfaceController.swift
//  Løper WatchKit Extension
//
//  Created by Caleb Rudnicki on 7/25/16.
//  Copyright © 2016 Caleb Rudnicki. All rights reserved.
//

import WatchKit
import Foundation
import WatchConnectivity

class InterfaceController: WKInterfaceController, WCSessionDelegate {

//MARK: Variables
    
    var session: WCSession!
    
    
//MARK: Boilerplate Functions
    
    override func awakeWithContext(context: AnyObject?) {
        super.awakeWithContext(context)
    }

    //This functions activates a session
    override func willActivate() {
        super.willActivate()
        if WCSession.isSupported() {
            session = WCSession.defaultSession()
            session.delegate = self
            session.activateSession()
        }
    }

    override func didDeactivate() {
        super.didDeactivate()
    }
    

//MARK: Actions

    //This functions calls sendMessageToPhone()
    @IBAction func startRunButtonTapped() {
        self.sendMessageToPhone()
    }
    
    
//MARK: Phone Connectivity
    
    //This functions sends a message to the phone
    func sendMessageToPhone() {
        let gameStats = ["Scores": [1,2,3]]
        session.sendMessage(gameStats, replyHandler: nil) { (error: NSError) in
            print(error)
        }
    }
    
}