//
//  Run.swift
//  Løper
//
//  Created by Caleb Rudnicki on 7/14/16.
//  Copyright © 2016 Caleb Rudnicki. All rights reserved.
//

import Foundation
import MapKit

class Run: CLLocationManager {
    
//MARK: Varbiables

    var distance: Double!
    var time: String!
    var pace: String!
    var locations: [CLLocation]!
    
    
//MARK: Initializers

    init(distance: Double, time: String, pace: String, locations: [CLLocation]) {
        self.distance = distance
        self.time = time
        self.pace = pace
        self.locations = locations
    }
    
}