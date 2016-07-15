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
    
    var distance: Double!
    var time: Double!
    var pace: Double!
    var locations: [CLLocation]!
    
    init(distance: Double, time: Double, pace: Double, locations: [CLLocation]) {
        self.distance = distance
        self.time = time
        self.pace = pace
        self.locations = locations
    }
    
}